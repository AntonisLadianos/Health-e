import 'package:app/splash/presentation/splash_screen.dart';
import 'package:app/features/auth/models/models.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) => GestureDetector(
        onTap: () => FocusManager.instance.primaryFocus?.unfocus(),
        child: PopScope(
          child: ChangeNotifierProvider(
            create: (context) => EventProvider(),
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              title: 'My Application',
              home: SplashScreen(),
            ),
          ),
        ),
      );
}
