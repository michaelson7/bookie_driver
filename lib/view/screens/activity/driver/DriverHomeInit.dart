import 'dart:async';

import 'package:bookie_driver/model/core/AddDriverLocationModel.dart';
import 'package:bookie_driver/model/core/UserDataModel.dart';
import 'package:bookie_driver/provider/DriverProvider.dart';
import 'package:bookie_driver/provider/GoogleMapProvider.dart';
import 'package:bookie_driver/provider/RegistrationProvider.dart';
import 'package:bookie_driver/provider/TripProvider.dart';
import 'package:bookie_driver/provider/location_provider.dart';
import 'package:bookie_driver/provider/shared_prefrence_provider.dart';
import 'package:bookie_driver/view/constants/constants.dart';
import 'package:bookie_driver/view/widgets/gradientButton.dart';
import 'package:bookie_driver/view/widgets/logger_widget.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:draggable_bottom_sheet/draggable_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';

import '../../../constants/enum.dart';
import '../../../widgets/SpritePainter.dart';
import '../../../widgets/directions_repository.dart';
import '../../../widgets/side_navigation.dart';
import '../../../widgets/toast.dart';
import 'DriverAcceptTrip.dart';

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
  bool isOnline = false;
  TripProvider tripProvider = TripProvider();
  TextEditingController destination = TextEditingController();
  RegistrationProvider registrationProvider = RegistrationProvider();
  LocationProvider _locationProvider = LocationProvider();
  SharedPreferenceProvider _sp = SharedPreferenceProvider();
  DriverProvider driverProvider = DriverProvider();
  String loadingText = "Updating Location";
  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 30;
  bool isDriver = false;
  String name = "userName";
  bool hasRequest = false;
  var profilePhoto;
  double size = 50;
  Completer<GoogleMapController> _mapController = Completer();
  Marker? originMarker, destinationMarker;
  Directions? destinationInformation;
  GoogleMapsProvider googleMapsProvider = GoogleMapsProvider();

  @override
  void initState() {
    destination.text = "Select Destination";
    _controller = AnimationController(
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
    setState(() => isLoading = true);
    var sp = SharedPreferenceProvider();
    var photo = await sp.getStringValue(getEnumValue(UserDetails.userPhoto));
    setState(() => profilePhoto = photo);
    userLocation = (await _locationProvider.getUserLocation(context))!;

    //set maps
    await googleMapsProvider.addUserLocationData(
      userLocation: userLocation,
      controllerData: _mapController,
    );

    var response = await registrationProvider.getUserId();
    UserDataModel userDataModel = UserDataModel.fromJson(
      response.data!,
    );
    var updateResponse = await driverProvider.updateDriverLocation(
      jsonBody: {
        "driver": userDataModel.me?.driverSet?[0].id,
        "latitude": userLocation.latitude,
        "longitude": userLocation.longitude,
      },
    );
    AddDriverLocationModel locationModel = AddDriverLocationModel.fromJson(
      updateResponse.data,
    );
    if (locationModel.addDriverLocation?.response == 200) {}
    setState(() => isLoading = false);
  }

  Future<void> customerSearch() async {
    int num = 0;
    while (!hasRequest) {
      await registrationProvider.getUserId();
      var data = await tripProvider.allTripRequests(jsonBody: {"": ""});
      if (data.allRequestTrip!.length > 0) {
        hasRequest = true;
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => DriverAcceptTrip(
              model: data,
              profilePhoto: profilePhoto,
            ),
          ),
        );
        setState(() {
          isOnline = false;
        });
      }
      loggerInfo(message: "PRINTING $num");
      num++;
      await Future.delayed(Duration(seconds: 6));
    }
  }

  @override
  void dispose() {
    // _controller.dispose();
    // tripProvider.dispose();
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
              ClipRRect(
                borderRadius: kBorderRadiusCircularPro,
                child: CachedNetworkImage(
                  height: 35.0,
                  width: 35.0,
                  imageUrl: profilePhoto,
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => Icon(
                    FontAwesome.user_circle,
                    color: Colors.grey[800],
                    size: 35,
                  ),
                ),
              ),
              SizedBox(width: 10),
            ],
          ),
        ],
      ),
      body: Column(
        children: [
          Expanded(child: mapBody()),
          isOnline ? offlineButton() : onlineButton(),
          SizedBox(height: 20),
        ],
      ),
      drawer: buildDrawer(
        context: context,
        isDriver: isDriver,
        profilePhoto: profilePhoto,
        userName: name,
      ),
    );
  }

  Widget mapBody() {
    return GoogleMap(
      mapType: MapType.normal,
      initialCameraPosition: googleMapsProvider.defaultDestination,
      zoomControlsEnabled: false,
      onMapCreated: (GoogleMapController controller) {
        _mapController.complete(controller);
      },
      markers: {
        if (originMarker != null) originMarker!,
        if (destinationMarker != null) destinationMarker!
      },
      polylines: {
        if (destinationInformation != null)
          Polyline(
            polylineId: const PolylineId('overview_polyline'),
            color: Colors.orange,
            width: 8,
            points: destinationInformation!.polylinePoints
                .map((e) => LatLng(e.latitude, e.longitude))
                .toList(),
          ),
      },
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

  Widget onlineButton() {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  setState(() {
                    loadingText = "Waiting for Trip Request";
                    isOnline = true;
                    size = 200;
                  });
                  await customerSearch();
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  backgroundColor:
                      MaterialStateProperty.all<Color>(Colors.green),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text("Go Online"),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget offlineButton() {
    return Container(
      color: Colors.white,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(15),
            child: SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  setState(() {
                    isOnline = false;
                    size = 200;
                  });
                },
                style: ButtonStyle(
                  shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20.0),
                    ),
                  ),
                  backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(15),
                  child: Text("Go Offline"),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
