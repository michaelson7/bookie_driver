import 'dart:async';
import 'dart:convert';

import 'package:bookie_driver/model/core/AddDriverLocationModel.dart';
import 'package:bookie_driver/model/core/UserDataModel.dart';
import 'package:bookie_driver/provider/DriverProvider.dart';
import 'package:bookie_driver/provider/RegistrationProvider.dart';
import 'package:bookie_driver/provider/TripProvider.dart';
import 'package:bookie_driver/provider/location_provider.dart';
import 'package:bookie_driver/provider/shared_prefrence_provider.dart';
import 'package:bookie_driver/view/constants/constants.dart';
import 'package:bookie_driver/view/screens/activity/driver/driver_dashboard.dart';
import 'package:bookie_driver/view/screens/activity/setup/login_activity.dart';
import 'package:bookie_driver/view/widgets/logger_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:draggable_bottom_sheet/draggable_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:latlong2/latlong.dart';
import 'package:location/location.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../../constants/enum.dart';
import '../../../widgets/SpritePainter.dart';
import '../../../widgets/side_navigation.dart';
import '../../../widgets/toast.dart';
import 'DriverAcceptTrip.dart';
import 'driver_pickup.dart';

class DriverHomeInit extends StatefulWidget {
  static String id = "DriverHomeInit";
  const DriverHomeInit({Key? key}) : super(key: key);

  @override
  _HomeActivityState createState() => _HomeActivityState();
}

class _HomeActivityState extends State<DriverHomeInit>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late LocationData userLocation;
  bool isLoading = true;
  TripProvider tripProvider = TripProvider();
  TextEditingController destination = TextEditingController();
  RegistrationProvider registrationProvider = RegistrationProvider();
  LocationProvider _locationProvider = LocationProvider();
  SharedPreferenceProvider _sp = SharedPreferenceProvider();
  DriverProvider driverProvider = DriverProvider();
  MapController _mapController = MapController();
  String loadingText = "Updating Location";
  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 30;
  bool isDriver = false;
  String name = "userName";
  bool hasRequest = false;

  @override
  void initState() {
    destination.text = "Select Destination";
    _controller = new AnimationController(
      vsync: this,
    );
    getUserData();
    _startAnimation();
    checkTripType();
    UpdateDriverLocation();
    super.initState();
  }

  getUserData() async {
    name = (await _sp.getStringValue(getEnumValue(UserDetails.userName)))!;
  }

  Future<void> checkTripType() async {
    var type = await _sp.getStringValue(
      getEnumValue(TripType.tripType),
    );
    var isDriverTemp = await _sp.checkIfDriver("AccountType");
    setState(() => isDriverTemp ? isDriver = true : false);
    loggerInfo(message: "Trip Type ${isDriver}");
  }

  UpdateDriverLocation() async {
    // await registrationProvider.LoginUser(
    //     number: "0954512435", password: "Passwo rd123!");
    setState(() => isLoading = true);
    userLocation = (await _locationProvider.getUserLocation(context))!;
    var response = await registrationProvider.getUserId();
    UserDataModel userDataModel = UserDataModel.fromJson(
      response.data,
    );
    var updateResponse = await driverProvider.updateDriverLocation(
      jsonBody: {
        "driver": userDataModel.me?.driverSet[0].id,
        "latitude": userLocation.latitude,
        "longitude": userLocation.longitude,
      },
    );
    AddDriverLocationModel locationModel = AddDriverLocationModel.fromJson(
      updateResponse.data,
    );
    if (locationModel.addDriverLocation?.response == 200) {
      toastMessage(context: context, message: "Location Updated");
      _gotoLocation(
        userLocation.latitude ?? 0,
        userLocation.longitude ?? 0,
      );
      setState(() {
        loadingText = "Waiting for Trip Request";
      });
      await customerSearch();
    }
    setState(() => isLoading = false);
  }

  void _gotoLocation(double lat, double long) {
    _mapController.move(LatLng(lat, long), _mapController.zoom);
  }

  Future<void> customerSearch() async {
    int num = 0;
    while (!hasRequest) {
      await registrationProvider.getUserId();
      var data = await tripProvider.allTripRequests(jsonBody: {"": ""});
      if (data.allRequestTrip!.length > 0) {
        hasRequest = true;
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DriverAcceptTrip(model: data),
          ),
        );
      }
      loggerInfo(message: "PRINTING $num");
      num++;
      await Future.delayed(Duration(seconds: 6));
    }
  }

  @override
  void dispose() {
    _controller.dispose();
    tripProvider.dispose();
    setState(() => hasRequest = true);
    super.dispose();
  }

  void _startAnimation() {
    _controller.stop();
    _controller.reset();
    _controller.repeat(
      period: Duration(seconds: 1),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Color(0x54000000),
        elevation: 0,
        actions: [
          Row(
            children: [
              Text(name, style: kTextStyleHeader2),
              SizedBox(width: 8),
              Icon(FontAwesome.user_circle, color: Colors.grey[800]),
              SizedBox(width: 10),
            ],
          ),
        ],
      ),
      body: BottomDragInit(),
      drawer: buildDrawer(context: context, isDriver: isDriver),
    );
  }

  Widget BottomDragInit() {
    return DraggableBottomSheet(
      backgroundWidget: buildContainer(),
      previewChild: dragContainer(),
      expandedChild: dragContainer(),
      minExtent: 200,
      blurBackground: false,
      //maxExtent: MediaQuery.of(context).size.height * 0.8,
    );
  }

  Container buildContainer() {
    return Container(
      child: mapBody(),
    );
  }

  Container dragContainer() {
    return Container(
      decoration: BoxDecoration(
          borderRadius: kBorderRadiusCircular.copyWith(
            bottomLeft: Radius.circular(0),
            bottomRight: Radius.circular(0),
          ),
          color: Colors.white),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: SizedBox(
              height: 7,
              width: 45,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: kBorderRadiusCircularPro,
                  color: Colors.grey,
                ),
              ),
            ),
          ),
          Text(loadingText),
          CustomPaint(
            painter: new SpritePainter(_controller),
            child: new SizedBox(
              width: 150.0,
              height: 150.0,
            ),
          ),
        ],
      ),
    );
  }

  Widget mapBody() {
    return SizedBox(
      child: FlutterMap(
        mapController: _mapController,
        options: MapOptions(
          center: isLoading
              ? LatLng(-15.3868807, 28.3478416)
              : LatLng(
                  double.parse(userLocation.latitude.toString()),
                  double.parse(userLocation.longitude.toString()),
                ),
          zoom: 15.0,
        ),
        layers: [
          TileLayerOptions(
            urlTemplate: "https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png",
            subdomains: ['a', 'b', 'c'],
            attributionBuilder: (_) {
              return Text("© OpenStreetMap contributors");
            },
          ),
          MarkerLayerOptions(
            markers: [
              mapMarkers(
                latitude: isLoading
                    ? -15.3868807
                    : double.parse(
                        userLocation.latitude.toString(),
                      ),
                longitude: isLoading
                    ? 28.3478416
                    : double.parse(
                        userLocation.longitude.toString(),
                      ),
                title: 'Driver',
              ),
            ],
          ),
        ],
      ),
    );
  }

  mapMarkers({
    required double latitude,
    required double longitude,
    required String title,
  }) {
    return Marker(
      width: 300.0,
      height: 200.0,
      point: LatLng(latitude, longitude),
      builder: (ctx) => Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset("assets/images/Pickup.png", height: 50),
          ],
        ),
      ),
    );
  }

  callme() async {
    await Future.delayed(Duration(seconds: 1));
    return "success";
  }
}
