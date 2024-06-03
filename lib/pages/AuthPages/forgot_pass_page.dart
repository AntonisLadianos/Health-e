import 'package:app/db/db_helper.dart';
import 'package:app/db/helper.dart';
import 'package:app/pages/AuthPages/login_page.dart';
import 'package:app/utils/const.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:mailer/mailer.dart';
import 'package:mailer/smtp_server.dart';

class ForgotScreen extends StatefulWidget {
  const ForgotScreen({super.key});

  @override
  State<ForgotScreen> createState() => _ForgotScreenState();
}

class _ForgotScreenState extends State<ForgotScreen> {
  final TextEditingController recoveryEmailController = TextEditingController();
  final TextEditingController passController = TextEditingController();
  var dbhelper = DbHelper();

  @override
  Widget build(BuildContext context) {
    MediaQueryData queryData;
    queryData = MediaQuery.of(context);
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(top: queryData.size.height * 0),
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
                height: queryData.size.height * 0.4,
                padding: const EdgeInsets.all(20.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8),
                  color: Constants.primarycolor.withOpacity(0.2),
                ),
                child: SingleChildScrollView(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      SizedBox(height: 10),
                      _forgotEmailInput(),
                      SizedBox(height: 10),
                      _forgotText(),
                      SizedBox(height: 10),
                      _recoveryButton(context),
                      _backButton(context)
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  TextButton _backButton(BuildContext context) {
    return TextButton(
      onPressed: () {
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => NewLoginSceen(),
        ));
      },
      child: Text(
        "BACK",
        style: TextStyle(
            fontSize: 16,
            color: Constants.secondarycolor,
            fontWeight: FontWeight.bold),
      ),
    );
  }

//Email Senter
  Future<void> sendPasswordEmail(String recipientEmail, String password) async {
    // Replace with your email address
    String username = 'healthev1.0.0@gmail.com';

    // Replace with your email password
    String mypassword = 'zbpzydohaoxdmvpt';

    final smtpServer = gmail(username, mypassword);

    final message = Message()
      ..from = Address(username, 'SupportTeam@Helth-e.com')
      ..recipients.add(recipientEmail)
      ..subject = 'Password Recovery'
      ..html =
          "<h1>Health-e App</h1>\n<p>Hi,</p><p>Your Password Is: <b>$password</b></p>";

    try {
      final sendReport = await send(message, smtpServer);
      print('Message sent: ${sendReport.toString()}');
    } catch (e) {
      print('Error sending email: $e');
    }
  }

//Get User Data From Database
  Future<void> getUserData() async {
    String email = recoveryEmailController.text;
    bool emailExists = await DbHelper.instance.checkEmailExistence(email);

    if (!EmailValidator.validate(email)) {
      alertDialogerror(context, "Please Enter A Valid Email");
    } else if (emailExists) {
      String? password = await DbHelper.instance.getPassword(email);
      if (password != null) {
        sendPasswordEmail(email, password);
        Navigator.of(context).pushReplacement(MaterialPageRoute(
          builder: (context) => NewLoginSceen(),
        ));
        alertDialogsuccess(context, "Your Password Will Be Sent To Your Email");
        print('Password: $password');
        print('Email sent');
      }
    } else {
      alertDialogerror(context, 'Email Does Not Exist Please Register');
    }
  }

  SizedBox _recoveryButton(BuildContext context) {
    return SizedBox(
      width: 160,
      height: 50,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Constants.secondarycolor,
          foregroundColor: Constants.primarycolor,
        ),
        onPressed: () {
          String email = recoveryEmailController.text;
          if (email.isEmpty) {
            alertDialogerror(context, "Please Enter Your Email!");
          } else if (email.isNotEmpty) {
            getUserData();
          }
        },
        child: Text(
          "RECOVERY",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Text _forgotText() {
    return Text(
      "We Will Send Your Password To This Email Account",
      style: TextStyle(
        fontSize: 16,
        color: Colors.white,
      ),
      textAlign: TextAlign.center,
    );
  }

  TextFormField _forgotEmailInput() {
    return TextFormField(
      controller: recoveryEmailController,
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

class EmailValidator {
  static bool validate(String email) {
    // Regular expression pattern to validate email format
    const pattern = r'^[\w-]+(\.[\w-]+)*@([a-zA-Z0-9-]+\.)+[a-zA-Z]{2,7}$';

    // Create a regular expression object
    final regex = RegExp(pattern);

    // Check if the email matches the pattern
    return regex.hasMatch(email);
  }
}
