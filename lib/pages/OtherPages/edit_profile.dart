// ignore_for_file: deprecated_member_use

import 'dart:io';

import 'package:app/db/db_helper.dart';
import 'package:app/db/helper.dart';
import 'package:app/model/user_model.dart';
import 'package:app/pages/NavBar/bottom_nav_bar.dart';
import 'package:app/model/models.dart';
import 'package:app/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UpdateProfileScreen extends StatefulWidget {
  const UpdateProfileScreen({super.key});

  @override
  State<UpdateProfileScreen> createState() => _UpdateProfileScreenState();
}

class _UpdateProfileScreenState extends State<UpdateProfileScreen> {
  final _formKey = GlobalKey<FormState>();

  final ImagePicker _picker = ImagePicker();
  Future<SharedPreferences> _pref = SharedPreferences.getInstance();
  late bool passwordVisible;
  late DbHelper dbHelper;
  final fNameController = TextEditingController();
  final lNameController = TextEditingController();
  final emailController = TextEditingController();
  final bDateController = TextEditingController();
  final passController = TextEditingController();
  String profileimg = 'assets/user.png';
  XFile? imageFile;
  late Widget avatar = Container(
    height: 100,
  );

  @override
  void initState() {
    getUserData().then((_) {
      avatar = CircleAvatar(
        radius: 50,
        backgroundColor: Colors.grey[200],
        backgroundImage: profileimg == "assets/user.png"
            ? AssetImage(profileimg)
            : FileImage(File(profileimg)) as ImageProvider<Object>?,
      );
    });
    dbHelper = DbHelper();
    passwordVisible = true;
    super.initState();
  }

  Future<void> getUserData() async {
    final SharedPreferences sp = await _pref;

    setState(() {
      fNameController.text = sp.getString('first_name')!;
      lNameController.text = sp.getString('last_name')!;
      emailController.text = sp.getString('email')!;
      bDateController.text = sp.getString('date_of_birth')!;
      passController.text = sp.getString('password')!;
      profileimg = sp.getString('profile_photo')!;
    });
  }

  update() async {
    String fname = fNameController.text;
    String lname = lNameController.text;
    String email = emailController.text;
    String bdate = bDateController.text;
    String rpass = passController.text;
    String profile = profileimg;

    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      UserModel user = UserModel(
        fname,
        lname,
        email,
        bdate,
        rpass,
        profile,
      );
      await dbHelper.updateUser(user).then((value) {
        if (value == 1) {
          alertDialogsuccess(context, "Changes Have Been Successfully Saved");

          updateSp(user).whenComplete(() {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => BottomNav()),
                (Route<dynamic> route) => false);
          });
        } else {
          alertDialogerror(context, "Error");
        }
      }).catchError((error) {
        print(error);
        alertDialogerror(context, "Error");
      });
    }
  }

  Future updateSp(UserModel user) async {
    final SharedPreferences sp = await _pref;

    sp.setString("first_name", user.first_name);
    sp.setString("last_name", user.last_name);
    sp.setString("email", user.email);
    sp.setString("date_of_birth", user.date_of_birth);
    sp.setString("password", user.mpassword);
    sp.setString("profile_photo", user.profileimg);
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
          "Edit Profile",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
      body: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.all(30),
          child: Column(
            children: [
              SizedBox(height: 20),
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    imageProfile(),
                    SizedBox(height: 40),
                    _firstName(),
                    SizedBox(height: 20),
                    _lastName(),
                    SizedBox(height: 20),
                    _email(),
                    SizedBox(height: 20),
                    _bdate(),
                    SizedBox(height: 20),
                    _password(),
                    SizedBox(height: 20),
                    _saveButton(context),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  SizedBox _saveButton(BuildContext context) {
    return SizedBox(
      width: 200,
      child: ElevatedButton(
        onPressed: () {
          update();
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: Constants.secondarycolor,
          side: BorderSide.none,
          shape: StadiumBorder(),
        ),
        child: Text(
          "Save Changes",
          style: TextStyle(color: Constants.primarycolor),
        ),
      ),
    );
  }

  TextFormField _bdate() {
    return TextFormField(
      controller: bDateController,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        labelText: 'Date Of Birth',
        prefixIcon: Icon(LineIcons.calendarAlt),
      ),
    );
  }

  TextFormField _password() {
    return TextFormField(
      controller: passController,
      obscureText: passwordVisible,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              passwordVisible = !passwordVisible;
            });
          },
          icon: Icon(
            passwordVisible ? LineIcons.eyeSlash : LineIcons.eye,
          ),
        ),
        labelText: 'Password',
        prefixIcon: Icon(LineIcons.fingerprint),
      ),
    );
  }

  TextFormField _email() {
    return TextFormField(
      controller: emailController,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        labelText: 'E-mail',
        prefixIcon: Icon(LineIcons.envelope),
      ),
    );
  }

  TextFormField _lastName() {
    return TextFormField(
      controller: lNameController,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        labelText: 'Last Name',
        prefixIcon: Icon(LineIcons.user),
      ),
    );
  }

  TextFormField _firstName() {
    return TextFormField(
      controller: fNameController,
      decoration: InputDecoration(
        floatingLabelBehavior: FloatingLabelBehavior.auto,
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(100),
        ),
        labelText: 'First Name',
        prefixIcon: Icon(LineIcons.userTie),
      ),
    );
  }

  Widget bottomSheet() {
    return Container(
      height: 100,
      width: MediaQuery.of(context).size.width,
      margin: EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(
        children: [
          Text(
            "Choose Profile Photo",
            style: TextStyle(fontSize: 20),
          ),
          SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              TextButton.icon(
                onPressed: () {
                  takePhoto(ImageSource.camera);
                  Navigator.pop(context);
                },
                icon: Icon(LineIcons.camera),
                label: Text("Camera"),
              ),
              TextButton.icon(
                onPressed: () {
                  takePhoto(ImageSource.gallery);
                  Navigator.pop(context);
                },
                icon: Icon(LineIcons.image),
                label: Text("Gallery"),
              )
            ],
          )
        ],
      ),
    );
  }

  Widget imageProfile() {
    final imageProvider = Provider.of<EventProvider>(context);
    XFile? currentImageFile = imageProvider.imageFile;

    if (currentImageFile != null) {
      imageFile = currentImageFile;
    }

    return SafeArea(
      child: Stack(
        children: [
          avatar,
          Positioned(
            bottom: 0,
            right: 0,
            child: InkWell(
              onTap: () {
                showModalBottomSheet(
                  context: context,
                  builder: ((builder) => bottomSheet()),
                );
              },
              child: Container(
                width: 30,
                height: 30,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: Constants.secondarycolor),
                child: Icon(
                  LineIcons.alternatePencil,
                  color: Constants.primarycolor,
                  size: 20,
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void takePhoto(ImageSource source) async {
    try {
      final pickedFile = await _picker.pickImage(source: source);

      if (pickedFile != null) {
        _updateImage(pickedFile);
      } else {
        print('No image selected.');
      }
    } catch (e) {
      print('Error picking image: $e');
    }
  }

  void _updateImage(XFile pickedFile) {
    final imageProvider = Provider.of<EventProvider>(context, listen: false);
    imageProvider.setImageFile(pickedFile);

    setState(() {
      imageFile = pickedFile;
      profileimg = imageFile!.path;
      avatar = CircleAvatar(
        radius: 50,
        backgroundColor: Colors.grey[200],
        backgroundImage: FileImage(File(profileimg)),
      );
    });
  }
}
