// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:app/pages/OtherPages/chronis_page.dart';
import 'package:app/pages/OtherPages/edit_profile.dart';
import 'package:app/pages/AuthPages/login_page.dart';
import 'package:app/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfilePage extends StatefulWidget {
  const ProfilePage({super.key});

  @override
  State<ProfilePage> createState() => _ProfilePageState();
}

class _ProfilePageState extends State<ProfilePage> {
  Future<SharedPreferences> _pref = SharedPreferences.getInstance();
  String firstName = "";
  String lastName = "";
  String profile = "assets/user.png";
  late Widget avatar = Container(
    height: 100,
  );

  @override
  void initState() {
    getUserData().then((_) {
      avatar = CircleAvatar(
        radius: 50,
        backgroundColor: Colors.grey[200],
        backgroundImage: profile == "assets/user.png"
            ? AssetImage(profile)
            : FileImage(File(profile)) as ImageProvider<Object>?,
      );
    });
    super.initState();
  }

  Future<void> getUserData() async {
    final SharedPreferences sp = await _pref;

    setState(() {
      firstName = sp.getString('first_name')!;
      lastName = sp.getString('last_name')!;
      profile = sp.getString('profile_photo')!;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
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
          "My Profile",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(30),
          child: Column(
            children: [
              imageProfile(),
              SizedBox(height: 10),
              Text("$firstName $lastName"),
              SizedBox(height: 10),
              SizedBox(
                width: 200,
                child: ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).push(MaterialPageRoute(
                      builder: (context) => UpdateProfileScreen(),
                    ));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Constants.secondarycolor,
                    side: BorderSide.none,
                    shape: StadiumBorder(),
                  ),
                  child: Text(
                    "Edit Profile",
                    style: TextStyle(color: Constants.primarycolor),
                  ),
                ),
              ),
              SizedBox(height: 30),
              Divider(),
              SizedBox(height: 10),

              //menu
              ProfileMenu(
                title: "My Cronics Conditions",
                icon: LineIcons.medicalNotes,
                textColor: Constants.primarycolor,
                onPress: () {
                  Navigator.of(context).push(MaterialPageRoute(
                    builder: (context) => Chronics(),
                  ));
                },
              ),

              SizedBox(height: 10),
              ProfileMenu(
                title: "Information",
                icon: LineIcons.info,
                textColor: Constants.primarycolor,
                onPress: () {
                  showInformationDialog(context);
                },
              ),
              SizedBox(height: 10),

              ProfileMenu(
                title: "Logout",
                icon: LineIcons.alternateSignOut,
                textColor: Colors.red,
                endIcon: false,
                onPress: () {
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => NewLoginSceen()));
                },
              ),

              //
            ],
          ),
        ),
      ),
    );
  }

  Widget imageProfile() {
    return SafeArea(
      child: Stack(
        children: [avatar],
      ),
    );
  }

  void showInformationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('App Information'),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('App Name: Health-e'),
              Text('Version: 1.0.0'),
              Text('Author: Antonis Ladianos'),
              // Add more information about your app as needed
            ],
          ),
          actions: [
            ElevatedButton(
              child: Text('Close'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
