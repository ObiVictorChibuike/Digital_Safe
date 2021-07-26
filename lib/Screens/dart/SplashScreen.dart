import 'dart:async';
import 'package:flutter/material.dart';
import 'file:///C:/Users/JASON/AndroidStudioProjects/safe/lib/Screens/dart/DashBoard.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:safe/Widgets/Constants.dart';

class SplashScreen extends StatefulWidget {
  @override
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    Timer(Duration(seconds: 5), ()=>Navigator.pushReplacement(
        context, MaterialPageRoute(builder: (context) => DashBoard())));
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Stack(
          children: [
            Container(
              height: MediaQuery.of(context).size.height,
              width: MediaQuery.of(context).size.width,
              color: Colors.blue[50],
              // decoration: BoxDecoration(
              //     image: DecorationImage(
              //       image: AssetImage('assets/Money.jpg'),
              //       fit: BoxFit.fill,
              //     )
              // ),
              child: Align(
                alignment: Alignment.center,
                child: Container(
                  padding: EdgeInsets.all(10),
                  child: SpinKitFadingCircle(
                    color: DarkPrimaryColor,
                    size: 50.0,
                  )
                ),
              ),
            ),
            Container(alignment: Alignment.center, margin: EdgeInsets.only(top: 115),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                      "DiGITAL SAFE",
                      style: TextStyle(fontWeight: FontWeight.bold, fontSize: 35, color: BluePrimaryColor,fontFamily: 'PermanentMarker')
                  ),
                  SizedBox(
                    height: 5,
                  ),
                  Text(
                      "...Trust And Guarantee",
                      style: TextStyle(fontWeight: FontWeight.normal, fontSize: 14,fontStyle: FontStyle.italic, color: BluePrimaryColor,fontFamily: 'Poppins')
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
