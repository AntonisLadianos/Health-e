import 'package:app/core/db/db_helper.dart';
import 'package:app/core/db/helper.dart';
import 'package:app/home/data/models/Chronics.model .dart';
import 'package:app/core/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Chronics extends StatefulWidget {
  Chronics({super.key});

  @override
  State<Chronics> createState() => _ChronicsState();
}

class _ChronicsState extends State<Chronics> {
  //lista me xronies pathiseis

  final _formKey = GlobalKey<FormState>();
  final _formOtherKey = GlobalKey<FormState>();
  List<Map<String, dynamic>> _allData = [];
  Future<SharedPreferences> _pref = SharedPreferences.getInstance();
  final TextEditingController emailController = TextEditingController();
  bool _isLoading = true;

  TextEditingController otherCondition = TextEditingController();

  MyOption? selectedOption;

//read
  Future<void> _refreshData() async {
    final user = emailController.text;
    final data = await DbHelper.getAllProblems(user);
    setState(() {
      _allData = data;
      _isLoading = false;
    });
  }

// get data from existing logged member
  Future<void> getUserData() async {
    final SharedPreferences sp = await _pref;

    setState(() {
      emailController.text = sp.getString('email')!;
    });
    _refreshData();
  }

//insert
  Future<void> _addProb() async {
    if (selectedOption!.name.isNotEmpty) {
      if (otherCondition.text.isEmpty) {
        DbHelper.insertProblem(emailController.text, selectedOption!.name);
      } else {
        DbHelper.insertProblem(emailController.text, otherCondition.text);
      }
    }
    alertDialogsuccess(context, "Chronic Successfully Added");
    _refreshData();
  }

//delete
  void _deleteProb(int id) async {
    await DbHelper.deleteProb(id);
    alertDialogerror(context, "Chronic Deleted");
    _refreshData();
  }

  @override
  void initState() {
    super.initState();
    getUserData();
    _refreshData();
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
        leading: GestureDetector(
          child: Icon(
            LineIcons.angleLeft,
          ),
          onTap: () {
            Navigator.pop(context);
          },
        ),
        title: Text(
          "My Chronic Diseases",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),

      //BODY

      body: _isLoading
          ? Center(
              child: CircularProgressIndicator(),
            )
          : _allData.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        "assets/notdata.png",
                        width: 200,
                      ),
                      Text(
                        "Not Chronic Diseases...",
                        style: TextStyle(fontSize: 20),
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  itemCount: _allData.length,
                  itemBuilder: (context, index) => Dismissible(
                    confirmDismiss: (DismissDirection direction) async {
                      return await showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return AlertDialog(
                            title: const Text("Confirm"),
                            content: const Text(
                                "Are you sure you wish to delete this Disease?"),
                            actions: <Widget>[
                              TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(true),
                                  child: const Text("Delete")),
                              TextButton(
                                onPressed: () =>
                                    Navigator.of(context).pop(false),
                                child: const Text("Cancel"),
                              ),
                            ],
                          );
                        },
                      );
                    },
                    key: Key(_allData[index]['id'].toString()),
                    direction: DismissDirection.endToStart,
                    onDismissed: (direction) {
                      _deleteProb(_allData[index]['id']);
                    },
                    background: Container(
                      color: Colors.red,
                      alignment: Alignment.centerRight,
                      padding: EdgeInsets.symmetric(horizontal: 16),
                      child: Icon(
                        LineIcons.alternateTrash,
                        color: Colors.white,
                      ),
                    ),
                    child: Card(
                      elevation: 10,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      color: Constants.primarycolor,
                      margin:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 15),
                      child: ListTile(
                        title: Padding(
                          padding: EdgeInsets.symmetric(vertical: 20),
                          child: Text(
                            _allData[index]['title'],
                            style: TextStyle(
                              fontSize: 18,
                              color: Constants.secondarycolor,
                            ),
                          ),
                        ),
                        trailing: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            IconButton(
                              onPressed: () async {
                                await showDialog(
                                  context: context,
                                  builder: (BuildContext context) {
                                    return AlertDialog(
                                      title: const Text("Confirm"),
                                      content: const Text(
                                          "Are you sure you wish to delete this Disease?"),
                                      actions: <Widget>[
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop(true);
                                              _deleteProb(
                                                  _allData[index]['id']);
                                            },
                                            child: const Text("Delete")),
                                        TextButton(
                                          onPressed: () =>
                                              Navigator.of(context).pop(false),
                                          child: const Text("Cancel"),
                                        ),
                                      ],
                                    );
                                  },
                                );
                              },
                              icon: Icon(
                                LineIcons.alternateTrash,
                                color: Colors.redAccent,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: Constants.secondarycolor,
        onPressed: () => showBottomSheet(null),
        child: Icon(
          Icons.add,
          color: Constants.primarycolor,
        ),
      ),
    );
  }

//Show Bottom Form
  void showBottomSheet(int? id) {
    if (id != null) {
      final existingData =
          _allData.firstWhere((element) => element['id'] == id);
      selectedOption = existingData['title'];
    }

    showModalBottomSheet(
      isDismissible: false,
      enableDrag: false,
      elevation: 5,
      isScrollControlled: true,
      context: context,
      builder: (_) => AnimatedContainer(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
        padding: EdgeInsets.only(
          top: 30,
          left: 15,
          right: 15,
          bottom: MediaQuery.of(context).viewInsets.bottom + 50,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Center(
              child: Text(
                "Sellect Your Chronic Disease",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 18,
                ),
              ),
            ),
            Form(
              key: _formKey,
              child: Padding(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: DropdownButtonFormField(
                  isExpanded: true,
                  menuMaxHeight: 600,
                  initialValue: selectedOption,
                  items: chronicDiseases.map((option) {
                    return DropdownMenuItem(
                      value: option,
                      child: Text(
                        option.name,
                        overflow: TextOverflow.ellipsis,
                      ),
                    );
                  }).toList(),
                  onChanged: (newvalue) {
                    setState(() {
                      selectedOption = newvalue;
                      if (newvalue!.name == "Other") {
                        Navigator.of(context).pop();
                        // selectedOption = null;
                        showdialog();
                      } else {}
                    });
                  },
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    hintText: "Choose Your Chronic Disease",
                  ),
                  validator: (value) {
                    if (value == null) {
                      return "Please Give Chronic Condition Name";
                    }
                    return null;
                  },
                ),
              ),
            ),
            SizedBox(height: 25),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                TextButton(
                  style: TextButton.styleFrom(
                    fixedSize: Size(150, 50),
                    backgroundColor: Constants.primarycolor,
                    foregroundColor: Constants.primarycolor,
                  ),
                  onPressed: () {
                    selectedOption = null;
                    otherCondition.text = "";
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    "Close",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Constants.secondarycolor,
                    ),
                  ),
                ),
                TextButton(
                  style: TextButton.styleFrom(
                    fixedSize: Size(150, 50),
                    backgroundColor: Constants.primarycolor,
                    foregroundColor: Constants.primarycolor,
                  ),
                  onPressed: () async {
                    if (_formKey.currentState!.validate()) {
                      if (id == null) {
                        await _addProb();
                      }
                      selectedOption = null;
                      otherCondition.text = "";
                      Navigator.of(context).pop();
                      print("Data Added");
                    }
                  },
                  child: Text(
                    "Add",
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                      color: Constants.secondarycolor,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

//add your Other disease tab
  showdialog() {
    showDialog(
        context: context,
        barrierDismissible: false,
        builder: ((context) => AlertDialog(
              backgroundColor: Colors.grey[200],
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10.0),
              ),
              actionsAlignment: MainAxisAlignment.center,
              title: Text(
                'Add Your Chronic Disease',
                style: TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
              ),
              content: Form(
                key: _formOtherKey,
                child: TextFormField(
                  controller: otherCondition,
                  decoration: InputDecoration(
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                      borderSide: BorderSide(
                        color: Colors.grey,
                        width: 1.0,
                      ),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(20),
                    ),
                    hintText: 'Enter Your Chronic Disease',
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please Give Chronic Condition Name';
                    }
                    return null;
                  },
                ),
              ),
              actions: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(100, 40),
                    backgroundColor: Constants.primarycolor,
                    foregroundColor: Constants.primarycolor,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    otherCondition.text = "";
                    selectedOption = null;
                  },
                  child: Text(
                    "Close",
                    style: TextStyle(color: Constants.secondarycolor),
                  ),
                ),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    fixedSize: Size(100, 40),
                    backgroundColor: Constants.primarycolor,
                    foregroundColor: Constants.primarycolor,
                  ),
                  onPressed: () {
                    if (_formOtherKey.currentState!.validate()) {
                      _addProb();
                      Navigator.of(context).pop();
                      otherCondition.text = "";
                      selectedOption = null;
                    }
                  },
                  child: Text(
                    "Add",
                    style: TextStyle(color: Constants.secondarycolor),
                  ),
                ),
              ],
            )));
  }
}
