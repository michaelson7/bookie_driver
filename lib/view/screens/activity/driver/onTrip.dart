import 'dart:async';

import 'package:bookie_driver/model/core/TripListModel.dart';
import 'package:bookie_driver/provider/location_provider.dart';
import 'package:bookie_driver/view/screens/activity/driver/DriverHomeInit.dart';
import 'package:bookie_driver/view/widgets/timeline.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:draggable_bottom_sheet/draggable_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../../../provider/GoogleMapProvider.dart';
import '../../../../provider/TripProvider.dart';
import '../../../../provider/geoLocatorProvider.dart';
import '../../../../provider/shared_prefrence_provider.dart';
import '../../../constants/constants.dart';
import '../../../constants/enum.dart';
import '../../../widgets/PopUpDialogs.dart';
import '../../../widgets/directions_repository.dart';
import '../../../widgets/dragContainerBody.dart';
import '../../../widgets/gradientContainer.dart';
import '../../../widgets/side_navigation.dart';

class OnTrip extends StatefulWidget {
  static String id = "OnTrip";
  AllRequestTrip model;
  String profilePhoto;
  OnTrip({Key? key, required this.model, required this.profilePhoto})
      : super(key: key);

  @override
  _HomeActivityState createState() =>
      _HomeActivityState(model, this.profilePhoto);
}

class _HomeActivityState extends State<OnTrip> {
  TextEditingController destination = TextEditingController();
  SharedPreferenceProvider _sp = SharedPreferenceProvider();
  bool isDriver = false, isLoading = true;
  AllRequestTrip model;
  _HomeActivityState(this.model, this.profilePhoto);
  var total = 0.0;
  var currentTime = "";
  String profilePhoto;
  final StopWatchTimer _stopWatchTimer = StopWatchTimer(); // Create instance.
  var username = "";

  Completer<GoogleMapController> _mapController = Completer();
  Marker? originMarker, destinationMarker;
  Directions? destinationInformation;
  GoogleMapsProvider googleMapsProvider = GoogleMapsProvider();

  @override
  void initState() {
    super.initState();
    destination.text = "Select Destination";
    checkTripType();

    _stopWatchTimer.onExecute.add(StopWatchExecute.start);
    Timer _timer = Timer.periodic(const Duration(milliseconds: 30), (timer) {
      setState(() {});
    });
    setMap();
  }

  @override
  void dispose() async {
    super.dispose();
    _stopWatchTimer.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator(),
              )
            : Column(
                children: [
                  Expanded(child: buildContainer()),
                  dragContainer(),
                ],
              ),
      ),
    );
  }

  Widget dragableThing() {
    return DraggableBottomSheet(
      backgroundWidget: buildContainer(),
      previewChild: dragContainer(),
      expandedChild: dragContainer(),
      minExtent: 350,
      blurBackground: false,
    );
  }

  Widget buildContainer() {
    return Container(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
              width: double.infinity,
              child: StreamBuilder<int>(
                stream: _stopWatchTimer.rawTime,
                initialData: 0,
                builder: (context, snap) {
                  final value = snap.data;
                  final displayTime = StopWatchTimer.getDisplayTime(
                    value!,
                    milliSecond: false,
                  );
                  return Column(
                    children: <Widget>[
                      Text(
                        "On Trip",
                        style: TextStyle(
                          color: Colors.green,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8),
                        child: Text(
                          displayTime,
                          style: TextStyle(
                            color: Colors.green,
                          ),
                        ),
                      ),
                    ],
                  );
                },
              ),
            ),
          ),
          Expanded(child: mapBody()),
        ],
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
    return dragContainerBody(
      child: Column(
        children: [
          tripDetails(),
          acceptanceOptions(context),
        ],
      ),
    );
  }

  Widget tripDetails() {
    var dataValue = model;
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
                            imageUrl: dataValue
                                    .user!.profilepictureSet!.isNotEmpty
                                ? "${dataValue.user?.profilepictureSet!.first.image}"
                                : " ",
                            fit: BoxFit.cover,
                            errorWidget: (context, url, error) => Icon(
                              FontAwesome.user_circle,
                              color: Colors.grey[800],
                              size: 50,
                            ),
                          ),
                        ),
                        Text(
                          "${dataValue.user?.firstName} ${dataValue.user?.lastName}",
                          style: TextStyle(
                            color: Colors.white,
                          ),
                        )
                      ],
                    ),
                    Expanded(
                      child: Text(
                        "",
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 15),
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
                        "${model.pickupLocation?.name}",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    Container(
                      child: Text(
                        "${model.endLocation?.name}",
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                  indicators: <Widget>[
                    Icon(FontAwesome.circle_o, color: Colors.yellow, size: 15),
                    Icon(FontAwesome.circle_o, color: Colors.yellow, size: 15),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 7),
                      child: Column(
                        children: [
                          const Text(
                            "Total",
                            style: TextStyle(
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            model.type != "BusinessToBusiness"
                                ? "ZMW ${total.toStringAsFixed(2)}"
                                : "-",
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    RatingBar.builder(
                      itemSize: 20,
                      unratedColor: Colors.white,
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
                    Padding(
                      padding: const EdgeInsets.only(bottom: 15),
                      child: Column(
                        children: [
                          Image.asset(
                            "assets/images/car.png",
                            height: 30,
                          ),
                          Text(
                            "${destinationInformation?.totalDistance}",
                            style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget acceptanceOptions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          onPressed: () {
            Widget cancelButton = TextButton(
              child: Text("Cancel"),
              onPressed: () {
                Navigator.pop(context);
              },
            );
            Widget continueButton = TextButton(
              child: Text("Continue"),
              onPressed: () {
                Navigator.pop(context);
                completeTrip();
              },
            );
            AlertDialog alert = AlertDialog(
              title: Text(
                "Trip Completion",
                style: TextStyle(
                  fontSize: 15,
                ),
              ),
              content: Text(
                "Are you sure you want to end this trip?",
              ),
              actions: [
                cancelButton,
                continueButton,
              ],
            );
            showDialog(
              context: context,
              builder: (BuildContext context) {
                return alert;
              },
            );
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
            padding: const EdgeInsets.symmetric(
              horizontal: 30,
              vertical: 15,
            ),
            child: Text("End Trip"),
          ),
        ),
      ),
    );
  }

  //FUNCTIONS
  Future<void> checkTripType() async {
    var type = await _sp.getStringValue(
      getEnumValue(TripType.tripType),
    );
    var isDriverTemp = await _sp.checkIfDriver("AccountType");
    setState(() => isDriverTemp ? isDriver = true : false);
    await getTripData();
  }

  Future<void> getTripData() async {
    var tempName = await _sp.getStringValue(getEnumValue(UserDetails.userName));
    setState(() {
      username = tempName ?? "";
      isLoading = false;
    });
  }

  Future<void> setMap() async {
    //get user current location
    var userLocation = LocationData.fromMap(
      {
        'latitude': double.parse(
          model.pickupLocation!.latitude,
        ),
        'longitude': double.parse(
          model.pickupLocation!.longitude,
        ),
      },
    );
    var pickUpLocationResult = await googleMapsProvider.addUserLocationData(
      userLocation: userLocation,
      controllerData: _mapController,
    );
    setState(() => originMarker = pickUpLocationResult);

    //set destination
    LatLng location = LatLng(
      double.parse(
        model.endLocation!.latitude,
      ),
      double.parse(
        model.endLocation!.longitude,
      ),
    );
    var destinationResult = await googleMapsProvider.addMarker(
      pos: location,
      isDestination: true,
    );
    var tripData = await googleMapsProvider.getDirections(
      pos: location,
      originMarker: originMarker!,
    );
    var destinationDistance = tripData!.totalDistance.split(" ")[0];
    setState(() {
      //totalTime = "3";
      destinationMarker = destinationResult;
      destinationInformation = tripData;
      total = double.parse(destinationDistance) * 10;
    });

    //move to location
    await googleMapsProvider.goToDestinations(
      controllerData: _mapController,
      directionsInformation: destinationInformation,
    );
    getTripData();
  }

  Future<void> completeTrip() async {
    var tripProvider = TripProvider();
    var popUpDialog = PopUpDialogs(context: context);

    popUpDialog.showLoadingAnimation(context: context);
    var data = await tripProvider.updateTripData(
      jsonBody: {
        "id": model.id,
        "status": "COMPLETE",
      },
    );
    popUpDialog.closeDialog();
    if (data.updateRequestTrip?.response == "200") {
      _stopWatchTimer.dispose();
      Navigator.popAndPushNamed(context, DriverHomeInit.id);
    }
  }
}
