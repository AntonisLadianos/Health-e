// ignore_for_file: prefer_typing_uninitialized_variables

import 'package:app/core/db/db_helper.dart';
import 'package:app/core/db/helper.dart';
import 'package:app/features/auth/models/user_model.dart';
import 'package:app/features/presentation/pages/login_page.dart';
import 'package:app/core/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';

late bool _passwordVisible;

class RegisterScreen extends StatefulWidget {
  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _formKey = GlobalKey<FormState>();

  final fNameController = TextEditingController();
  final lNameController = TextEditingController();
  final emailController = TextEditingController();
  final bDateController = TextEditingController();
  final passController = TextEditingController();
  final comfPassController = TextEditingController();
  var dbHelper;
  final String defaultProfileImage = 'assets/user.png';

  @override
  void initState() {
    super.initState();

    dbHelper = DbHelper();
    _passwordVisible = true;
  }

  signUp() async {
    final form = _formKey.currentState;

    String fname = fNameController.text;
    String lname = lNameController.text;
    String email = emailController.text;
    String bdate = bDateController.text;
    String rpass = passController.text;
    String compass = comfPassController.text;
    String profileimg = defaultProfileImage;

    if (form!.validate()) {
      if (rpass != compass) {
        alertDialogerror(context, 'Passwords Do Not Match');
      } else {
        await dbHelper.checkEmail(email).then(
          (userData) async {
            if (userData == null) {
              alertDialogerror(context, "This Email Address Already Used!");
              await Future.delayed(
                Duration(milliseconds: 100),
              );
            } else {
              form.save();
              UserModel uModel =
                  UserModel(fname, lname, email, bdate, rpass, profileimg);

              dbHelper.saveData(uModel).then(
                (userData) async {
                  alertDialogsuccess(context, "Register Has Successfully");
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (_) => NewLoginSceen()),
                  );
                },
              ).catchError(
                (error) {
                  print(error);
                  alertDialogerror(
                      context, "Unexepcted Error. Please Try Again Later!");
                },
              );
              print("$email" "\n$rpass");
            }
          },
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return Scaffold(
      resizeToAvoidBottomInset: true,
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
                SizedBox(height: 10),
                Flexible(
                  child: Container(
                    width: queryData.size.width - 70,
                    height: queryData.size.height * 0.7,
                    padding: const EdgeInsets.all(20.0),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: Constants.primarycolor.withOpacity(0.2),
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        children: [
                          _firstNameInput(),
                          SizedBox(height: 20),
                          _lastNameInput(),
                          SizedBox(height: 20),
                          _registeremailInput(),
                          SizedBox(height: 20),
                          _birthDateInput(),
                          SizedBox(height: 20),
                          _registerPasswordInput(),
                          SizedBox(height: 20),
                          _registerComfPasswordInput(),
                          SizedBox(height: 20),
                          _registerSignUpButton(context),
                          _registerloginButton(context),
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
    );
  }

  //signIn
  TextButton _registerloginButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (_) => NewLoginSceen()),
          (Route<dynamic> route) => false,
        );
      },
      child: Text(
        "LOGIN",
        style: TextStyle(
            fontSize: 16,
            color: Constants.secondarycolor,
            fontWeight: FontWeight.bold),
      ),
    );
  }

  //signUp
  SizedBox _registerSignUpButton(BuildContext context) {
    return SizedBox(
      width: 160,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Constants.secondarycolor,
          foregroundColor: Constants.primarycolor,
        ),
        onPressed: signUp,
        child: Text(
          "SIGNUP",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  //Comfirm pass
  TextFormField _registerComfPasswordInput() {
    return TextFormField(
      controller: comfPassController,
      obscureText: _passwordVisible,
      cursorColor: Constants.primarycolor,
      validator: (val) =>
          val!.isEmpty ? 'Please Enter Again Your Password' : null,
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
        hintText: "Comfirm Password",
        hintStyle: TextStyle(
          color: Constants.primarycolor,
          fontWeight: FontWeight.bold,
        ),
        filled: true,
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: Colors.red,
          ),
          borderRadius: BorderRadius.circular(50.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: Colors.red,
          ),
          borderRadius: BorderRadius.circular(50.0),
        ),
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

  //password
  TextFormField _registerPasswordInput() {
    return TextFormField(
      controller: passController,
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
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: Colors.red,
          ),
          borderRadius: BorderRadius.circular(50.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: Colors.red,
          ),
          borderRadius: BorderRadius.circular(50.0),
        ),
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
      validator: (val) {
        if (val!.isEmpty) {
          return 'Please enter your password';
        }
        if (val.length < 4) {
          return 'Password must be at least 4 characters long';
        }

        if (!RegExp(r'^(?=.*[a-z])').hasMatch(val)) {
          return 'Password must contain at least one lowercase letter';
        }
        if (!RegExp(r'^(?=.*[0-9])').hasMatch(val)) {
          return 'Password must contain at least one digit';
        }

        return null;
      },
    );
  }

//BDate
  TextFormField _birthDateInput() {
    return TextFormField(
      controller: bDateController,
      readOnly: true,
      cursorColor: Constants.primarycolor,
      validator: (val) => val!.isEmpty ? 'Please Enter Your Birth Date' : null,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        prefixIcon: Icon(
          LineIcons.calendar,
          color: Constants.primarycolor,
        ),
        hintText: "Date Of Birth",
        hintStyle: TextStyle(
          color: Constants.primarycolor,
          fontWeight: FontWeight.bold,
        ),
        filled: true,
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: Colors.red,
          ),
          borderRadius: BorderRadius.circular(50.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: Colors.red,
          ),
          borderRadius: BorderRadius.circular(50.0),
        ),
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
      onTap: () async {
        FocusScope.of(context).requestFocus(FocusNode());
        DateTime? pickeddate = await showDatePicker(
            context: context,
            initialDate: DateTime.now(),
            firstDate: DateTime(1925),
            lastDate: DateTime(2125));

        if (pickeddate != null) {
          setState(() {
            bDateController.text = DateFormat.yMd().format(pickeddate);
          });
        }
      },
    );
  }

  //LName
  TextFormField _lastNameInput() {
    return TextFormField(
      controller: lNameController,
      keyboardType: TextInputType.name,
      cursorColor: Constants.primarycolor,
      validator: (val) => val!.isEmpty ? 'Please Enter Last Name' : null,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        prefixIcon: Icon(
          LineIcons.user,
          color: Constants.primarycolor,
        ),
        hintText: "Last Name",
        hintStyle: TextStyle(
          color: Constants.primarycolor,
          fontWeight: FontWeight.bold,
        ),
        filled: true,
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: Colors.red,
          ),
          borderRadius: BorderRadius.circular(50.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: Colors.red,
          ),
          borderRadius: BorderRadius.circular(50.0),
        ),
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

//Fname
  TextFormField _firstNameInput() {
    return TextFormField(
      controller: fNameController,
      validator: (val) => val!.isEmpty ? 'Please Enter First Name' : null,
      cursorColor: Constants.primarycolor,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
        prefixIcon: Icon(
          LineIcons.user,
          color: Constants.primarycolor,
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: Colors.red,
          ),
          borderRadius: BorderRadius.circular(50.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: Colors.red,
          ),
          borderRadius: BorderRadius.circular(50.0),
        ),
        hintText: "First Name",
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
  TextFormField _registeremailInput() {
    return TextFormField(
      controller: emailController,
      keyboardType: TextInputType.emailAddress,
      cursorColor: Constants.primarycolor,
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Please Enter Your Email Address';
        }
        if (!validateEmail(value)) {
          return 'Please Enter Valid Email';
        }
        return null;
      },
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
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: Colors.red,
          ),
          borderRadius: BorderRadius.circular(50.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: Colors.red,
          ),
          borderRadius: BorderRadius.circular(50.0),
        ),
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
