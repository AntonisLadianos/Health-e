// ignore_for_file: deprecated_member_use, duplicate_ignore

import 'dart:async';

import 'package:app/core/db/db_helper.dart';
import 'package:app/core/db/helper.dart';
import 'package:app/home/presentation/pages/bottom_nav_bar.dart';
import 'package:app/home/presentation/pages/pain_recod.dart';
import 'package:app/home/presentation/pages/symptom_record_page.dart';
import 'package:app/core/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_calendar/calendar.dart';

class CalendarScreen extends StatefulWidget {
  CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen>
    with SingleTickerProviderStateMixin {
  late TabController? _tabController;
  bool _isTab2Active = false;
  List<Map<String, dynamic>> _allDatas = [];
  List<Map<String, dynamic>> _allDatass = [];
  List<Event> _symptoms = [];
  List<Event> _painEvents = [];

  bool buttonSympotms = true;
  bool buttonPains = false;

  final TextEditingController emailController = TextEditingController();
  bool _isLoading = true;

  Future<SharedPreferences> _pref = SharedPreferences.getInstance();

  //read
  Future<void> _refreshData() async {
    final userIds = emailController.text;
    final data = await DbHelper.getAllSymptoms(userIds);
    final paindata = await DbHelper.getAllPains(userIds);

    _allDatas = data;
    _allDatass = paindata;
    _isLoading = false;

    _symptoms = [];
    _painEvents = [];

    // Populate the events list with symptom data
    for (var symptom in _allDatas) {
      final DateTime fromDate = DateTime.parse(symptom['from_date']);
      final DateTime toDate = DateTime.parse(symptom['to_date']);

      _symptoms.add(Event(symptom['symptom_title'], fromDate, toDate,
          color: Constants.symptomschart));
    }

    // Populate the pain events list with pain record data and colors
    for (var painRecord in _allDatass) {
      final DateTime painFromDate = DateTime.parse(painRecord['from_date']);
      final DateTime paintoDate = DateTime.parse(painRecord['to_date']);

      _painEvents.add(Event(
          painRecord['pain_description'], painFromDate, paintoDate,
          color: Constants.intensitychart));
    }
  }

  // get data from existing logged member
  Future<void> getUserData() async {
    final SharedPreferences sp = await _pref;

    setState(() {
      emailController.text = sp.getString('email')!;
    });
    _refreshData();
  }

//delete
  void _deleteProb(int id) async {
    await DbHelper.deleteSymptom(id);
    alertDialogerror(context, "Chronic Deleted");
    _refreshData();
  }

//delete
  void _deletePain(int id) async {
    await DbHelper.deletePain(id);
    alertDialogerror(context, "Pain Deleted");
    _refreshData();
  }

  dynamic timer;

  @override
  void initState() {
    super.initState();
    if (mounted) {
      getUserData();
      _refreshData();
      _tabController = TabController(length: 2, vsync: this);
      _tabController!.addListener(() {
        setState(() {
          _isTab2Active = _tabController!.index == 1;
        });
      });
      timer =
          Timer.periodic(Duration(seconds: 0), (Timer t) => setState(() {}));
    }
  }

  @override
  void dispose() {
    timer.cancel();
    _refreshData();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    bool shouldShowBackButton() {
      return Navigator.of(context).canPop();
    }

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        appBar: AppBar(
          leading: shouldShowBackButton()
              ? IconButton(
                  icon: Icon(LineIcons.angleLeft),
                  onPressed: () {
                    Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (_) => BottomNav()),
                        (Route<dynamic> route) => false);
                  },
                )
              : null,
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
            "Calendar Recordings",
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Constants.primarycolor,
            indicatorSize: TabBarIndicatorSize.tab,
            indicatorWeight: 2,
            tabs: [
              Tab(
                icon: Icon(LineIcons.calendar, color: Constants.primarycolor),
                child: Text(
                  "Calendar",
                  style: TextStyle(
                    color: Constants.primarycolor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              Tab(
                icon: Icon(LineIcons.list, color: Constants.primarycolor),
                child: Text(
                  "Your Recodrs",
                  style: TextStyle(
                    color: Constants.primarycolor,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
        ),

        //calendar body
        body: TabBarView(
          controller: _tabController,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 5),
              child: SfCalendar(
                view: CalendarView.month,
                monthViewSettings: MonthViewSettings(
                  showAgenda: true,
                  agendaItemHeight: 40,
                  agendaViewHeight: 180,
                  appointmentDisplayCount: 4,
                  dayFormat: 'EEE',
                ),
                dataSource: MeetingDataSource([..._symptoms, ..._painEvents]),
                initialSelectedDate: DateTime.now(),
                firstDayOfWeek: 1,
                todayHighlightColor: Constants.primarycolor,
                cellBorderColor: Colors.transparent,
                showNavigationArrow: true,
                showDatePickerButton: true,
                selectionDecoration: BoxDecoration(
                  color: Constants.secondarycolor.withOpacity(0.2),
                  border: Border.all(color: Constants.primarycolor, width: 2),
                  borderRadius: const BorderRadius.all(
                    Radius.circular(10),
                  ),
                ),
              ),
            ),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          buttonSympotms = true;
                          buttonPains = false;
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            // ignore: deprecated_member_use
                            MaterialStateProperty.resolveWith<Color>((states) {
                          if (states.contains(MaterialState.pressed)) {
                            return Constants.primarycolor;
                          } else if (buttonSympotms) {
                            return Constants.primarycolor;
                          } else {
                            return Colors.grey.shade300;
                          }
                        }),
                        foregroundColor:
                            MaterialStateProperty.resolveWith<Color>((states) {
                          if (states.contains(MaterialState.pressed) ||
                              buttonSympotms) {
                            return Constants.secondarycolor;
                          } else {
                            return Constants.primarycolor;
                          }
                        }),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      child: Text(
                        'Symptoms',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                    TextButton(
                      onPressed: () {
                        setState(() {
                          buttonSympotms = false;
                          buttonPains = true;
                        });
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            MaterialStateProperty.resolveWith<Color>((states) {
                          if (states.contains(MaterialState.pressed)) {
                            return Constants.primarycolor;
                          } else if (buttonPains) {
                            return Constants.primarycolor;
                          } else {
                            return Colors.grey.shade300;
                          }
                        }),
                        foregroundColor:
                            MaterialStateProperty.resolveWith<Color>((states) {
                          if (states.contains(MaterialState.pressed) ||
                              buttonPains) {
                            return Constants.secondarycolor;
                          } else {
                            return Constants.primarycolor;
                          }
                        }),
                        shape:
                            MaterialStateProperty.all<RoundedRectangleBorder>(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                      ),
                      child: Text(
                        'Pain',
                        style: TextStyle(fontSize: 20),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 15),
                if (buttonSympotms) ...{
                  Text(
                    'Υour Symptom Records',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  SizedBox(height: 5),
                  Expanded(
                    child: _isLoading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : _allDatas.isEmpty
                            ? Center(
                                child: Text(
                                  "No Records Yet..",
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: _allDatas.length,
                                itemBuilder: (context, index) {
                                  //taksinomish twn hmeromhniwn
                                  List<Map<String, dynamic>> sortedList =
                                      List.from(_allDatas);
                                  sortedList.sort((b, a) {
                                    final DateTime dateA =
                                        DateTime.parse(a['from_date']);
                                    final DateTime dateB =
                                        DateTime.parse(b['from_date']);
                                    return dateA.compareTo(dateB);
                                  });
                                  _allDatas = sortedList;
                                  return Container(
                                    margin: EdgeInsets.only(
                                        left: 15, right: 15, top: 20),
                                    decoration: BoxDecoration(
                                      color: Constants.primarycolor,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Constants.primarycolor
                                              .withOpacity(0.5),
                                          spreadRadius: 3,
                                          blurRadius: 5,
                                        ),
                                      ],
                                    ),
                                    child: Stack(
                                      children: [
                                        ListTile(
                                          title: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(height: 10),
                                              Text(
                                                DateFormat('dd/MM/yy').format(
                                                  DateTime.parse(
                                                      _allDatas[index]
                                                          ['from_date']),
                                                ),
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color:
                                                      Constants.backgroundColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                _allDatas[index]
                                                    ['symptom_title'],
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Constants
                                                        .backgroundColor),
                                              ),
                                              RichText(
                                                overflow: TextOverflow.ellipsis,
                                                text: TextSpan(
                                                  text: _allDatas[index]
                                                              ['description']
                                                          .isEmpty
                                                      ? "Not Description Given..."
                                                      : _allDatas[index]
                                                          ['description'],
                                                  style: TextStyle(
                                                      fontSize: 16,
                                                      color: Constants
                                                          .backgroundColor),
                                                ),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    "Intensity: ",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Constants
                                                            .backgroundColor),
                                                  ),
                                                  Text(
                                                    _allDatas[index]
                                                                ['intensity'] ==
                                                            0
                                                        ? "0"
                                                        : _allDatas[index]
                                                                ['intensity']
                                                            .toString(),
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Constants
                                                            .backgroundColor),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          onTap: () {
                                            recordSymptomsDetails(
                                                context, index);
                                          },
                                        ),
                                        Positioned(
                                          top: 0,
                                          right: 0,
                                          child: IconButton(
                                            icon:
                                                Icon(LineIcons.alternateTrash),
                                            color: Colors.redAccent,
                                            onPressed: () {
                                              _deleteProb(
                                                  _allDatas[index]['id']);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                  ),
                } else ...{
                  Text(
                    'Υour Pain Records',
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 24),
                  ),
                  SizedBox(height: 5),
                  Expanded(
                    child: _isLoading
                        ? Center(
                            child: CircularProgressIndicator(),
                          )
                        : _allDatass.isEmpty
                            ? Center(
                                child: Text(
                                  "No Records Yet..",
                                  style: TextStyle(
                                    fontSize: 20,
                                  ),
                                ),
                              )
                            : ListView.builder(
                                shrinkWrap: true,
                                itemCount: _allDatass.length,
                                itemBuilder: (context, index) {
                                  //taksinomish twn hmeromhniwn
                                  List<Map<String, dynamic>> sortedList =
                                      List.from(_allDatass);
                                  sortedList.sort((b, a) {
                                    final DateTime dateA =
                                        DateTime.parse(a['from_date']);
                                    final DateTime dateB =
                                        DateTime.parse(b['from_date']);
                                    return dateA.compareTo(dateB);
                                  });
                                  _allDatass = sortedList;
                                  return Container(
                                    margin: EdgeInsets.only(
                                        left: 15, right: 15, top: 20),
                                    decoration: BoxDecoration(
                                      color: Constants.primarycolor,
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          topRight: Radius.circular(10),
                                          bottomLeft: Radius.circular(10),
                                          bottomRight: Radius.circular(10)),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Constants.primarycolor
                                              .withOpacity(0.5),
                                          spreadRadius: 3,
                                          blurRadius: 5,
                                        ),
                                      ],
                                    ),
                                    child: Stack(
                                      children: [
                                        ListTile(
                                          title: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              SizedBox(height: 10),
                                              Text(
                                                DateFormat('dd/MM/yy').format(
                                                  DateTime.parse(
                                                      _allDatass[index]
                                                          ['from_date']),
                                                ),
                                                style: TextStyle(
                                                  fontSize: 18,
                                                  color:
                                                      Constants.backgroundColor,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ],
                                          ),
                                          subtitle: Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                _allDatass[index]
                                                    ['pain_description'],
                                                style: TextStyle(
                                                    fontSize: 16,
                                                    color: Constants
                                                        .backgroundColor),
                                              ),
                                              Row(
                                                children: [
                                                  Text(
                                                    "Intensity: ",
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Constants
                                                            .backgroundColor),
                                                  ),
                                                  Text(
                                                    _allDatass[index][
                                                                'pain_intensity'] ==
                                                            0
                                                        ? "1"
                                                        : _allDatass[index][
                                                                'pain_intensity']
                                                            .toString(),
                                                    style: TextStyle(
                                                        fontSize: 16,
                                                        color: Constants
                                                            .backgroundColor),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                          onTap: () {
                                            recordPainDetails(context, index);
                                          },
                                        ),
                                        Positioned(
                                          top: 0,
                                          right: 0,
                                          child: IconButton(
                                            icon:
                                                Icon(LineIcons.alternateTrash),
                                            color: Colors.redAccent,
                                            onPressed: () {
                                              _deletePain(
                                                  _allDatass[index]['pain_id']);
                                            },
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              ),
                  ),
                }
              ],
            )
          ],
        ),
        floatingActionButton: _isTab2Active
            ? buttonSympotms
                ? FloatingActionButton.extended(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => SymptomScreen()));
                    },
                    backgroundColor: Constants.secondarycolor,
                    foregroundColor: Constants.primarycolor,
                    label: Text('New Sympotm'),
                    icon: Icon(Icons.add),
                  )
                : FloatingActionButton.extended(
                    onPressed: () {
                      Navigator.of(context).push(MaterialPageRoute(
                          builder: (context) => PainScreen()));
                    },
                    backgroundColor: Constants.secondarycolor,
                    foregroundColor: Constants.primarycolor,
                    label: Text('New Pain'),
                    icon: Icon(Icons.add),
                  )
            : null,
      ),
    );
  }

  Future<dynamic> recordSymptomsDetails(BuildContext context, int index) {
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: Colors.grey[200],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Symptom Details',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Title:',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              _allDatas[index]['symptom_title'],
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.normal,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Description:',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              _allDatas[index]['description'],
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.normal,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Intensity:',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              _allDatas[index]['intensity'].toString(),
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.normal,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Symptom Time:',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              DateFormat('HH:mm')
                  .format(DateTime.parse(_allDatas[index]['from_date'])),
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<dynamic> recordPainDetails(BuildContext context, int index) {
    final DateTime painStartTime =
        DateTime.parse(_allDatass[index]['from_date']);
    final DateTime painEndTime = DateTime.parse(_allDatass[index]['to_date']);
    final Duration painDuration = painEndTime.difference(painStartTime);
    final int hoursDuration = painDuration.inHours;
    final int minutesDuration = painDuration.inMinutes % 60;
    return showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        backgroundColor: Colors.grey[200],
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Pain Details',
              style: TextStyle(
                fontSize: 24.0,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Description',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              _allDatass[index]['pain_description'],
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.normal,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Intensity:',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              _allDatass[index]['pain_intensity'].toString(),
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.normal,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Pain Time:',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              DateFormat('HH:mm')
                  .format(DateTime.parse(_allDatass[index]['from_date'])),
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.normal,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'Pain Duration:',
              style: TextStyle(
                fontSize: 18.0,
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '${hoursDuration}h ${minutesDuration}m',
              style: TextStyle(
                fontSize: 16.0,
                fontWeight: FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

//data source for CAaendar
class MeetingDataSource extends CalendarDataSource {
  MeetingDataSource(List<Event> source) {
    appointments = source;
  }

  @override
  DateTime getStartTime(int index) {
    return appointments![index].fromDate;
  }

  @override
  DateTime getEndTime(int index) {
    return appointments![index].toDate;
  }

  @override
  String getSubject(int index) {
    return appointments![index].title;
  }

  @override
  Color getColor(int index) {
    return appointments![index].color;
  }
}

class Event {
  final String title;
  final DateTime fromDate;
  final DateTime toDate;
  final Color color;

  Event(this.title, this.fromDate, this.toDate, {required this.color});
}
