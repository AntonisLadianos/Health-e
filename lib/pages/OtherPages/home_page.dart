// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:app/db/db_helper.dart';
import 'package:app/pages/OtherPages/body.dart';
import 'package:app/pages/OtherPages/chronis_page.dart';
import 'package:app/pages/OtherPages/pain_recod.dart';
import 'package:app/pages/OtherPages/profile_page.dart';
import 'package:app/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'symptom_record_page.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Future<SharedPreferences> _pref = SharedPreferences.getInstance();
  late List<WeeklyData> weeklySymptomsData = [];
  late List<WeeklyData> weeklyPainData = [];
  Future<SharedPreferences> pref = SharedPreferences.getInstance();
  final TextEditingController emailController = TextEditingController();
  String firstName = "";
  String profile = "assets/user.png";
  late Widget avatar = Container();

  Future<void> getUserData() async {
    final SharedPreferences sp = await _pref;

    setState(() {
      firstName = sp.getString('first_name')!;
      profile = sp.getString('profile_photo')!;
    });
  }

  @override
  void initState() {
    getUserData().then((_) {
      avatar = CircleAvatar(
        radius: 30,
        backgroundColor: Colors.grey[200],
        backgroundImage: profile == "assets/user.png"
            ? AssetImage(profile)
            : FileImage(File(profile)) as ImageProvider<Object>?,
      );
    });

    fetchWeeklySymptomsData().then((data) {
      setState(() {
        weeklySymptomsData = data;
      });
    });
    fetchWeeklyPainData().then((data) {
      setState(() {
        weeklyPainData = data;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        body: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Stack(
                  alignment: AlignmentDirectional.bottomCenter,
                  children: <Widget>[
                    //custom clip path
                    ClipPath(
                      clipper: OvalBottomBorderClipper(),
                      child: Container(
                        height: 200,
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.bottomCenter,
                            end: Alignment.topCenter,
                            colors: [
                              Constants.secondarycolor,
                              Constants.primarycolor
                            ],
                          ),
                        ),
                      ),
                    ),

                    //hello and avatar
                    Padding(
                      padding: const EdgeInsets.all(50),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          // Hello and Name
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'Hello,',
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 18,
                                ),
                              ),
                              Text(
                                firstName,
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 24,
                                ),
                              ),
                            ],
                          ),

                          //Profile Picture
                          InkWell(
                            onTap: () {
                              Navigator.of(context).push(MaterialPageRoute(
                                  builder: (context) => ProfilePage()));
                            },
                            child: avatar,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10),
                //Card get starded
                getStarted(context),
                SizedBox(height: 10),
                //cards
                Padding(
                  padding: EdgeInsets.only(left: 15, right: 15),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      //Sympotm Card
                      symptomCard(context),
                      //Pain Card
                      painCard(context),
                    ],
                  ),
                ),
                SizedBox(height: 10),

                //Pain Questionnaire
                painQuestions(context),
                //chart
                // Padding(
                //   padding: const EdgeInsets.only(top: 10, right: 15, left: 15),
                //   child: Container(
                //     decoration: BoxDecoration(
                //       gradient: LinearGradient(
                //         begin: Alignment.bottomCenter,
                //         end: Alignment.topCenter,
                //         colors: [
                //           Constants.backgroundColor,
                //           Constants.primarycolor
                //         ],
                //       ),
                //       borderRadius: BorderRadius.circular(14),
                //     ),
                //     child: SizedBox(
                //       height: 200,
                //       child: SfCartesianChart(
                //         onChartTouchInteractionDown:
                //             (ChartTouchInteractionArgs args) {
                //           Navigator.of(context).push(
                //             MaterialPageRoute(
                //               builder: (context) => ChartsScreen(),
                //             ),
                //           );
                //         },
                //         title: ChartTitle(),
                //         plotAreaBackgroundColor: Colors.white,
                //         legend: Legend(
                //             isVisible: true, position: LegendPosition.bottom),
                //         primaryXAxis: CategoryAxis(
                //           labelStyle: TextStyle(color: Colors.black),
                //         ),
                //         primaryYAxis: NumericAxis(
                //           isVisible: false,
                //           labelStyle: TextStyle(color: Colors.black),
                //         ),
                //         series: <ChartSeries>[
                //           ColumnSeries<WeeklyData, String>(
                //             name: "Symptoms Per Day",
                //             dataSource: weeklySymptomsData,
                //             xValueMapper: (WeeklyData data, _) =>
                //                 DateFormat('EEE').format(data.weekStart),
                //             yValueMapper: (WeeklyData data, _) => data.count,
                //             dataLabelSettings: DataLabelSettings(
                //               textStyle: TextStyle(color: Colors.black),
                //               isVisible: true,
                //               labelAlignment: ChartDataLabelAlignment.outer,
                //             ),
                //             animationDuration: 1000,
                //             animationDelay: 0,
                //             borderRadius: BorderRadius.circular(20),
                //             width: 0.8,
                //             color: Colors.teal.shade400,
                //           ),
                //           ColumnSeries<WeeklyData, String>(
                //             name: "Average Pain Level",
                //             dataSource: weeklyPainData,
                //             xValueMapper: (WeeklyData data, _) =>
                //                 DateFormat('EEE').format(data.weekStart),
                //             yValueMapper: (WeeklyData data, _) => data.count,
                //             dataLabelSettings: DataLabelSettings(
                //               textStyle: TextStyle(color: Colors.black),
                //               isVisible: true,
                //               labelAlignment: ChartDataLabelAlignment.outer,
                //             ),
                //             animationDuration: 1000,
                //             animationDelay: 0,
                //             borderRadius: BorderRadius.circular(20),
                //             width: 0.8,
                //             color: Colors.red.shade400,
                //           ),
                //         ],
                //       ),
                //     ),
                //   ),
                // ),
              ],
            ),
          ],
        ),
      ),
      onWillPop: () async {
        return false;
      },
    );
  }

  Padding painQuestions(BuildContext context) {
    return Padding(
      padding: EdgeInsets.all(15.0),
      child: InkWell(
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => BodyScreen()));
        },
        child: Container(
          height: 150,
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(14),
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Constants.primarycolor, Constants.bluemunsell],
            ),
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              Text(
                "Pain Impact Questionnaire",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 10),
              Image.asset(
                'assets/questionnaire.png',
                height: 100,
                width: 100,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Expanded painCard(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => PainScreen()));
        },
        child: Container(
          height: 150,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Constants.primarycolor, Constants.bluemunsell],
            ),
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(14),
              topRight: Radius.circular(14),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/pain.png",
                height: 100,
                width: 100,
              ),
              SizedBox(height: 10),
              Text(
                "Add pain",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Expanded symptomCard(BuildContext context) {
    return Expanded(
      child: InkWell(
        onTap: () {
          Navigator.of(context)
              .push(MaterialPageRoute(builder: (context) => SymptomScreen()));
        },
        child: Container(
          height: 150,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [
                Constants.primarycolor,
                Constants.bluemunsell,
              ],
            ),
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(14),
              bottomLeft: Radius.circular(14),
            ),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                "assets/cough.png",
                height: 100,
                width: 100,
              ),
              SizedBox(height: 10),
              Text(
                "Add symptoms",
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Padding getStarted(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Container(
        height: 150,
        padding: EdgeInsets.all(15),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          gradient: LinearGradient(
            begin: Alignment.bottomCenter,
            end: Alignment.topCenter,
            colors: [Constants.primarycolor, Constants.bluemunsell],
          ),
        ),
        child: Row(
          children: [
            Image.asset(
              'assets/patient.png',
              height: 100,
              width: 100,
            ),
            SizedBox(width: 40),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "Ηow to begin?",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Text(
                    "Add Your Chronic Disease",
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: 10),
                  Padding(
                    padding: const EdgeInsets.only(right: 30),
                    child: ElevatedButton(
                      onPressed: () async {
                        await Navigator.of(context).push(MaterialPageRoute(
                            builder: (context) => Chronics()));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Constants.secondarycolor,
                        minimumSize: Size.fromHeight(40),
                      ),
                      child: Text(
                        'Get Started',
                        style: TextStyle(
                          fontSize: 12,
                          color: Constants.primarycolor,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          ],
        ),
      ),
    );
  }

  //fech sympotms data
  Future<List<WeeklyData>> fetchWeeklySymptomsData() async {
    final dbHelper = DbHelper.instance;
    final SharedPreferences sp = await pref;
    emailController.text = sp.getString('email')!;
    final userIds = emailController.text;

    final currentDate = DateTime.now();
    final startOfWeek =
        currentDate.subtract(Duration(days: currentDate.weekday - 1));
    final endOfWeek = startOfWeek.add(Duration(days: 6));

    final List<Map<String, dynamic>> result =
        await dbHelper.getAllSymptomss(userIds);

    final weeklyData = List<WeeklyData>.generate(7, (index) {
      final currentDate = endOfWeek.subtract(Duration(days: 6 - index));
      final count = result.where((item) {
        final itemDate = DateTime.parse(item['from_date']);
        return itemDate.year == currentDate.year &&
            itemDate.month == currentDate.month &&
            itemDate.day == currentDate.day;
      }).length;
      return WeeklyData(currentDate, count);
    });

    return weeklyData;
  }

//fetch pain data
  Future<List<WeeklyData>> fetchWeeklyPainData() async {
    final dbHelper = DbHelper.instance;
    final SharedPreferences sp = await pref;
    emailController.text = sp.getString('email')!;
    final userIds = emailController.text;

    final currentDate = DateTime.now();
    final startOfWeek =
        currentDate.subtract(Duration(days: currentDate.weekday - 1));
    final endOfWeek = startOfWeek.add(Duration(days: 6));

    final List<Map<String, dynamic>> result =
        await dbHelper.getAllPainss(userIds);

    final weeklyData = List<WeeklyData>.generate(7, (index) {
      final currentDate = endOfWeek.subtract(Duration(days: 6 - index));
      final count = result.where((item) {
        final itemDate = DateTime.parse(item['from_date']);
        return itemDate.year == currentDate.year &&
            itemDate.month == currentDate.month &&
            itemDate.day == currentDate.day;
      }).length;
      return WeeklyData(currentDate, count);
    });

    return weeklyData;
  }
}

class WeeklyData {
  final DateTime weekStart;
  final int count;

  WeeklyData(this.weekStart, this.count);
}
