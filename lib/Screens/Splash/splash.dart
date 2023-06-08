import 'dart:async';
import 'package:deliveryboy_multivendor/Helper/Session.dart';
import 'package:deliveryboy_multivendor/Helper/app_assets.dart';
import 'package:deliveryboy_multivendor/Screens/Authentication/login.dart';
import 'package:deliveryboy_multivendor/Screens/Dashboard.dart';
import 'package:deliveryboy_multivendor/Screens/home.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../Helper/color.dart';
import '../../Helper/string.dart';

//splash screen of app
class Splash extends StatefulWidget {
  @override
  _SplashScreen createState() => _SplashScreen();
}

class _SplashScreen extends State<Splash> {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();

  @override
  void initState() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
    super.initState();
    startTime();
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      key: _scaffoldKey,
      body:Container(
          decoration: BoxDecoration(
            color: Colors.white,
            image: DecorationImage(
                image: AssetImage("assets/logo/splashscreen.png"),
                // fit: BoxFit.cover
            ),
          ),
      ),
      // bottomNavigationBar:Image.asset("assets/logo/fruit.png"),
      // body: Stack(
      //   alignment: Alignment.center,
      //
      //   children: <Widget>[
      //     // Container(
      //     //   width: double.infinity,
      //     //   height: double.infinity,
      //     //   decoration: back(),
      //     // ),
      //     // Image.asset(
      //     //   'assets/images/doodle.png',
      //     //   fit: BoxFit.fill,
      //     //   width: double.infinity,
      //     //   height: double.infinity,
      //     // ),
      //     // Container(
      //     //   width: 200,
      //     //   height: 200,
      //     //   child: Center(
      //     //     child: Image.asset("assets/logo/splashscreen.png"),
      //     //   ),
      //     // ),
      //   ],
      // ),
    );
  }

  startTime() async {
    var _duration = Duration(seconds: 3);
    return Timer(_duration, navigationPage);
  }

  Future<void> navigationPage() async {
    bool isFirstTime = await getPrefrenceBool(isLogin);
    if (isFirstTime) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Home(),
          ));
    } else {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Login(),
          ),
      );
    }
  }

  setSnackbar(String msg) {
   ScaffoldMessenger.of(context).showSnackBar(new SnackBar(
      content: new Text(
        msg,
        textAlign: TextAlign.center,
        style: TextStyle(color: black),
      ),
      backgroundColor: white,
      elevation: 1.0,
    ));
  }

  @override
  void dispose() {
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual,
        overlays: [SystemUiOverlay.top]);
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      statusBarIconBrightness: Brightness.light,
    ));
    super.dispose();
  }
}
