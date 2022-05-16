import 'dart:async';

import 'package:bookie_driver/model/core/TripListModel.dart';
import 'package:bookie_driver/provider/location_provider.dart';
import 'package:bookie_driver/provider/shared_prefrence_provider.dart';
import 'package:bookie_driver/view/constants/constants.dart';
import 'package:bookie_driver/view/screens/activity/driver/unnecessaryScreen.dart';
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
import 'package:timeline_tile/timeline_tile.dart';
import '../../../../provider/DriverProvider.dart';
import '../../../../provider/GoogleMapProvider.dart';
import '../../../../provider/TripProvider.dart';
import '../../../constants/enum.dart';
import '../../../widgets/PopUpDialogs.dart';
import '../../../widgets/directions_repository.dart';
import '../../../widgets/dragContainerBody.dart';
import '../../../widgets/gradientContainer.dart';
import '../../../widgets/makeCall.dart';
import '../../../widgets/openSMSorCallDialog.dart';
import '../../../widgets/side_navigation.dart';
import '../../../widgets/vechileImageFetcher.dart';
import 'CallScreen.dart';
import 'onTrip.dart';

class DriverPickUp extends StatefulWidget {
  static String id = "DriverPickUp";
  AllRequestTrip model;
  String acceptTripId;
  String profilePhoto;
  DriverPickUp({
    Key? key,
    required this.model,
    required this.acceptTripId,
    required this.profilePhoto,
  }) : super(key: key);

  @override
  _HomeActivityState createState() =>
      _HomeActivityState(model, acceptTripId, profilePhoto);
}

class _HomeActivityState extends State<DriverPickUp> {
  AllRequestTrip model;
  String acceptTripId;
  TextEditingController destination = TextEditingController();
  SharedPreferenceProvider _sp = SharedPreferenceProvider();
  int endTime = DateTime.now().millisecondsSinceEpoch + 1000 * 30;
  bool isDriver = false;
  _HomeActivityState(this.model, this.acceptTripId, this.profilePhoto);
  var userName = "";
  var total;
  String profilePhoto;
  Completer<GoogleMapController> _mapController = Completer();
  Marker? originMarker, destinationMarker;
  Directions? destinationInformation;
  GoogleMapsProvider googleMapsProvider = GoogleMapsProvider();

  @override
  void initState() {
    super.initState();
    destination.text = "Select Destination";
    checkTripType();
  }

  Future<void> checkTripType() async {
    var type = await _sp.getStringValue(
      getEnumValue(TripType.tripType),
    );
    var isDriverTemp = await _sp.checkIfDriver("AccountType");
    setState(() => isDriverTemp ? isDriver = true : false);
    getUserData();
  }

  getUserData() async {
    userName = (await _sp.getStringValue(getEnumValue(UserDetails.userName)))!;
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
    double rate = double.parse(
      model.vehicleClass!.vehiclebasepriceSet!.first.rate,
    );
    double min = double.parse(
      model.vehicleClass!.vehiclebasepriceSet!.first.price,
    );
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
              Text(userName, style: kTextStyleHeader2),
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
                    Expanded(
                      child: Column(
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
                    ),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 50),
                      child: Text(
                        destinationInformation?.totalDuration ?? "",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 14,
                        ),
                      ),
                    )
                  ],
                ),
                SizedBox(height: 15),
                Column(
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
                SizedBox(height: 15),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Expanded(
                      child: Text(
                        "ZMW ${total}",
                        style: kTextStyleWhite,
                      ),
                    ),
                    Column(
                      children: [
                        Image.asset(
                          getVechileImage(
                                  carType: "${dataValue.vehicleClass?.name}") ??
                              "assets/images/car.png",
                          height: 25,
                        ),
                        Text(
                          "${destinationInformation?.totalDistance}",
                          style: TextStyle(
                              color: Colors.white, fontWeight: FontWeight.bold),
                        ),
                      ],
                    )
                  ],
                ),
                SizedBox(height: 10),
                Container(
                  child: dataValue.type.toString() == "BusinessToBusiness"
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
                      : SizedBox(height: 0),
                ),
                SizedBox(height: 15),
                Center(
                  child: RatingBar.builder(
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
                )
              ],
            ),
          ),
        ),
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

  Widget acceptanceOptions(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          SizedBox(
            height: 50,
            width: 130,
            child: ElevatedButton(
              onPressed: () {
                openSMSorCallDialog(
                  context: context,
                  phoneNumber: "${model.user?.phoneNumber}",
                );
              },
              style: ButtonStyle(
                shape: MaterialStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                ),
                backgroundColor:
                    MaterialStateProperty.all<Color>(const Color(0xFFFFD008)),
              ),
              child: Padding(
                padding: const EdgeInsets.all(12),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: const [
                    Icon(
                      FontAwesome.phone,
                      color: Colors.green,
                    ),
                    SizedBox(width: 20),
                    Icon(
                      FontAwesome.wechat,
                      color: Colors.black,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(
            height: 50,
            width: 130,
            child: ElevatedButton(
              onPressed: () async {
                //SEND ARRIVED NOTIFICATION
                var dialog = PopUpDialogs(context: context);
                dialog.showLoadingAnimation(context: context);
                var _provider = DriverProvider();
                await _provider.driverArrivedAtDestination(
                  requestTripId: model.id,
                );
                dialog.closeDialog();
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => UnnecessaryScreen(
                      model: model,
                      total: total.toString(),
                      acceptTripId: acceptTripId,
                      profilePhoto: profilePhoto,
                    ),
                  ),
                );
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
                padding: EdgeInsets.all(12),
                child: Center(
                  child: Text(
                    "Arrived",
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
