import 'package:bookie_driver/view/constants/constants.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import '../../../../provider/shared_prefrence_provider.dart';
import 'package:bubble_tab_indicator/bubble_tab_indicator.dart';

import '../../../widgets/roundedContainer.dart';
import '../../../widgets/side_navigation.dart';
import '../../../widgets/tripData.dart';

class DriverDashboard extends StatefulWidget {
  static String id = "DriverDashboard";
  const DriverDashboard({Key? key}) : super(key: key);

  @override
  _DriverDashboardState createState() => _DriverDashboardState();
}

class _DriverDashboardState extends State<DriverDashboard> {
  int _currentIndex = 0;
  bool isActive_1 = true, isActive_3 = false, isActive_2 = false;
  SharedPreferenceProvider _sp = SharedPreferenceProvider();
  bool isDriver = false;
  var widgetListBottom = [];
  var widgetListTop = [];

  @override
  void initState() {
    super.initState();
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
    checkTripType();
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
        child: buildContainer(),
      ),
      drawer: buildDrawer(context: context, isDriver: isDriver),
      bottomNavigationBar: offlineButton(),
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
          //ActivitySection()
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
              function: () {},
            ),
            timeButtons(
              label: "Week",
              function: () {},
            ),
            timeButtons(
              label: "Month",
              function: () {},
            ),
            timeButtons(
              label: "All Time",
              function: () {},
            )
          ],
        ),
        Padding(
          padding: const EdgeInsets.all(15.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              tripContainer(title: "Trip", value: "22"),
              tripContainer(title: "Online", value: "11 hrs"),
              tripContainer(title: "Earned", value: "K 5000"),
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
          value: "K3000",
          color: Color(0xFF00A86B),
        ),
        walletCardsTop(
          imagePath: "assets/images/wallte.png",
          key: "Wallet",
          value: "K300",
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
                      "Jane Doe James",
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey[600],
                      ),
                    ),
                    userDetail(key: "Department", value: "WPHO Driver"),
                    userDetail(key: "Joined", value: "Sep 2018"),
                    userDetail(
                        key: "Experience and Skills", value: "4 Years, World"),
                  ],
                ),
              ),
              Expanded(
                child: CachedNetworkImage(
                  imageUrl:
                      "https://images.unsplash.com/photo-1553272725-086100aecf5e?ixlib=rb-1.2.1&ixid=MnwxMjA3fDF8MHxlZGl0b3JpYWwtZmVlZHw2fHx8ZW58MHx8fHw%3D&auto=format&fit=crop&w=500&q=60",
                  fit: BoxFit.cover,
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text("Recent Trips", style: kTextStyleHeader2),
        SizedBox(height: 8),
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: 22,
          itemBuilder: (context, i) {
            return tripData(
              time: "7:15",
              location: "Town Center - Bauleni",
              amount: "250",
            );
          },
        ),
      ],
    );
  }

  Widget walletSection() {
    Widget walletItems({
      required String key,
      required value,
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
                key: "Acceptance Rate", value: "92%", valueColor: Colors.green),
          ],
        ),
        SizedBox(height: 15),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            walletItems(
              key: "Trips Cancelled",
              keyColor: Colors.red,
              value: "5",
            ),
            walletItems(
              key: "Total Trips",
              value: "243",
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
            Container(
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
                    color: kAccent,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      "B2C",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10),
            Container(
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
                    color: Colors.white,
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 12),
                    child: Text(
                      "B2B",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
                    ),
                  ),
                ),
              ),
            ),
            Expanded(
              child: Text(
                "8h 12m",
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
        ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: 22,
          itemBuilder: (context, i) {
            return tripData(
              time: "7:15",
              location: "Town Center - Bauleni",
              amount: "250",
            );
          },
        ),
      ],
    );
  }
  /*BOTTOM TABS*/

  // WIDGETS
  Padding offlineButton() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 35, vertical: 8),
      child: SizedBox(
        width: double.infinity,
        child: ElevatedButton(
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.all<Color>(
              Color(0xFFFF0C51),
            ),
          ),
          onPressed: () {
            //TODO: add button funationality
          },
          child: Padding(
            padding: const EdgeInsets.all(12.0),
            child: Text("Go Offline"),
          ),
        ),
      ),
    );
  }

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
  }) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.white),
      ),
      onPressed: () => function(),
      child: Text(
        label,
        style: TextStyle(
          color: Colors.black,
        ),
      ),
    );
  }
}
