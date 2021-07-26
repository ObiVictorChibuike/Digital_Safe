import 'package:flutter/material.dart';
import 'file:///C:/Users/JASON/AndroidStudioProjects/safe/lib/Screens/dart/SplashScreen.dart';
import 'package:safe/Widgets/Constants.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: LightPrimaryColor,
      ),
      home: SplashScreen(),
    );
  }
}
