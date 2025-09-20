import 'package:app/stats/presentation/pages/calendar.dart';
import 'package:app/stats/presentation/pages/charts.dart';

import 'package:app/home/presentation/pages/home_page.dart';
import 'package:app/home/presentation/pages/profile_page.dart';
import 'package:app/core/utils/const.dart';

import 'package:flutter/material.dart';
import 'package:google_nav_bar/google_nav_bar.dart';
import 'package:line_icons/line_icons.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({
    super.key,
  });

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int navigatorKey = 0;

  void changePage(int index) {
    setState(() {
      navigatorKey = index;
    });
  }

  final pages = [
    HomePage(),
    CalendarScreen(),
    ChartsScreen(),
    ProfilePage(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: pages[navigatorKey],
      bottomNavigationBar: Container(
        decoration: BoxDecoration(
          color: Constants.primarycolor,
          boxShadow: [
            BoxShadow(
              blurRadius: 20,
              color: Colors.black.withOpacity(.1),
            )
          ],
        ),
        child: SafeArea(
          child: Padding(
            padding: EdgeInsets.symmetric(
                horizontal: MediaQuery.of(context).size.width * 0.05,
                vertical: 6),
            child: GNav(
              rippleColor: Constants.bluemunsell,
              hoverColor: Constants.bluemunsell,
              activeColor: Constants.primarycolor,
              iconSize: 20,
              gap: 5,
              padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              duration: Duration(milliseconds: 200),
              tabBackgroundColor: Constants.secondarycolor,
              color: Colors.white,
              tabs: [
                GButton(
                  icon: LineIcons.home,
                  text: 'Home',
                ),
                GButton(
                  icon: LineIcons.calendar,
                  text: 'Calendar',
                ),
                GButton(
                  icon: LineIcons.barChartAlt,
                  text: 'Statistics',
                ),
                GButton(
                  icon: LineIcons.user,
                  text: 'Profile',
                ),
              ],
              onTabChange: changePage,
            ),
          ),
        ),
      ),
    );
  }
}
