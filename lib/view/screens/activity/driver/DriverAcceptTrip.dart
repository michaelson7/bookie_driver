import 'package:bookie_driver/view/widgets/timeline.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:latlong2/latlong.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../../../model/core/TripListModel.dart';
import '../../../../provider/TripProvider.dart';
import '../../../../provider/geoLocatorProvider.dart';
import '../../../../provider/location_provider.dart';
import '../../../../provider/shared_prefrence_provider.dart';
import '../../../constants/constants.dart';
import '../../../constants/enum.dart';
import '../../../widgets/PopUpDialogs.dart';
import '../../../widgets/gradientContainer.dart';
import '../../../widgets/logger_widget.dart';
import '../../../widgets/side_navigation.dart';
import 'driver_pickup.dart';

class DriverAcceptTrip extends StatefulWidget {
  static String id = "DriverHome";
  TripListModel model;
  DriverAcceptTrip({Key? key, required this.model}) : super(key: key);
  @override
  _HomeActivityState createState() => _HomeActivityState(model);
}

class _HomeActivityState extends State<DriverAcceptTrip> {
  TripListModel model;
  TextEditingController destination = TextEditingController();
  SharedPreferenceProvider _sp = SharedPreferenceProvider();
  LocationProvider locationProvider = LocationProvider();
  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 30;
  bool isDriver = false;
  String name = "userName";

  _HomeActivityState(this.model);

  @override
  void initState() {
    super.initState();
    destination.text = "Select Destination";
    checkTripType();
    getUserData();
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
      body: buildContainer(),
      drawer: buildDrawer(context: context, isDriver: isDriver),
    );
  }

  Container buildContainer() {
    return Container(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(child: mapBody()),
          tripDetails(),
          acceptanceOptions(context),
        ],
      ),
    );
  }

  Widget mapBody() {
    return SizedBox(
      child: FlutterMap(
        options: MapOptions(
          center: LatLng(-15.3868807, 28.3478416),
          zoom: 13.0,
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
                latitude: -15.400358,
                longitude: 28.323056,
                title: 'Driver 3',
              ),
            ],
          ),
        ],
      ),
    );
  }

  tripDetails() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: 1,
      itemBuilder: (context, i) {
        var dataValue = model.allRequestTrip![i];
        var locationDistance = locationProvider.calculateDistance(
          double.parse(dataValue.pickupLocation?.latitude ?? ""),
          double.parse(dataValue.pickupLocation?.longitude ?? ""),
          double.parse(dataValue.pickupLocation?.latitude ?? ""),
          double.parse(dataValue.pickupLocation?.longitude ?? ""),
        );
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
            width: double.infinity,
            child: gradientContainer(
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            ClipRRect(
                              borderRadius:
                                  BorderRadius.all(Radius.elliptical(30, 30)),
                              child: CachedNetworkImage(
                                height: 50.0,
                                width: 50.0,
                                imageUrl:
                                    "https://images.unsplash.com/photo-1553272725-086100aecf5e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDF8MHxlZGl0b3JpYWwtZmVlZHw2fHx8ZW58MHx8fHw%3D&auto=format&fit=crop&w=500&q=60",
                                fit: BoxFit.cover,
                              ),
                            ),
                            Text(
                                "${dataValue.user.firstName} ${dataValue.user.lastName}",
                                style: TextStyle(color: Colors.white))
                          ],
                        ),
                        Expanded(
                          child: Text(
                            "Designated stop over points",
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.only(bottom: 50),
                          child: Text(
                            "1h 02m",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          ),
                        )
                      ],
                    ),
                    SizedBox(height: 15),
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(
                          child: Column(
                            children: [
                              TimelineTile(
                                alignment: TimelineAlign.start,
                                endChild: Container(
                                  color: Colors.amberAccent,
                                ),
                              ),
                              Timeline(
                                itemGap: 3,
                                padding: EdgeInsets.zero,
                                lineColor: Colors.yellow,
                                indicatorColor: Colors.yellow,
                                children: <Widget>[
                                  Container(
                                    child: Text(
                                      "${dataValue.pickupLocation?.LocationName}",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                  Container(
                                    child: Text(
                                      "${dataValue.endLocation?.LocationName}",
                                      style: TextStyle(color: Colors.white),
                                    ),
                                  ),
                                ],
                                indicators: <Widget>[
                                  Icon(FontAwesome.circle_o,
                                      color: Colors.yellow, size: 15),
                                  Icon(FontAwesome.circle_o,
                                      color: Colors.yellow, size: 15),
                                ],
                              ),
                            ],
                          ),
                        ),
                        Column(
                          children: [
                            Image.asset(
                              "assets/images/car.png",
                              height: 30,
                            ),
                            Text(
                              "${locationDistance.toStringAsFixed(2)} km",
                              style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold),
                            ),
                          ],
                        )
                      ],
                    ),
                    SizedBox(height: 15),
                    Center(
                      child: RatingBar.builder(
                        unratedColor: Colors.white,
                        itemSize: 20,
                        initialRating: 3,
                        minRating: 1,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        itemPadding: EdgeInsets.symmetric(horizontal: 4.0),
                        itemBuilder: (context, _) => Icon(
                          Icons.star,
                          color: Colors.amber,
                        ),
                        onRatingUpdate: (rating) {
                          print(rating);
                        },
                      ),
                    )
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget acceptanceOptions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ElevatedButton(
            onPressed: () {},
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.red),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 15,
              ),
              child: Text("Reject"),
            ),
          ),
          CountdownTimer(
            endTime: endTime,
            widgetBuilder: (context, CurrentRemainingTime? time) {
              if (time == null) {
                return Text('0');
              }
              return Container(
                decoration: BoxDecoration(
                  border: Border.all(
                    width: 1,
                    color: Colors.red,
                  ),
                  borderRadius: BorderRadius.all(Radius.circular(365)),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(time.sec.toString()),
                ),
              );
            },
          ),
          ElevatedButton(
            onPressed: () async {
              PopUpDialogs dialogs = PopUpDialogs(context: context);
              dialogs.showLoadingAnimation(context: context);
              TripProvider provider = TripProvider();
              var response = await provider.updateTripData(jsonBody: {
                "id": "${model.allRequestTrip?[0].id}",
                "status": "WAITING",
              });
              dialogs.closeDialog();
              if (response.updateRequestTrip?.response == "200") {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DriverPickUp(model: model),
                  ),
                );
              }
            },
            style: ButtonStyle(
              shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
              ),
              backgroundColor: MaterialStateProperty.all<Color>(Colors.green),
            ),
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 15,
              ),
              child: Text("Accept"),
            ),
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
