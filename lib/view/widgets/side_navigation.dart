import 'package:bookie_driver/view/screens/activity/driver/DriverWallet.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';

import '../../provider/shared_prefrence_provider.dart';
import '../constants/constants.dart';
import '../screens/activity/driver/DriverHomeInit.dart';
import '../screens/activity/driver/driver_dashboard.dart';
import '../screens/activity/driver/profileScreen.dart';
import '../screens/activity/paymentSelection/payment_selection_activity.dart';
import '../screens/activity/setup/login_activity.dart';
import 'logger_widget.dart';

Drawer buildDrawer({
  required BuildContext context,
  required bool isDriver,
  required profilePhoto,
  required userName,
}) {
  return Drawer(
    child: Container(
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
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          SizedBox(height: 30),
          Container(
            child: Padding(
              padding: const EdgeInsets.all(15.0),
              child: Row(
                children: [
                  InkWell(
                    onTap: () {
                      Navigator.pushNamed(context, ProfileScreen.id);
                    },
                    child: ClipRRect(
                      borderRadius: BorderRadius.all(Radius.elliptical(30, 30)),
                      child: CachedNetworkImage(
                        height: 55.0,
                        width: 55.0,
                        imageUrl: profilePhoto,
                        fit: BoxFit.cover,
                        errorWidget: (context, url, error) => Icon(
                          FontAwesome.user_circle,
                          size: 50,
                        ),
                      ),
                    ),
                  ),
                  SizedBox(width: 10),
                  Container(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Hi, $userName",
                          style: kTextStyleHeader1.copyWith(fontSize: 17),
                        ),
                        Text(
                          "#Let's get you there",
                          style: TextStyle(
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
          menuButton(
            title: "Dashboard",
            icon: FontAwesome.dashboard,
            function: () async {
              await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DriverDashboard(
                    profilePhoto: profilePhoto,
                  ),
                ),
              );
            },
          ),
          menuButton(
            title: "Home",
            icon: Icons.home,
            function: () {
              Navigator.pushNamed(context, DriverHomeInit.id);
            },
          ),
          menuButton(
            title: "Profile",
            icon: FontAwesome.user,
            function: () async {
              await Navigator.pushNamed(context, ProfileScreen.id);
            },
          ),
          menuButton(
            title: "Wallet",
            icon: Icons.account_balance_wallet,
            function: () async {
              await Navigator.pushNamed(context, DriverWallet.id);
            },
          ),
          menuButton(
            title: "Settings",
            icon: FontAwesome.cog,
            function: () {},
          ),
          menuButton(
            title: "Help and Support",
            icon: Icons.supervised_user_circle_outlined,
            function: () {},
          ),
          menuButton(
            title: "About",
            icon: FontAwesome.info,
            function: () {},
          ),
          menuButton(
              title: "Logout",
              icon: FontAwesome.sign_out,
              function: () async {
                SharedPreferenceProvider provider = SharedPreferenceProvider();
                await provider.logOut();
                Navigator.popAndPushNamed(context, LoginActivity.id);
              }),
          SizedBox(
            height: 100,
            child: Container(),
          ),
          Center(
            child: Column(
              children: [
                Text("Version : 1.0.0", style: TextStyle(fontSize: 13)),
              ],
            ),
          )
        ],
      ),
    ),
  );
}

ListTile menuButton({
  required String title,
  required IconData icon,
  required Function function,
}) {
  return ListTile(
    onTap: () {
      function();
    },
    leading: Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.all(
          Radius.circular(800),
        ),
        color: Colors.white,
      ),
      child: Padding(
        padding: EdgeInsets.all(8.0),
        child: Icon(
          icon,
          size: 15,
          color: Colors.black,
        ),
      ),
    ),
    title: Text(title),
    // onTap: () {},
  );
}
