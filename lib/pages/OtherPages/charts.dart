// ignore_for_file: deprecated_member_use

import 'dart:async';

import 'package:app/db/db_helper.dart';
import 'package:app/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:supercharged/supercharged.dart';
import 'package:syncfusion_flutter_charts/charts.dart';

class ChartsScreen extends StatefulWidget {
  const ChartsScreen({super.key});

  @override
  State<ChartsScreen> createState() => _ChartsScreenState();
}

class _ChartsScreenState extends State<ChartsScreen> {
  late List<WeeklySymptomsData> weeklySymptomsData = [];
  late List<MonthlySymptomsData> monthlySymptomsData = [];
  late List<YearlySymptomsData> yearlySymptomsData = [];

  late List<WeeklyPainData> weeklyPainData = [];
  late List<MonthlyPainAverageData> monthlyPainAverageData = [];
  late List<YearlyPainData> yearlyPaindata = [];

  Future<SharedPreferences> pref = SharedPreferences.getInstance();
  final TextEditingController emailController = TextEditingController();

  var now = DateTime.now();
  DateTime currentDate = DateTime.now();
  int currentYear = DateTime.now().year;

  bool wpain = true;
  bool mpain = false;
  bool ypain = false;

  bool wsymtoms = true;
  bool msymptoms = false;
  bool ysymptoms = false;

  late int day;
  late int month;

  dynamic timer;

  @override
  void initState() {
    super.initState();
    if (mounted) {
      day = 6;
      month = 0;
      fetchWeeklySymptomsData(day).then((data) {
        setState(() {
          weeklySymptomsData = data;
        });
      });
      fetchMonthlySymptomsData(month).then((data) {
        setState(() {
          monthlySymptomsData = data;
        });
      });
      fetchYearlySymptomsData(currentYear).then((data) {
        setState(() {
          yearlySymptomsData = data;
        });
      });
      fetchWeeklyPainData(day).then((data) {
        setState(() {
          weeklyPainData = data;
        });
      });
      fetchMonthlyPainData(month).then((data) {
        setState(() {
          monthlyPainAverageData = data;
        });
      });
      fetchYearlyPainData(currentYear).then((data) {
        setState(() {
          yearlyPaindata = data;
        });
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.primarycolor,
        centerTitle: true,
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.bottomCenter,
              end: Alignment.topCenter,
              colors: [Constants.secondarycolor, Constants.primarycolor],
            ),
          ),
        ),
        title: Text(
          "Statistics",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
      ),
      backgroundColor: Constants.backgroundColor,
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(height: 5),
            changeChartsButtons(),
            SizedBox(height: 5),
            symptomsNavigation(),
            if (wsymtoms) ...{
              weeklySymptomsChart()
            } else if (msymptoms) ...{
              monthlySymptomsChart()
            } else ...{
              yearlySymptomsChart()
            },
            Divider(),
            if (wpain) ...{
              weeklyPainChart()
            } else if (mpain) ...{
              monthlyPainChart()
            } else ...{
              yearlyPainChart()
            },
          ],
        ),
      ),
    );
  }

  Row symptomsNavigation() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: [
        if (wpain && wsymtoms) ...{
          ElevatedButton.icon(
            label: Text(
              "Previous Week",
              style: TextStyle(color: Constants.primarycolor),
            ),
            icon: Icon(
              LineIcons.caretLeft,
              color: Constants.primarycolor,
            ),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 8),
              elevation: 0,
              backgroundColor: Colors.grey.shade300,
            ),
            onPressed: () {
              setState(() {
                day -= 7;
                fetchWeeklySymptomsData(day).then((data) {
                  setState(() {
                    weeklySymptomsData = data;
                  });
                  fetchWeeklyPainData(day).then((data) {
                    setState(() {
                      weeklyPainData = data;
                    });
                  });
                });
              });
            },
          ),
          ElevatedButton.icon(
            label: Icon(
              LineIcons.caretRight,
              color: Constants.primarycolor,
            ),
            icon: Text(
              "Next Week",
              style: TextStyle(color: Constants.primarycolor),
            ),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 8),
              elevation: 0,
              backgroundColor: Colors.grey.shade300,
            ),
            onPressed: () {
              setState(() {
                day += 7;
                fetchWeeklySymptomsData(day).then((data) {
                  setState(() {
                    weeklySymptomsData = data;
                  });
                });
                fetchWeeklyPainData(day).then((data) {
                  setState(() {
                    weeklyPainData = data;
                  });
                });
              });
            },
          ),
        } else if (mpain && msymptoms) ...{
          ElevatedButton.icon(
            label: Text(
              "Previous Month",
              style: TextStyle(color: Constants.primarycolor),
            ),
            icon: Icon(
              LineIcons.caretLeft,
              color: Constants.primarycolor,
            ),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 8),
              elevation: 0,
              backgroundColor: Colors.grey.shade300,
            ),
            onPressed: () {
              setState(() {
                month -= 1;
                fetchMonthlySymptomsData(month).then((data) {
                  setState(() {
                    monthlySymptomsData = data;
                  });
                });
                fetchMonthlyPainData(month).then((data) {
                  setState(() {
                    monthlyPainAverageData = data;
                  });
                });
              });
            },
          ),
          ElevatedButton.icon(
            label: Icon(
              LineIcons.caretRight,
              color: Constants.primarycolor,
            ),
            icon: Text(
              "Next Month",
              style: TextStyle(color: Constants.primarycolor),
            ),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 8),
              elevation: 0,
              backgroundColor: Colors.grey.shade300,
            ),
            onPressed: () {
              setState(() {
                month += 1;
                fetchMonthlySymptomsData(month).then((data) {
                  setState(() {
                    monthlySymptomsData = data;
                  });
                });
                fetchMonthlyPainData(month).then((data) {
                  setState(() {
                    monthlyPainAverageData = data;
                  });
                });
              });
            },
          ),
        } else ...{
          ElevatedButton.icon(
            label: Text(
              "Previous Year",
              style: TextStyle(color: Constants.primarycolor),
            ),
            icon: Icon(
              LineIcons.caretLeft,
              color: Constants.primarycolor,
            ),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 8),
              elevation: 0,
              backgroundColor: Colors.grey.shade300,
            ),
            onPressed: () {
              setState(() {
                currentYear--;
                fetchYearlySymptomsData(currentYear).then((data) {
                  setState(() {
                    yearlySymptomsData = data;
                  });
                });
                fetchYearlyPainData(currentYear).then((data) {
                  setState(() {
                    yearlyPaindata = data;
                  });
                });
              });
            },
          ),
          ElevatedButton.icon(
            label: Icon(
              LineIcons.caretRight,
              color: Constants.primarycolor,
            ),
            icon: Text(
              "Next Year",
              style: TextStyle(color: Constants.primarycolor),
            ),
            style: ElevatedButton.styleFrom(
              padding: EdgeInsets.symmetric(horizontal: 8),
              elevation: 0,
              backgroundColor: Colors.grey.shade300,
            ),
            onPressed: () {
              setState(() {
                currentYear++;
                fetchYearlySymptomsData(currentYear).then((data) {
                  setState(() {
                    yearlySymptomsData = data;
                  });
                });
                fetchYearlyPainData(currentYear).then((data) {
                  setState(() {
                    yearlyPaindata = data;
                  });
                });
              });
            },
          ),
        }
      ],
    );
  }

  Container yearlyPainChart() {
    return Container(
      height: 350,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: FutureBuilder<List<YearlyPainData>>(
        future: fetchYearlyPainData(currentYear),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SfCartesianChart(
              legend: Legend(isVisible: true, position: LegendPosition.bottom),
              primaryXAxis: CategoryAxis(
                title: AxisTitle(
                    text: DateFormat('yyyy').format(DateTime(currentYear))),
                labelStyle: TextStyle(color: Colors.black),
                isVisible: true,
              ),
              primaryYAxis: NumericAxis(
                interval: 1,
                majorTickLines: MajorTickLines(size: 0),
                isVisible: true,
                labelStyle: TextStyle(color: Colors.black),
              ),
              series: [
                ColumnSeries<YearlyPainData, String>(
                  name: "Avg Pain",
                  legendItemText: "Average Pain Intensity",
                  dataSource: yearlyPaindata,
                  xValueMapper: (YearlyPainData data, _) => data.month,
                  yValueMapper: (YearlyPainData data, _) =>
                      data.averagePainIntensity.toDouble() == 0
                          ? null
                          : data.averagePainIntensity.toDouble(),
                  color: Constants.intensitychart,
                  borderRadius: BorderRadius.circular(20),
                  dataLabelSettings: DataLabelSettings(
                    isVisible: false,
                    labelAlignment: ChartDataLabelAlignment.outer,
                  ),
                ),
              ],
              title: ChartTitle(
                text: 'Average Pain Level',
                textStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
              trackballBehavior: TrackballBehavior(
                lineWidth: 0,
                enable: true,
                activationMode: ActivationMode.singleTap,
                tooltipSettings: InteractiveTooltip(
                  textStyle: TextStyle(fontSize: 14),
                  color: Constants.primarycolor,
                  canShowMarker: true,
                  borderRadius: 10,
                  enable: true,
                ),
                tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Container monthlyPainChart() {
    return Container(
      height: 350,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: SfCartesianChart(
        legend: Legend(isVisible: true, position: LegendPosition.bottom),
        primaryXAxis: CategoryAxis(
          labelStyle: TextStyle(color: Colors.black),
          title: AxisTitle(
              text: DateFormat('MMMM').format(
                  DateTime(currentDate.year, currentDate.month + month))),
          isVisible: true,
        ),
        primaryYAxis: NumericAxis(
          minimum: 0,
          maximum: 5,
          interval: 1,
          majorTickLines: MajorTickLines(size: 0),
          isVisible: true,
          labelStyle: TextStyle(color: Colors.black),
        ),
        series: [
          ColumnSeries<MonthlyPainAverageData, String>(
            name: "Avg Pain",
            legendItemText: "Average Pain Intensity",
            width: 0.3,
            dataSource: monthlyPainAverageData,
            xValueMapper: (MonthlyPainAverageData data, _) =>
                DateFormat('dd').format(data.day),
            yValueMapper: (MonthlyPainAverageData data, _) =>
                data.averagePainIntensity.toDouble() == 0
                    ? null
                    : data.averagePainIntensity.toDouble(),
            color: Constants.intensitychart,
            borderRadius: BorderRadius.circular(20),
            dataLabelSettings: DataLabelSettings(
              isVisible: false,
              labelAlignment: ChartDataLabelAlignment.middle,
            ),
          ),
        ],
        title: ChartTitle(
          text: 'Average Pain Level',
          textStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
          ),
        ),
        trackballBehavior: TrackballBehavior(
          lineWidth: 0,
          enable: true,
          activationMode: ActivationMode.singleTap,
          tooltipSettings: InteractiveTooltip(
            textStyle: TextStyle(fontSize: 14),
            color: Constants.primarycolor,
            canShowMarker: true,
            borderRadius: 10,
            enable: true,
          ),
          tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
        ),
      ),
    );
  }

  Container weeklyPainChart() {
    return Container(
      height: 350,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: SfCartesianChart(
        legend: Legend(isVisible: true, position: LegendPosition.bottom),
        primaryXAxis: CategoryAxis(
          labelStyle: TextStyle(color: Colors.black),
          title: AxisTitle(text: "Weekly"),
          isVisible: true,
        ),
        primaryYAxis: NumericAxis(
          minimum: 1,
          maximum: 5,
          interval: 1,
          majorTickLines: MajorTickLines(size: 0),
          isVisible: true,
          labelStyle: TextStyle(color: Colors.black),
        ),
        series: [
          ColumnSeries<WeeklyPainData, String>(
            name: "Avg Pain",
            legendItemText: "Average Pain Intensity",
            width: 0.5,
            dataSource: weeklyPainData,
            xValueMapper: (WeeklyPainData data, _) =>
                DateFormat('EEE dd\nMMM').format(data.weekStart),
            yValueMapper: (WeeklyPainData data, _) =>
                data.averagePainIntensity.toDouble() == 0
                    ? null
                    : data.averagePainIntensity.toDouble(),
            color: Constants.intensitychart,
            dataLabelSettings: DataLabelSettings(
              isVisible: false,
              labelAlignment: ChartDataLabelAlignment.outer,
            ),
            borderRadius: BorderRadius.circular(20),
          ),
        ],
        title: ChartTitle(
          text: 'Average Pain Level',
          textStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
          ),
        ),
        trackballBehavior: TrackballBehavior(
          lineWidth: 0,
          enable: true,
          activationMode: ActivationMode.singleTap,
          tooltipSettings: InteractiveTooltip(
            textStyle: TextStyle(fontSize: 14),
            color: Constants.primarycolor,
            canShowMarker: true,
            borderRadius: 10,
            enable: true,
          ),
          tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
        ),
      ),
    );
  }

  Container weeklySymptomsChart() {
    return Container(
      height: 350,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
            bottomLeft: Radius.circular(10),
            bottomRight: Radius.circular(10)),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: SfCartesianChart(
        primaryXAxis: CategoryAxis(
          labelStyle: TextStyle(color: Colors.black),
          title: AxisTitle(text: 'Weekly'),
          isVisible: true,
          interval: 1,
          // visibleMaximum: 6,
        ),
        primaryYAxis: NumericAxis(
          interval: 1,
          majorTickLines: MajorTickLines(size: 0),
          isVisible: true,
          labelStyle: TextStyle(color: Colors.black),
        ),
        title: ChartTitle(
          text: 'Weekly Symptoms',
          textStyle: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            decoration: TextDecoration.underline,
          ),
        ),
        legend: Legend(isVisible: true, position: LegendPosition.bottom),
        series: [
          ColumnSeries<WeeklySymptomsData, String>(
            name: "Symptoms",
            legendItemText: "Symptoms",
            dataSource: weeklySymptomsData,
            xValueMapper: (WeeklySymptomsData data, _) =>
                DateFormat('EEE dd\nMMM').format(data.monthStart),
            yValueMapper: (WeeklySymptomsData data, _) => data.count.toDouble(),
            spacing: 0.3,
            width: 0.8,
            color: Constants.symptomschart,
            borderRadius: BorderRadius.circular(15),
          ),
        ],
        trackballBehavior: TrackballBehavior(
          lineWidth: 0,
          enable: true,
          activationMode: ActivationMode.singleTap,
          tooltipSettings: InteractiveTooltip(
            textStyle: TextStyle(fontSize: 14),
            color: Constants.primarycolor,
            canShowMarker: true,
            borderRadius: 10,
            enable: true,
          ),
          tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
        ),
      ),
    );
  }

  Container monthlySymptomsChart() {
    return Container(
      height: 350,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: FutureBuilder<List<MonthlySymptomsData>>(
        future: fetchMonthlySymptomsData(month),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SfCartesianChart(
              primaryXAxis: CategoryAxis(
                labelStyle: TextStyle(color: Colors.black),
                title: AxisTitle(
                    text: DateFormat('MMMM').format(
                        DateTime(currentDate.year, currentDate.month + month))),
                isVisible: true,
              ),
              primaryYAxis: NumericAxis(
                interval: 1,
                majorTickLines: MajorTickLines(size: 0),
                isVisible: true,
                labelStyle: TextStyle(color: Colors.black),
              ),
              legend: Legend(isVisible: true, position: LegendPosition.bottom),
              series: [
                ColumnSeries<MonthlySymptomsData, String>(
                  name: "Symptoms",
                  enableTooltip: true,
                  legendItemText: "Symptoms",
                  dataSource: monthlySymptomsData,
                  xValueMapper: (MonthlySymptomsData data, _) =>
                      DateFormat('dd').format(data.weekStart),
                  yValueMapper: (MonthlySymptomsData data, _) =>
                      data.count.toDouble(),
                  color: Constants.symptomschart,
                  borderRadius: BorderRadius.circular(15),
                ),
                ColumnSeries<MonthlySymptomsData, String>(
                  name: "Avg Intensity",
                  enableTooltip: true,
                  legendItemText: "Average Intensity",
                  dataSource: monthlySymptomsData,
                  xValueMapper: (MonthlySymptomsData data, _) =>
                      DateFormat('dd').format(data.weekStart),
                  yValueMapper: (MonthlySymptomsData data, _) =>
                      double.parse(data.averageIntensity),
                  color: Constants.intensitychart,
                  borderRadius: BorderRadius.circular(15),
                ),
              ],
              title: ChartTitle(
                text: 'Monthly Symptoms',
                textStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
              trackballBehavior: TrackballBehavior(
                lineWidth: 0,
                enable: true,
                activationMode: ActivationMode.singleTap,
                tooltipSettings: InteractiveTooltip(
                  textStyle: TextStyle(fontSize: 14),
                  color: Constants.primarycolor,
                  canShowMarker: true,
                  borderRadius: 10,
                  enable: true,
                ),
                tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Container yearlySymptomsChart() {
    return Container(
      height: 350,
      margin: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.5),
            spreadRadius: 1,
            blurRadius: 5,
          ),
        ],
      ),
      child: FutureBuilder<List<YearlySymptomsData>>(
        future: fetchYearlySymptomsData(currentYear),
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return SfCartesianChart(
              legend: Legend(isVisible: true, position: LegendPosition.bottom),
              primaryXAxis: CategoryAxis(
                labelStyle: TextStyle(color: Colors.black),
                title: AxisTitle(
                    text: DateFormat('yyyy').format(DateTime(currentYear))),
                isVisible: true,
              ),
              primaryYAxis: NumericAxis(
                interval: 1,
                majorTickLines: MajorTickLines(size: 0),
                isVisible: true,
                labelStyle: TextStyle(color: Colors.black),
              ),
              series: [
                ColumnSeries<YearlySymptomsData, String>(
                  name: "Symptoms",
                  legendItemText: "Symptoms",
                  dataSource: yearlySymptomsData,
                  xValueMapper: (YearlySymptomsData data, _) => data.monthLabel,
                  yValueMapper: (YearlySymptomsData data, _) =>
                      data.count.toDouble(),
                  color: Constants.symptomschart,
                  borderRadius: BorderRadius.circular(15),
                ),
                ColumnSeries<YearlySymptomsData, String>(
                  name: "Avg Intensity",
                  legendItemText: "Average Intensity",
                  dataSource: yearlySymptomsData,
                  xValueMapper: (YearlySymptomsData data, _) => data.monthLabel,
                  yValueMapper: (YearlySymptomsData data, _) =>
                      double.parse(data.averageIntensity),
                  borderRadius: BorderRadius.circular(15),
                  color: Constants.intensitychart,
                ),
              ],
              title: ChartTitle(
                text: 'Yearly Symptoms',
                textStyle: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline,
                ),
              ),
              trackballBehavior: TrackballBehavior(
                lineWidth: 0,
                enable: true,
                activationMode: ActivationMode.singleTap,
                tooltipSettings: InteractiveTooltip(
                  textStyle: TextStyle(fontSize: 14),
                  color: Constants.primarycolor,
                  canShowMarker: true,
                  borderRadius: 10,
                  enable: true,
                ),
                tooltipDisplayMode: TrackballDisplayMode.groupAllPoints,
              ),
            );
          } else if (snapshot.hasError) {
            return Text('Error: ${snapshot.error}');
          } else {
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  Row changeChartsButtons() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        TextButton(
          onPressed: () {
            setState(() {
              wpain = true;
              mpain = false;
              ypain = false;

              wsymtoms = true;
              msymptoms = false;
              ysymptoms = false;
            });
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
              if (states.contains(MaterialState.pressed)) {
                return Constants.primarycolor;
              } else if (wpain && wsymtoms) {
                return Constants.primarycolor;
              } else {
                return Colors.grey.shade300;
              }
            }),
            foregroundColor: MaterialStateProperty.resolveWith<Color>((states) {
              if (states.contains(MaterialState.pressed) || wpain && wsymtoms) {
                return Constants.secondarycolor;
              } else {
                return Constants.primarycolor;
              }
            }),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(20),
                    bottomLeft: Radius.circular(20)),
              ),
            ),
          ),
          child: Text(
            'Weekly',
            style: TextStyle(fontSize: 14),
          ),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              wpain = false;
              mpain = true;
              ypain = false;
              wsymtoms = false;
              msymptoms = true;
              ysymptoms = false;
            });
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
              if (states.contains(MaterialState.pressed)) {
                return Constants.primarycolor;
              } else if (mpain && msymptoms) {
                return Constants.primarycolor;
              } else {
                return Colors.grey.shade300;
              }
            }),
            foregroundColor: MaterialStateProperty.resolveWith<Color>((states) {
              if (states.contains(MaterialState.pressed) ||
                  mpain && msymptoms) {
                return Constants.secondarycolor;
              } else {
                return Constants.primarycolor;
              }
            }),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                  // borderRadius: BorderRadius.circular(20),
                  ),
            ),
          ),
          child: Text(
            'Monthly',
            style: TextStyle(fontSize: 14),
          ),
        ),
        TextButton(
          onPressed: () {
            setState(() {
              wpain = false;
              mpain = false;
              ypain = true;
              wsymtoms = false;
              msymptoms = false;
              ysymptoms = true;
            });
          },
          style: ButtonStyle(
            backgroundColor: MaterialStateProperty.resolveWith<Color>((states) {
              if (states.contains(MaterialState.pressed)) {
                return Constants.primarycolor;
              } else if (ypain && ysymptoms) {
                return Constants.primarycolor;
              } else {
                return Colors.grey.shade300;
              }
            }),
            foregroundColor: MaterialStateProperty.resolveWith<Color>((states) {
              if (states.contains(MaterialState.pressed) ||
                  ypain && ysymptoms) {
                return Constants.secondarycolor;
              } else {
                return Constants.primarycolor;
              }
            }),
            shape: MaterialStateProperty.all<RoundedRectangleBorder>(
              RoundedRectangleBorder(
                borderRadius: BorderRadius.only(
                    topRight: Radius.circular(20),
                    bottomRight: Radius.circular(20)),
              ),
            ),
          ),
          child: Text(
            'Yearly',
            style: TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }

//fech sympotms data
  Future<List<WeeklySymptomsData>> fetchWeeklySymptomsData(int day) async {
    final dbHelper = DbHelper.instance;
    final SharedPreferences sp = await pref;
    emailController.text = sp.getString('email')!;
    final userIds = emailController.text;

    final currentDate = DateTime.now();
    final startOfWeek =
        currentDate.subtract(Duration(days: currentDate.weekday - 1));
    final endOfWeek = startOfWeek.add(Duration(days: day));

    final List<Map<String, dynamic>> result =
        await dbHelper.getAllSymptomss(userIds);

    final weeklyData = List<WeeklySymptomsData>.generate(7, (index) {
      final currentDate = endOfWeek.subtract(Duration(days: 6 - index));
      final symptoms = result.where((item) {
        final itemDate = DateTime.parse(item['from_date']);
        return itemDate.year == currentDate.year &&
            itemDate.month == currentDate.month &&
            itemDate.day == currentDate.day;
      }).toList();
      final count = symptoms.length;
      // final averageIntensity = count > 0
      //     ? symptoms
      //             .map<num>((item) => item['intensity'])
      //             .reduce((a, b) => a + b) /
      //         count
      //     : 0;
      return WeeklySymptomsData(
        currentDate,
        count, /*averageIntensity.toStringAsFixed(2)*/
      );
    });

    return weeklyData;
  }

  Future<List<MonthlySymptomsData>> fetchMonthlySymptomsData(int month) async {
    final dbHelper = DbHelper.instance;
    final SharedPreferences sp = await pref;
    emailController.text = sp.getString('email')!;
    final userIds = emailController.text;

    final currentDate = DateTime.now();
    final endOfMonth = DateTime(currentDate.year, currentDate.month + 1, 0);

    final List<Map<String, dynamic>> result =
        await dbHelper.getAllSymptomss(userIds);

    final monthlyData = List<MonthlySymptomsData>.generate(
      endOfMonth.day,
      (index) {
        final currentNowDate =
            DateTime(currentDate.year, currentDate.month + month, index + 1);
        final symptoms = result.where((item) {
          final itemDate = DateTime.parse(item['from_date']);
          return itemDate.year == currentNowDate.year &&
              itemDate.month == currentNowDate.month &&
              itemDate.day == currentNowDate.day;
        }).toList();
        final count = symptoms.length;
        final averageIntensity = count > 0
            ? symptoms
                    .map<num>((item) => item['intensity'])
                    .reduce((a, b) => a + b) /
                count
            : 0;
        return MonthlySymptomsData(
            currentNowDate, count, averageIntensity.toStringAsFixed(2));
      },
    );

    return monthlyData;
  }

  Future<List<YearlySymptomsData>> fetchYearlySymptomsData(
      int currentYear) async {
    final dbHelper = DbHelper.instance;
    final SharedPreferences sp = await pref;
    emailController.text = sp.getString('email')!;
    final userIds = emailController.text;

    final List<Map<String, dynamic>> result =
        await dbHelper.getAllSymptomss(userIds);

    final yearlyData = List<YearlySymptomsData>.generate(12, (index) {
      final currentMonth = index + 1;

      final symptoms = result.where((item) {
        final itemDate = DateTime.parse(item['from_date']);
        return itemDate.year == currentYear && itemDate.month == currentMonth;
      }).toList();

      final count = symptoms.length;

      final averageIntensity = count > 0
          ? symptoms
                  .map<num>((item) => item['intensity'])
                  .reduce((a, b) => a + b) /
              count
          : 0;

      final monthLabel =
          DateFormat('MMM').format(DateTime(currentYear, currentMonth));

      return YearlySymptomsData(
          monthLabel, count, averageIntensity.toStringAsFixed(2));
    });

    return yearlyData;
  }

//fetch pain data
  Future<List<WeeklyPainData>> fetchWeeklyPainData(int day) async {
    final dbHelper = DbHelper.instance;
    final SharedPreferences sp = await pref;
    emailController.text = sp.getString('email')!;
    final userIds = emailController.text;

    final currentDate = DateTime.now();
    final startOfWeek =
        currentDate.subtract(Duration(days: currentDate.weekday - 1));
    final endOfWeek = startOfWeek.add(Duration(days: day));

    final List<Map<String, dynamic>> result =
        await dbHelper.getAllPainss(userIds);

    final weeklyData = List<WeeklyPainData>.generate(7, (index) {
      final currentDate = endOfWeek.subtract(Duration(days: 6 - index));
      final painValues = result
          .where((item) {
            final itemDate = DateTime.parse(item['from_date']);
            return itemDate.year == currentDate.year &&
                itemDate.month == currentDate.month &&
                itemDate.day == currentDate.day;
          })
          .map<num>((item) => item['pain_intensity'])
          .toList();
      final averagePain = painValues.isNotEmpty
          ? painValues.reduce((a, b) => a + b) / painValues.length
          : 0;
      return WeeklyPainData(currentDate, averagePain.toStringAsFixed(2));
    });

    return weeklyData;
  }

  Future<List<MonthlyPainAverageData>> fetchMonthlyPainData(int month) async {
    final dbHelper = DbHelper.instance;
    final SharedPreferences sp = await pref;
    emailController.text = sp.getString('email')!;
    final userIds = emailController.text;

    final currentDate = DateTime.now();
    final endOfMonth = DateTime(currentDate.year, currentDate.month + 1, 0);

    final List<Map<String, dynamic>> result =
        await dbHelper.getAllPainss(userIds);

    final dailyData =
        List<MonthlyPainAverageData>.generate(endOfMonth.day, (index) {
      final currentNowDate =
          DateTime(currentDate.year, currentDate.month + month, index + 1);
      final painValues = result
          .where((item) {
            final itemDate = DateTime.parse(item['from_date']);
            return itemDate.year == currentNowDate.year &&
                itemDate.month == currentNowDate.month &&
                itemDate.day == currentNowDate.day;
          })
          .map<num>((item) => item['pain_intensity'])
          .toList();
      final averagePain = painValues.isNotEmpty
          ? painValues.reduce((a, b) => a + b) / painValues.length
          : 0;
      return MonthlyPainAverageData(
          currentNowDate, averagePain.toStringAsFixed(2));
    });

    return dailyData;
  }

  Future<List<YearlyPainData>> fetchYearlyPainData(int currentYear) async {
    final dbHelper = DbHelper.instance;
    final SharedPreferences sp = await pref;
    emailController.text = sp.getString('email')!;
    final userIds = emailController.text;

    final List<Map<String, dynamic>> result =
        await dbHelper.getAllPainss(userIds);
    final nextYear = currentYear;

    final monthlyData = List<YearlyPainData>.generate(12, (index) {
      final currentMonth = index + 1;

      final painValues = result
          .where((item) {
            final itemDate = DateTime.parse(item['from_date']);
            return itemDate.year == nextYear && itemDate.month == currentMonth;
          })
          .map<num>((item) => item['pain_intensity'])
          .toList();

      final averagePain = painValues.isNotEmpty
          ? painValues.reduce((a, b) => a + b) / painValues.length
          : 0;
      final monthLabel =
          DateFormat('MMM').format(DateTime(nextYear, currentMonth, 1));
      return YearlyPainData(monthLabel, averagePain.toStringAsFixed(2));
    });

    return monthlyData;
  }
}

// Future<List<YearlyPainData>> fetchYearlyPainData(int year) async {
//   final dbHelper = DbHelper.instance;
//   final SharedPreferences sp = await pref;
//   emailController.text = sp.getString('email')!;
//   final userIds = emailController.text;

//   final List<Map<String, dynamic>> result =
//       await dbHelper.getAllPainss(userIds);

//   final monthlyData = List<YearlyPainData>.generate(
//     DateTime.monthsPerYear,
//     (index) {
//       final month = index + year;
//       final years = DateTime.now().year;
//       final painValues = result
//           .where((item) {
//             final itemDate = DateTime.parse(item['from_date']);
//             return itemDate.year == years && itemDate.month == month;
//           })
//           .map<num>((item) => item['pain_intensity'])
//           .toList();

//       final averagePain = painValues.isNotEmpty
//           ? painValues.reduce((a, b) => a + b) / painValues.length
//           : 0;

//       final monthLabel = DateFormat('MMM').format(DateTime(years, month));
//       return YearlyPainData(monthLabel, averagePain.toStringAsFixed(2));
//     },
//   );

//   return monthlyData;
// }

class WeeklySymptomsData {
  final DateTime monthStart;
  final int count;
  // final String averageIntensity;

  WeeklySymptomsData(this.monthStart, this.count);
}

List<Color> intensityColors = [
  Colors.green, // Intensity 0 color
  Colors.lightGreen, // Intensity 1 color
  Colors.yellow, // Intensity 2 color
  Colors.orange, // Intensity 3 color
  Colors.deepOrange, // Intensity 4 color
  Colors.red, // Intensity 5 color
];

class MonthlySymptomsData {
  final DateTime weekStart;
  final int count;
  final String averageIntensity;

  MonthlySymptomsData(this.weekStart, this.count, this.averageIntensity);
}

class YearlySymptomsData {
  final String monthLabel;
  final int count;
  final String averageIntensity;

  YearlySymptomsData(this.monthLabel, this.count, this.averageIntensity);
}

class WeeklyPainData {
  final DateTime weekStart;
  final String averagePainIntensity;

  WeeklyPainData(this.weekStart, this.averagePainIntensity);
}

class MonthlyPainAverageData {
  final DateTime day;
  final String averagePainIntensity;

  MonthlyPainAverageData(this.day, this.averagePainIntensity);
}

class YearlyPainData {
  final String month;
  final String averagePainIntensity;

  YearlyPainData(this.month, this.averagePainIntensity);
}
