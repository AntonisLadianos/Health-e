import 'package:animated_splash_screen/animated_splash_screen.dart';
import 'package:app/pages/AuthPages/login_page.dart';

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    Widget splash = AnimatedSplashScreen(
      centered: true,
      duration: 1000,
      splash: Image.asset("assets/icon1.jpg"),
      nextScreen: NewLoginSceen(),
      splashIconSize: 120,
      splashTransition: SplashTransition.fadeTransition,
    );

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        timePickerTheme: _timePickerTheme,
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.cyan),
        textTheme: GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme),
      ),
      home: splash,
    );
  }

  final _timePickerTheme = TimePickerThemeData(
    dayPeriodTextColor: Colors.black,
    hourMinuteTextStyle: TextStyle(
      fontSize: 24,
    ),
    entryModeIconColor: Colors.black,
  );
}
