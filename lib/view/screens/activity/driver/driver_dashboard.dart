import 'package:bookie_driver/provider/RegistrationProvider.dart';
import 'package:bookie_driver/view/constants/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:intl/intl.dart';

import '../../../../model/core/DriverAllTripModels.dart';
import '../../../../model/core/DriverStatsModel.dart';
import '../../../../model/core/TripDriverHistory.dart';
import '../../../../model/core/UserDataModel.dart';
import '../../../../model/core/dateFilterModel.dart';
import '../../../../provider/DriverProvider.dart';
import '../../../../provider/shared_prefrence_provider.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';

import '../../../widgets/roundedContainer.dart';
import '../../../widgets/side_navigation.dart';
import '../../../widgets/tripData.dart';

class DriverDashboard extends StatefulWidget {
  String profilePhoto;
  DriverDashboard({Key? key, required this.profilePhoto}) : super(key: key);

  @override
  _DriverDashboardState createState() => _DriverDashboardState(profilePhoto);
}

class _DriverDashboardState extends State<DriverDashboard> {
  int _currentIndex = 0;
  String profilePhoto;
  bool isActive_1 = true,
      isActive_3 = false,
      isActive_2 = false,
      isLoading = true;
  SharedPreferenceProvider _sp = SharedPreferenceProvider();
  bool isDriver = false;
  var widgetListBottom = [];
  var widgetListTop = [];
  var registrationProvider = RegistrationProvider();
  UserDataModel? userDataModel;
  _DriverDashboardState(this.profilePhoto);
  bool showb2c = true,
      today = true,
      week = false,
      month = false,
      allTime = false;
  Duration? totalTime;
  DriverAllTripHostory? driverAllTripHostory;
  DateFilterModel? dateFilterModel;
  DriverStatsModel? driverStatsModel;
  TripDriverHistory? tripDriverHistory;
  var _provider = DriverProvider();
  @override
  void initState() {
    super.initState();

    checkTripType();
    getData();
  }

  resetActiveStatus() {
    isActive_1 = false;
    isActive_3 = false;
    isActive_2 = false;
  }

  Future<void> checkTripType() async {
    var isDriverTemp = await _sp.checkIfDriver("AccountType");
    setState(() => isDriverTemp ? isDriver = true : false);
  }

  getData() async {
    var tempDate = await _provider.dateFilte(filter: "day");
    var data = await registrationProvider.getUserId();
    var driverAllTripHostoryTemp = await _provider.getDriverTrips();
    var driverStatsModelTemp = await _provider.getDriverStats();
    var temp = await _provider.driverSpecificTrips();

    //hours online
    int totalTrips = driverStatsModelTemp.totalTrips ?? 0;
    var math = (totalTrips * 20);
    var d = Duration(minutes: math.ceil());
    var totalTimeTemp = d;

    setState(() {
      totalTime = totalTimeTemp;
      dateFilterModel = tempDate;
      driverAllTripHostory = driverAllTripHostoryTemp;
      driverStatsModel = driverStatsModelTemp;
      tripDriverHistory = temp;
      userDataModel = UserDataModel.fromJson(
        data.data!,
      );
    });

    widgetListBottom = [
      tripsTodayBody(),
      walletSection(),
      ActivitySection(),
    ];
    widgetListTop = [
      tripSummary(),
      moneySection(),
      userDetailsSection(),
    ];
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kAccent,
      appBar: AppBar(
        backgroundColor: kAccent,
        title: Text(
          'Dashboard',
          style: TextStyle(fontSize: 20),
        ),
      ),
      body: SafeArea(
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : Stack(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFFAD29DA),
                          Color(0xFFAD29DA),
                          Color(0xFFAD29DA),
                          Color(0xFFD348AE)
                        ],
                      ),
                    ),
                  ),
                  SafeArea(child: buildContainer())
                ],
              ),
      ),
    );
  }

  Widget buildContainer() {
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20),
          tabsSectionPro(),
          SizedBox(height: 15),
          tabsSection(),
        ],
      ),
    );
  }

  Widget tabsSectionPro() {
    return widgetListTop[_currentIndex];
  }

  Widget tabsSection() {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Center(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: kBorderRadiusCircularPro,
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  tabButtons(
                    title: "TRIPS",
                    isActive: isActive_1,
                    function: () {
                      setState(() {
                        resetActiveStatus();
                        isActive_1 = true;
                        _currentIndex = 0;
                      });
                    },
                  ),
                  tabButtons(
                    title: "WALLET",
                    isActive: isActive_2,
                    function: () {
                      setState(() {
                        resetActiveStatus();
                        isActive_2 = true;
                        _currentIndex = 1;
                      });
                    },
                  ),
                  tabButtons(
                    title: "ACTIVITY",
                    isActive: isActive_3,
                    function: () {
                      setState(() {
                        resetActiveStatus();
                        isActive_3 = true;
                        _currentIndex = 2;
                      });
                    },
                  ),
                ],
              ),
            ),
          ),
          SizedBox(height: 15),
          widgetListBottom[_currentIndex]
        ],
      ),
    );
  }

  /*TOP TABS*/
  Widget tripSummary() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            timeButtons(
              label: "Today",
              function: () async {
                var temp = await _provider.dateFilte(filter: "day");
                setState(() {
                  dateFilterModel = temp;
                  today = true;
                  week = false;
                  month = false;
                  allTime = false;
                  widgetListTop[0] = tripSummary();
                  widgetListBottom[0] = tripsTodayBody();
                });
              },
              selected: today,
            ),
            timeButtons(
              label: "Week",
              function: () async {
                var temp = await _provider.dateFilte(filter: "week");
                setState(() {
                  dateFilterModel = temp;
                  today = false;
                  week = true;
                  month = false;
                  allTime = false;
                  widgetListTop[0] = tripSummary();
                  widgetListBottom[0] = tripsTodayBody();
                });
              },
              selected: week,
            ),
            timeButtons(
              label: "Month",
              function: () async {
                var temp = await _provider.dateFilte(filter: "month");
                setState(() {
                  dateFilterModel = temp;
                  today = false;
                  week = false;
                  month = true;
                  allTime = false;
                  widgetListTop[0] = tripSummary();
                  widgetListBottom[0] = tripsTodayBody();
                });
              },
              selected: month,
            ),
            timeButtons(
              label: "All Time",
              function: () async {
                var temp = await _provider.dateFilte(filter: "");
                setState(() {
                  dateFilterModel = temp;
                  today = false;
                  week = false;
                  month = false;
                  allTime = true;
                  widgetListTop[0] = tripSummary();
                  widgetListBottom[0] = tripsTodayBody();
                });
              },
              selected: allTime,
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              tripContainer(
                title: "Trips",
                value: "${driverStatsModel?.totalTrips}",
              ),
              tripContainer(
                title: "Online",
                value: totalTime!.inHours > 0
                    ? "${totalTime!.inHours} hrs"
                    : "${totalTime!.inMinutes} Min",
              ),
              tripContainer(
                title: "Earned",
                value: "K ${driverStatsModel?.totalEarnings}",
              ),
            ],
          ),
        )
      ],
    );
  }

  Widget moneySection() {
    Widget walletCardsTop({
      required imagePath,
      required key,
      required value,
      required color,
    }) {
      return Expanded(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: RoundedContainer(
            color: color,
            borderRadius: 28,
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Image.asset(
                    imagePath,
                    height: 50,
                    width: 50,
                  ),
                  SizedBox(width: 15),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        key,
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                      Text(
                        value,
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        walletCardsTop(
          imagePath: "assets/images/income.png",
          key: "Income",
          value: "K${driverStatsModel?.totalEarnings}",
          color: Color(0xFF00A86B),
        ),
        walletCardsTop(
          imagePath: "assets/images/wallte.png",
          key: "Wallet",
          value: "K${driverStatsModel?.availableBalance}",
          color: Color(0xFFABABAB),
        ),
      ],
    );
  }

  Padding userDetailsSection() {
    Column userDetail({required key, required value}) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 15),
          Text(
            key,
            style: TextStyle(
              fontSize: 13,
              color: Colors.grey[500],
            ),
          ),
          Text(
            value,
            style: TextStyle(
              color: Colors.grey[600],
            ),
          ),
        ],
      );
    }

    DateFormat dateFormat = DateFormat("yyyy-MM-dd");
    DateTime dateTime =
        dateFormat.parse(driverStatsModel!.registeredDate!.toString());
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: RoundedContainer(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "${userDataModel?.me?.firstName} ${userDataModel?.me?.lastName}",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                      ),
                    ),
                    userDetail(
                      key: "Department",
                      value: "${driverStatsModel?.driverDepartment?.name}",
                    ),
                    userDetail(
                        key: "Joined",
                        value:
                            "${dateTime.day}/${dateTime.month}/${dateTime.year}"),
                    userDetail(
                        key: "Experience and Skills",
                        value:
                            "${userDataModel?.me?.driverSet?.first.skills?.first.name}"),
                  ],
                ),
              ),
              Expanded(
                child: CachedNetworkImage(
                  imageUrl: userDataModel!.me!.profilepictureSet!.isNotEmpty
                      ? "${userDataModel!.me!.profilepictureSet!.first.image}"
                      : "",
                  fit: BoxFit.cover,
                  errorWidget: (context, url, error) => Icon(
                    FontAwesome.user_circle,
                    color: Colors.grey[800],
                    size: 50,
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
  /*TOP TABS*/

  /*BOTTOM TABS*/
  Widget tripsTodayBody() {
    ListView listViewPro() {
      return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: dateFilterModel!.dateFilter!.length,
        itemBuilder: (context, i) {
          var dataValue = dateFilterModel!.dateFilter?[i];
          DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
          DateTime dateTime =
              dateFormat.parse(dataValue!.createdDate!.toString());
          return tripData(
            car: dataValue.driver!.drivervehicleSet!.isNotEmpty
                ? "${dataValue.driver?.drivervehicleSet?.first.modelName}"
                : "",
            carColor: dataValue.driver!.drivervehicleSet!.isNotEmpty
                ? "${dataValue.driver?.drivervehicleSet?.first.modelColor}"
                : "",
            time:
                "${dateTime.hour.toString().padLeft(2, "0")}:${dateTime.minute.toString().padRight(2, "0")}",
            location: "${dataValue?.start?.name} - ${dataValue?.end?.name}",
            amount: dataValue.type == "CustomerToBusiness"
                ? "${dataValue?.amount}"
                : "-",
            ratingVal: dataValue!.driverratingsSet!.isNotEmpty
                ? double.parse(
                    dataValue!.driverratingsSet!.first.rateLevel.toString(),
                  )
                : 0.0,
          );
        },
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Recent Trips", style: kTextStyleHeader2),
        SizedBox(height: 8),
        dateFilterModel!.dateFilter != null
            ? listViewPro()
            : const Padding(
                padding: EdgeInsets.all(50),
                child: Text("No Transactions Recorded", style: kTextStyleWhite),
              )
      ],
    );
  }

  Widget walletSection() {
    Widget walletItems({
      required String key,
      required String value,
      Color? keyColor,
      Color? valueColor,
    }) {
      return Container(
        width: 160,
        height: 185,
        decoration: BoxDecoration(
          borderRadius: kBorderRadiusCircular,
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                value,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 40,
                  color: valueColor,
                ),
              ),
              SizedBox(height: 10),
              Text(
                key,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: keyColor,
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            walletItems(
              key: "Driver Rating",
              value: "4.3",
            ),
            walletItems(
              key: "Acceptance Rate",
              value: "${driverStatsModel?.tripAcceptanceRate.toString()}",
              valueColor: Colors.green,
            ),
          ],
        ),
        SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            walletItems(
              key: "Trips Cancelled",
              keyColor: Colors.red,
              value: "${driverStatsModel?.totalTripCanceled.toString()}",
            ),
            walletItems(
              key: "Total Trips",
              value: "${driverStatsModel?.totalTrips.toString()}",
            ),
          ],
        ),
      ],
    );
  }

  Widget ActivitySection() {
    return Column(
      children: [
        Row(
          children: [
            InkWell(
              onTap: () {
                setState(() {
                  showb2c = true;
                  widgetListBottom[2] = ActivitySection();
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(60)),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: kBorderRadiusCircularPro,
                      color: showb2c ? kAccent : Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        "B2C",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10),
            InkWell(
              onTap: () {
                setState(() {
                  showb2c = false;
                  widgetListBottom[2] = ActivitySection();
                });
              },
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.all(Radius.circular(60)),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 6,
                    vertical: 2,
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: kBorderRadiusCircularPro,
                      color: !showb2c ? kAccent : Colors.white,
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Text(
                        "B2B",
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18),
                      ),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Text(
                "",
                textAlign: TextAlign.end,
                style: TextStyle(
                  fontSize: 25,
                  fontWeight: FontWeight.bold,
                ),
              ),
            )
          ],
        ),
        SizedBox(height: 20),
        showb2c
            ? tripDriverHistory!.c2BTrips != null
                ? listView()
                : Padding(
                    padding: const EdgeInsets.all(50),
                    child: Text("No Transactions Recorded",
                        style: kTextStyleWhite),
                  )
            : tripDriverHistory!.b2BTrips != null
                ? listView()
                : Padding(
                    padding: const EdgeInsets.all(50),
                    child: Text("No Transactions Recorded",
                        style: kTextStyleWhite),
                  )
      ],
    );
  }

  ListView listView() {
    return ListView.builder(
      shrinkWrap: true,
      physics: NeverScrollableScrollPhysics(),
      itemCount: showb2c
          ? tripDriverHistory!.c2BTrips != null
              ? tripDriverHistory!.c2BTrips?.length
              : 0
          : tripDriverHistory!.b2BTrips != null
              ? tripDriverHistory!.b2BTrips?.length
              : 0,
      itemBuilder: (context, i) {
        var dataValue = showb2c
            ? tripDriverHistory?.c2BTrips![i]
            : tripDriverHistory!.b2BTrips![i];
        DateFormat dateFormat = DateFormat("yyyy-MM-dd HH:mm:ss");
        DateTime dateTime =
            dateFormat.parse(dataValue!.createdDate!.toString());
        return tripData(
          car: dataValue.driver!.drivervehicleSet!.isNotEmpty
              ? "${dataValue.driver?.drivervehicleSet?.first.modelName}"
              : "",
          carColor: dataValue.driver!.drivervehicleSet!.isNotEmpty
              ? "${dataValue.driver?.drivervehicleSet?.first.modelColor}"
              : "",
          time:
              "${dateTime.hour}:${dateTime.minute.toString().padRight(2, "0")}",
          location: "${dataValue?.start?.name} - ${dataValue?.end?.name}",
          amount: !showb2c ? "-" : "${dataValue?.amount}",
          ratingVal: dataValue!.driverratingsSet!.isNotEmpty
              ? double.parse(
                  dataValue!.driverratingsSet!.first.rateLevel.toString(),
                )
              : 0.0,
        );
      },
    );
  }
  /*BOTTOM TABS*/

  Widget tabButtons({
    bool isActive = false,
    required title,
    required Function function,
  }) {
    return InkWell(
      onTap: () => function(),
      highlightColor: Colors.red,
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: kBorderRadiusCircularPro,
            color: isActive ? kAccent : Colors.white,
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 3),
            child: Text(
              title,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }

  Widget tripContainer({
    required String title,
    required String value,
  }) {
    return Expanded(
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black),
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Text(value, style: TextStyle(fontWeight: FontWeight.bold)),
              SizedBox(height: 5),
              Text(title, style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
    );
  }

  ElevatedButton timeButtons({
    required String label,
    required Function function,
    bool selected = false,
  }) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor:
            MaterialStateProperty.all<Color>(selected ? kAccent : Colors.white),
      ),
      onPressed: () => function(),
      child: Text(
        label,
        style: TextStyle(
          color: selected ? Colors.white : Colors.black,
        ),
      ),
    );
  }
}
