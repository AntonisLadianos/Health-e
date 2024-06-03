import 'package:app/db/db_helper.dart';
import 'package:app/db/helper.dart';
import 'package:app/pages/NavBar/bottom_nav_bar.dart';
import 'package:app/model/models.dart';
import 'package:app/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:syncfusion_flutter_sliders/sliders.dart';

bool reload = false;

class PainScreen extends StatefulWidget {
  const PainScreen({
    super.key,
  });

  @override
  State<PainScreen> createState() => _PainScreenState();
}

class _PainScreenState extends State<PainScreen> {
  final _formKey = GlobalKey<FormState>();

  Future<SharedPreferences> _pref = SharedPreferences.getInstance();
  final TextEditingController emailController = TextEditingController();

  final descriptionController = TextEditingController();
  final intensityController = TextEditingController();

  late DateTime fromDate;
  late DateTime toDate;

  double _value = 1.0;
  bool disableDateTime = false;

  // get data from existing logged member
  Future<void> getUserData() async {
    final SharedPreferences sp = await _pref;

    setState(() {
      emailController.text = sp.getString('email')!;
    });
  }

  //insert
  Future<void> _addPain() async {
    if (intensityController.text.isNotEmpty) {
      DbHelper.insertPain(
        emailController.text,
        descriptionController.text,
        fromDate,
        toDate,
        intensityController.text,
      );

      alertDialogsuccess(context, "Pain Successfully Added");
    } else {
      alertDialogerror(context, "Something Wrong");
    }
  }

  @override
  void initState() {
    super.initState();
    intensityController.text = "1";
    fromDate = DateTime.now();
    toDate = DateTime.now().add(Duration(hours: 2));
    getUserData();
  }

  @override
  void dispose() {
    descriptionController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Add Your Pain",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
        ),
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
        leading: CloseButton(),
        actions: buildEditingActions(),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(12),
        child: Form(
          key: _formKey,
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              SizedBox(height: 20),
              Text(
                "What Is The Intensity Of Your Pain?",
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    _buildPainButton(),
                  ],
                ),
              ),
              SizedBox(height: 20),
              description(),
              SizedBox(height: 20),
              dateTimePickers(),
              SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

//Save Button
  List<Widget> buildEditingActions() => [
        TextButton.icon(
          onPressed: saveForm,
          icon: const Icon(
            LineIcons.plus,
            color: Colors.black,
          ),
          label: Text(
            'Add',
            style: TextStyle(color: Colors.black),
          ),
        )
      ];

  //Description input
  Widget description() => SizedBox(
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.height * 0.2,
        child: TextFormField(
          style: TextStyle(
            fontSize: 20,
          ),
          textAlignVertical: TextAlignVertical.top,
          decoration: InputDecoration(
            border: OutlineInputBorder(),
            hintText: "What More About Pain?",
          ),
          maxLines: null,
          expands: true,
          onFieldSubmitted: (_) => saveForm(),
          controller: descriptionController,
          validator: (description) {
            if (description != null &&
                description.isEmpty &&
                !description.contains(RegExp(r'[a-zA-Z]'))) {
              return "Please What Is Your Pain ?";
            }
            return null;
          },
        ),
      );

  //date time picker
  Widget dateTimePickers() => Column(
        children: [
          SizedBox(height: 10),
          buildHeader(
            header: "Pain Duration:",
            child: Column(
              children: [],
            ),
          ),
          SizedBox(height: 10),
          buildFrom(),
          SizedBox(height: 10),
          buildTo(),
        ],
      );

//from datepicker
  Widget buildFrom() {
    return buildHeader(
      header: 'Pain Started At:',
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: buildDropdownField(
              text: Utils.toDate(fromDate),
              onClicked: () => pickFromDateTime(pickDate: true),
            ),
          ),
          Expanded(
            flex: 2,
            child: buildDropdownField(
              text: Utils.toTime(fromDate),
              onClicked: () => pickFromDateTime(pickDate: false),
            ),
          ),
        ],
      ),
    );
  }

//to datepicker
  Widget buildTo() {
    return buildHeader(
      header: 'Pain Ended At:',
      child: Row(
        children: [
          Expanded(
            flex: 3,
            child: buildDropdownField(
              text: Utils.toDate(toDate),
              onClicked: () => pickToDateTime(pickDate: true),
            ),
          ),
          Expanded(
            flex: 2,
            child: buildDropdownField(
              text: Utils.toTime(toDate),
              onClicked: () => pickToDateTime(pickDate: false),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildDisabledField({required String header, required String text}) {
    return buildHeader(
      header: header,
      child: Row(
        children: [
          Expanded(
            flex: 2,
            child: Text(
              text,
              style: TextStyle(
                fontSize: 18,
              ),
            ),
          ),
        ],
      ),
    );
  }

//dropdown datetime pickerr
  Widget buildDropdownField({
    required String text,
    required onClicked,
  }) =>
      ListTile(
        title: Text(text),
        trailing: Icon(
          Icons.arrow_drop_down,
          color: Colors.black,
        ),
        onTap: onClicked,
      );

//header for datime picker
  Widget buildHeader({
    required String header,
    required Widget child,
  }) =>
      Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(header,
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          child,
        ],
      );

//pick from date time
  Future pickFromDateTime({required bool pickDate}) async {
    final date = await pickDateTime(fromDate, pickDate: pickDate);
    if (date == null) return;

    setState(() => fromDate = date);

    if (date.isAfter(toDate)) {
      toDate =
          DateTime(date.year, date.month, date.day, toDate.hour, toDate.minute);
    }

    if (date.isBefore(toDate)) {
      toDate =
          DateTime(date.year, date.month, date.day, toDate.hour, toDate.minute);
    }

    setState(() => fromDate = date);
  }

//pick to date time
  Future pickToDateTime({required bool pickDate}) async {
    final date = await pickDateTime(
      toDate,
      pickDate: pickDate,
      firstDate: pickDate ? fromDate : null,
    );
    if (date == null) return;

    setState(() => toDate = date);
  }

  Future<DateTime?> pickDateTime(
    DateTime intialDate, {
    required bool pickDate,
    DateTime? firstDate,
  }) async {
    if (pickDate) {
      final date = await showDatePicker(
        context: context,
        initialDate: intialDate,
        firstDate: firstDate ?? DateTime(2015, 8),
        lastDate: DateTime(2100),
      );

      if (date == null) return null;

      final time = Duration(hours: intialDate.hour, minutes: intialDate.minute);

      return date.add(time);
    } else {
      final timeOfDay = await showTimePicker(
        context: context,
        initialTime: TimeOfDay.fromDateTime(intialDate),
      );

      if (timeOfDay == null) return null;

      final date = DateTime(intialDate.year, intialDate.month, intialDate.day);
      final time = Duration(hours: timeOfDay.hour, minutes: timeOfDay.minute);
      return date.add(time);
    }
  }

//save form
  Future saveForm() async {
    final isValid = _formKey.currentState!.validate();

    if (isValid) {
      await _addPain();
      final provider = Provider.of<EventProvider>(context, listen: false);
      provider.getDailyEventCounts();
      provider.getDailypainAverages();
      Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => BottomNav()),
          (Route<dynamic> route) => false);
      print("Data Added");
    }
  }

  Widget _buildPainButton() {
    return Expanded(
      child: Padding(
        padding: EdgeInsets.all(4.0),
        child: SfSlider(
          value: _value,
          min: 1,
          max: 5,
          interval: 1,
          stepSize: 1,
          showDividers: true,
          showLabels: true,
          enableTooltip: true,
          onChanged: (value) {
            setState(() {
              _value = value;
              intensityController.text = _value.toString();
            });
          },
          activeColor: Constants.primarycolor,
        ),
      ),
    );
  }
}
