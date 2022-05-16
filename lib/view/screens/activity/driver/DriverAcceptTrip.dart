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
import 'package:stop_watch_timer/stop_watch_timer.dart';
import 'package:timeline_tile/timeline_tile.dart';
import 'package:url_launcher/url_launcher.dart';

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
import '../../../widgets/vechileImageFetcher.dart';
import 'driver_pickup.dart';

class DriverAcceptTrip extends StatefulWidget {
  static String id = "DriverHome";
  TripListModel model;
  String profilePhoto;
  DriverAcceptTrip({
    Key? key,
    required this.model,
    required this.profilePhoto,
  }) : super(key: key);

  @override
  _HomeActivityState createState() => _HomeActivityState(model, profilePhoto);
}

class _HomeActivityState extends State<DriverAcceptTrip> {
  TripListModel model;
  String profilePhoto;
  TextEditingController destination = TextEditingController();
  SharedPreferenceProvider _sp = SharedPreferenceProvider();
  LocationProvider locationProvider = LocationProvider();
  bool isDriver = false;
  var total;
  int tripCounter = 0, timerCounter = 0, baka = 1;
  String name = "userName";
  AllRequestTrip? allRequestTrip;
  _HomeActivityState(this.model, this.profilePhoto);
  final StopWatchTimer _stopWatchTimer = StopWatchTimer(
    mode: StopWatchMode.countDown,
    presetMillisecond: StopWatchTimer.getMilliSecFromSecond(30),
  ); // Create instance.
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
    _stopWatchTimer.onExecute.add(StopWatchExecute.start);
  }

  @override
  void dispose() async {
    super.dispose();
    _stopWatchTimer.dispose();
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
          model.allRequestTrip![tripCounter].pickupLocation!.latitude,
        ),
        'longitude': double.parse(
          model.allRequestTrip![tripCounter].pickupLocation!.longitude,
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
        model.allRequestTrip![tripCounter].endLocation!.latitude,
      ),
      double.parse(
        model.allRequestTrip![tripCounter].endLocation!.longitude,
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
    var destinationDistance = tripData!.totalDistance.split(" ").first;
    double rate = double.parse(model.allRequestTrip![tripCounter].vehicleClass!
        .vehiclebasepriceSet!.first.rate);
    double min = double.parse(model.allRequestTrip![tripCounter].vehicleClass!
        .vehiclebasepriceSet!.first.price);
    setState(() {
      //totalTime = "3";
      destinationMarker = destinationResult;
      destinationInformation = tripData;
      total = double.parse(destinationDistance) * rate;
      if (total < min) {
        total = min;
      }
      total = double.parse(total.toStringAsFixed(2));
    });

    //move to location
    await googleMapsProvider.goToDestinations(
      controllerData: _mapController,
      directionsInformation: destinationInformation,
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
          dragContainer(),
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

  Widget dragContainer() {
    return dragContainerBody(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          tripDetails(),
          acceptanceOptions(context),
          SizedBox(height: 20),
        ],
      ),
    );
  }

  tripDetails() {
    var dataValue = model.allRequestTrip![tripCounter];
    allRequestTrip = dataValue;
    var skillsList = "";

    try {
      if (dataValue.businessrequesttripSet!.isNotEmpty) {
        for (var data in dataValue.businessrequesttripSet!.first.skills!) {
          setState(() {
            skillsList = skillsList + data.name + " ,";
          });
        }
      }
    } on Exception catch (e) {
      // TODO
    }
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: SizedBox(
        width: double.infinity,
        child: gradientContainer(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
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
                const SizedBox(height: 15),
                dataValue.type.toString() == "BusinessToBusiness"
                    ? dataValue.businessrequesttripSet!.isNotEmpty
                        ? Text(
                            "Trip Description:\n${dataValue.businessrequesttripSet?.first.tripDescription}",
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          )
                        : const Text("NO TRIP DESCRIPTION")
                    : const SizedBox(height: 0),
                SizedBox(
                  height: dataValue.type.toString() == "BusinessToBusiness"
                      ? 15
                      : 0,
                ),
                dataValue.type.toString() == "BusinessToBusiness"
                    ? dataValue.businessrequesttripSet!.isNotEmpty
                        ? Text(
                            "Required Skills:\n${skillsList}",
                            textAlign: TextAlign.left,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 14,
                            ),
                          )
                        : const Text("NO REQUIRED SKILLS")
                    : const SizedBox(height: 0),
                SizedBox(
                  height: dataValue.type.toString() == "BusinessToBusiness"
                      ? 15
                      : 0,
                ),
                dataValue.type.toString() == "BusinessToBusiness"
                    ? dataValue.businessrequesttripSet!.isNotEmpty
                        ? Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Downloadable File:",
                                textAlign: TextAlign.left,
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 14,
                                ),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  var url = dataValue
                                      .businessrequesttripSet?.first.file;
                                  await _launchURL(url);
                                },
                                child: Text("Open File"),
                              ),
                            ],
                          )
                        : const Text("NO FILE UPLOADED", style: kTextStyleWhite)
                    : const SizedBox(height: 0),
                SizedBox(
                  height: dataValue.type.toString() == "BusinessToBusiness"
                      ? 15
                      : 0,
                ),
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
                          getVechileImage(
                                  carType: "${dataValue.vehicleClass?.name}") ??
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
            onPressed: () async {
              await rejectTrip(context);
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
              child: Text("Reject"),
            ),
          ),
          StreamBuilder<int>(
            stream: _stopWatchTimer.rawTime,
            initialData: 0,
            builder: (context, snap) {
              final value = snap.data;
              final displayTime = StopWatchTimer.getDisplayTime(
                value!,
                milliSecond: false,
                hours: false,
                minute: false,
              );
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
                  child: Text(displayTime),
                ),
              );
            },
          ),
          ElevatedButton(
            onPressed: () async {
              PopUpDialogs dialogs = PopUpDialogs(context: context);
              dialogs.showLoadingAnimation(context: context);
              RegistrationProvider registation = RegistrationProvider();
              var responseVal = await registation.getUserId();
              UserDataModel userDataModel = UserDataModel.fromJson(
                responseVal.data!,
              );
              TripProvider provider = TripProvider();
              var response = await provider.driverAcceptTrip(
                requestTripId: model.allRequestTrip?[tripCounter].id,
                driverId: userDataModel.me?.driverSet?.first.id,
              );

              if (response.addAcceptTrip?.response == "200") {
                dialogs.closeDialog();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => DriverPickUp(
                      profilePhoto: profilePhoto,
                      model: model.allRequestTrip![tripCounter],
                      acceptTripId:
                          response.addAcceptTrip?.acceptTrip?.id ?? "",
                    ),
                  ),
                );
              } else {
                dialogs.closeDialog();
                toastMessage(
                    context: context, message: response.addAcceptTrip?.message);
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

  Future<void> rejectTrip(BuildContext context) async {
    _stopWatchTimer.onExecute.add(StopWatchExecute.reset);
    _stopWatchTimer.onExecute.add(StopWatchExecute.start);
    var counter = tripCounter + 1;
    if (counter == model.allRequestTrip!.length) {
      toastMessage(
        context: context,
        message: "No More Available Trips, Scanning for more",
      );
      Navigator.pop(context);
    } else {
      setState(() {
        tripCounter = tripCounter + 1;
      });
      var dialog = PopUpDialogs(context: context);
      dialog.showLoadingAnimation(
        context: context,
        message: "Loading More Trips",
      );
      await setMap();
      dialog.closeDialog();
    }
  }

  _launchURL(url) async {
    try {
      await launch(
        url,
        enableJavaScript: true,
      );
    } catch (e) {
      toastMessage(context: context, message: "Could not open file");
    }
  }
}
