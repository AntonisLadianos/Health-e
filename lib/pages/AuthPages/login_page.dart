// ignore_for_file: prefer_typing_uninitialized_variables, deprecated_member_use

import 'package:app/db/db_helper.dart';
import 'package:app/db/helper.dart';
import 'package:app/model/user_model.dart';
import 'package:app/pages/NavBar/bottom_nav_bar.dart';
import 'package:app/pages/AuthPages/forgot_pass_page.dart';
import 'package:app/pages/AuthPages/register_page.dart';
import 'package:app/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:shared_preferences/shared_preferences.dart';

late bool _passwordVisible;

class NewLoginSceen extends StatefulWidget {
  @override
  State<NewLoginSceen> createState() => _NewLoginSceenState();
}

class _NewLoginSceenState extends State<NewLoginSceen> {
  Future<SharedPreferences> _pref = SharedPreferences.getInstance();
  final _formKey = GlobalKey<FormState>();

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  var dbHelper;

  @override
  void initState() {
    super.initState();

    dbHelper = DbHelper();
    _passwordVisible = true;
  }

  login() async {
    String usermail = emailController.text;
    String userpass = passwordController.text;

    if (usermail.isEmpty) {
      alertDialogerror(context, "Please Enter Email");
    } else if (userpass.isEmpty) {
      alertDialogerror(context, "Please Enter Password");
    } else {
      await dbHelper.getLoginUser(usermail, userpass).then((userData) {
        if (userData != null) {
          setSP(userData).whenComplete(() {
            Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => BottomNav()),
                (Route<dynamic> route) => false);
          });
        } else {
          alertDialogerror(context, "Wrong Email Or Password");
        }
      }).catchError((error) {
        print(error);
        alertDialogerror(context, "Error: Login Fail");
      });
    }
  }

  Future setSP(UserModel user) async {
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
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return WillPopScope(
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.only(top: queryData.size.height * 0.1),
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    Constants.secondarycolor,
                    Constants.primarycolor,
                  ],
                ),
              ),
              height: queryData.size.height,
              width: double.infinity,
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Image.asset('assets/icon1.jpg'),
                  SizedBox(height: 30),
                  Flexible(
                    child: Container(
                      width: queryData.size.width - 70,
                      height: queryData.size.height * 0.5,
                      padding: const EdgeInsets.all(20.0),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: Constants.primarycolor.withOpacity(0.2),
                      ),
                      child: SingleChildScrollView(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            _emailInput(),
                            SizedBox(height: 20),
                            _passwordInput(),
                            _forgotPassword(),
                            _loginButton(),
                            _signUpButton(),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
      onWillPop: () async {
        return false;
      },
    );
  }

//SignUp Button
  TextButton _signUpButton() {
    return TextButton(
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => RegisterScreen(),
        ));
      },
      child: Text(
        "SIGNUP",
        style: TextStyle(
            fontSize: 16,
            color: Constants.secondarycolor,
            fontWeight: FontWeight.bold),
      ),
    );
  }

//Login Button
  SizedBox _loginButton() {
    return SizedBox(
      width: 160,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Constants.secondarycolor,
          foregroundColor: Constants.primarycolor,
        ),
        onPressed: login,
        child: Text(
          "LOGIN",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

//Forgot Password
  TextButton _forgotPassword() {
    return TextButton(
      onPressed: () {
        Navigator.of(context).push(MaterialPageRoute(
          builder: (context) => ForgotScreen(),
        ));
      },
      child: Text(
        "Forgot Password?",
        style: TextStyle(
          fontSize: 16,
          color: Colors.white,
        ),
      ),
    );
  }

  //Password
  TextFormField _passwordInput() {
    return TextFormField(
      controller: passwordController,
      obscureText: _passwordVisible,
      cursorColor: Constants.primarycolor,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        prefixIcon: Icon(
          LineIcons.lock,
          color: Constants.primarycolor,
        ),
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _passwordVisible = !_passwordVisible;
            });
          },
          icon: Icon(
            _passwordVisible ? LineIcons.eyeSlash : LineIcons.eye,
          ),
        ),
        hintText: "Password",
        hintStyle: TextStyle(
          color: Constants.primarycolor,
          fontWeight: FontWeight.bold,
        ),
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: Colors.transparent,
          ),
          borderRadius: BorderRadius.circular(50.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: Colors.transparent,
          ),
          borderRadius: BorderRadius.circular(50.0),
        ),
      ),
    );
  }

  //Email
  TextFormField _emailInput() {
    return TextFormField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      cursorColor: Constants.primarycolor,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        prefixIcon: Icon(
          LineIcons.envelope,
          color: Constants.primarycolor,
        ),
        hintText: "Email",
        hintStyle: TextStyle(
          color: Constants.primarycolor,
          fontWeight: FontWeight.bold,
        ),
        filled: true,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: Colors.transparent,
          ),
          borderRadius: BorderRadius.circular(50.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: Colors.transparent,
          ),
          borderRadius: BorderRadius.circular(50.0),
        ),
      ),
    );
  }
}
