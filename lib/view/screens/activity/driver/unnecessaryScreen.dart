import 'dart:async';

import 'package:bookie_driver/provider/RegistrationProvider.dart';
import 'package:bookie_driver/view/widgets/timeline.dart';
import 'package:bookie_driver/view/widgets/toast.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:draggable_bottom_sheet/draggable_bottom_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_countdown_timer/current_remaining_time.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:location/location.dart';
import 'package:timeline_tile/timeline_tile.dart';

import '../../../../model/core/TripListModel.dart';
import '../../../../model/core/UserDataModel.dart';
import '../../../../provider/GoogleMapProvider.dart';
import '../../../../provider/TripProvider.dart';
import '../../../../provider/geoLocatorProvider.dart';
import '../../../../provider/location_provider.dart';
import '../../../../provider/shared_prefrence_provider.dart';
import '../../../constants/constants.dart';
import '../../../constants/enum.dart';
import '../../../widgets/PopUpDialogs.dart';
import '../../../widgets/directions_repository.dart';
import '../../../widgets/dragContainerBody.dart';
import '../../../widgets/gradientContainer.dart';
import '../../../widgets/logger_widget.dart';
import '../../../widgets/side_navigation.dart';
import 'DriverHomeInit.dart';
import 'driver_pickup.dart';
import 'onTrip.dart';

class UnnecessaryScreen extends StatefulWidget {
  static String id = "UnnecessaryScreen";
  AllRequestTrip model;
  String acceptTripId;
  String profilePhoto;
  String total;
  UnnecessaryScreen(
      {Key? key,
      required this.total,
      required this.model,
      required this.acceptTripId,
      required this.profilePhoto})
      : super(key: key);

  @override
  _HomeActivityState createState() =>
      _HomeActivityState(model, acceptTripId, profilePhoto, total);
}

class _HomeActivityState extends State<UnnecessaryScreen> {
  AllRequestTrip model;
  TextEditingController destination = TextEditingController();
  SharedPreferenceProvider _sp = SharedPreferenceProvider();
  LocationProvider locationProvider = LocationProvider();
  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 30;
  bool isDriver = false;
  String total;
  String profilePhoto;
  String name = "userName";
  AllRequestTrip? allRequestTrip;
  String acceptTripId;
  _HomeActivityState(
      this.model, this.acceptTripId, this.profilePhoto, this.total);

  Completer<GoogleMapController> _mapController = Completer();
  Marker? originMarker, destinationMarker;
  Directions? destinationInformation;
  GoogleMapsProvider googleMapsProvider = GoogleMapsProvider();

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
    setMap();
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
    });

    //move to location
    await googleMapsProvider.goToDestinations(
      controllerData: _mapController,
      directionsInformation: destinationInformation,
    );
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
      Navigator.popAndPushNamed(context, DriverHomeInit.id);
    }
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
          dragContainer(),
          SizedBox(height: 20),
        ],
      ),
      // drawer: buildDrawer(
      //   context: context,
      //   isDriver: isDriver,
      //   profilePhoto: profilePhoto,
      // ),
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
            color: kAccent,
            width: 5,
            points: destinationInformation!.polylinePoints
                .map((e) => LatLng(e.latitude, e.longitude))
                .toList(),
          ),
      },
    );
  }

  Widget dragContainer() {
    return dragContainerBody(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          tripDetails(),
          acceptanceOptions(context),
        ],
      ),
    );
  }

  tripDetails() {
    var dataValue = model;
    allRequestTrip = dataValue;
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity,
        child: gradientContainer(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
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
                            style: TextStyle(color: Colors.white))
                      ],
                    ),
                    Expanded(
                      child: Text(
                        "",
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
                        "${destinationInformation?.totalDuration}",
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
                                  "${dataValue.pickupLocation?.name}",
                                  style: TextStyle(color: Colors.white),
                                ),
                              ),
                              Container(
                                child: Text(
                                  "${dataValue.endLocation?.name}",
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
                  ],
                ),
                SizedBox(height: 15),
                Row(
                  children: [
                    dataValue.type.toString() == "BusinessToBusiness"
                        ? const Center(
                            child: Text(
                              "Total\n-",
                              style: kTextStyleWhite,
                              textAlign: TextAlign.center,
                            ),
                          )
                        : Center(
                            child: Text(
                              "Total\n$total ZMW",
                              style: kTextStyleWhite,
                              textAlign: TextAlign.center,
                            ),
                          ),
                    Expanded(
                      child: Center(
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
                      ),
                    ),
                    Column(
                      children: [
                        Image.asset(
                          "assets/images/car.png",
                          height: 30,
                        ),
                        Text(
                          "${destinationInformation?.totalDistance.toString()}",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
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
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          ElevatedButton(
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
            child: const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 15,
              ),
              child: Text("Stop Trip"),
            ),
          ),
          ElevatedButton(
            onPressed: () async {
              PopUpDialogs dialogs = PopUpDialogs(context: context);
              dialogs.showLoadingAnimation(context: context);
              TripProvider provider = TripProvider();
              // var response = await provider.updateTripData(jsonBody: {
              //   "id": "${model.allRequestTrip?[0].id}",
              //   "status": "ON TRIP",
              // });
              var dataValue = model;
              var tripResponse = await provider.addTripData(
                acceptId: acceptTripId,
                endLocationName: dataValue.endLocation?.name,
                endLocationLatituide: dataValue.endLocation?.latitude,
                endLocationLongitude: dataValue.endLocation?.longitude,
                startLocationName: dataValue.pickupLocation?.name,
                startLocationLatituide: dataValue.pickupLocation?.latitude,
                startLocationLongitude: dataValue.pickupLocation?.longitude,
              );
              dialogs.closeDialog();
              if (tripResponse.addTrip?.response == 200) {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => OnTrip(
                      model: model,
                      tripId: tripResponse.addTrip!.trip!.id!,
                      profilePhoto: profilePhoto,
                    ),
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
            child: const Padding(
              padding: EdgeInsets.symmetric(
                horizontal: 30,
                vertical: 15,
              ),
              child: Text("Start Trip"),
            ),
          ),
        ],
      ),
    );
  }
}
