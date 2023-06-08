import 'package:connectivity/connectivity.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:jaguar_jwt/jaguar_jwt.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

import 'color.dart';
import 'constant.dart';
import 'constant.dart';
import 'string.dart';



setPrefrence(String key, String value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setString(key, value);
}

Future<String?> getPrefrence(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getString(key);
}

setPrefrenceBool(String key, bool value) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  await prefs.setBool(key, value);
}

Future<bool> getPrefrenceBool(String key) async {
  SharedPreferences prefs = await SharedPreferences.getInstance();
  return prefs.getBool(key) ?? false;
}

Future<bool> isNetworkAvailable() async {
  var connectivityResult = await (Connectivity().checkConnectivity());
  if (connectivityResult == ConnectivityResult.mobile) {
    return true;
  } else if (connectivityResult == ConnectivityResult.wifi) {
    return true;
  }
  return false;
}

back() {
  return BoxDecoration(

    gradient: LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [grad1Color, grad2Color],
        stops: [0, 1]),
  );
}

shadow() {
  return BoxDecoration(
    boxShadow: [
      BoxShadow(color: Color(0x1a0400ff), offset: Offset(0, 0), blurRadius: 30)
    ],
  );
}

placeHolder(double height) {
  return AssetImage(
    'assets/images/placeholder.png',
  );
}

errorWidget(double size) {
  return Icon(
    Icons.account_circle,
    color: Colors.grey,
    size: size,
  );
}

getAppBar(String title, BuildContext context) {
  return AppBar(
    leading: Builder(builder: (BuildContext context) {
      return Container(
        margin: EdgeInsets.all(10),

        child: InkWell(
          borderRadius: BorderRadius.circular(4),
          onTap: () => Navigator.of(context).pop(),
          child: Center(
            child: Icon(
              Icons.keyboard_arrow_left,
              color: primary,
              size: 30,
            ),
          ),
        ),
      );
    }),
    title: Text(
      title,
      style: TextStyle(
        color: primary,
      ),
    ),
    backgroundColor: white,
  );
}

noIntImage() {
  return Image.asset(
    'assets/images/no_internet.png',
    fit: BoxFit.contain,
  );
}

noIntText(BuildContext context) {
  return Container(
      child: Text(NO_INTERNET,
          style: Theme.of(context)
              .textTheme
              .headline5!
              .copyWith(color: primary, fontWeight: FontWeight.normal)));
}

noIntDec(BuildContext context) {
  return Container(
    padding: EdgeInsets.only(top: 30.0, left: 30.0, right: 30.0),
    child: Text(NO_INTERNET_DISC,
        textAlign: TextAlign.center,
        style: Theme.of(context).textTheme.headline6!.copyWith(
              color: lightBlack2,
              fontWeight: FontWeight.normal,
            )),
  );
}


Widget showCircularProgress(bool _isProgress, Color color) {
  if (_isProgress) {
    return Center(
        child: CircularProgressIndicator(
      valueColor: new AlwaysStoppedAnimation<Color>(color),
    ));
  }
  return Container(
    height: 0.0,
    width: 0.0,
  );
}

imagePlaceHolder(double size) {
  return new Container(
    height: size,
    width: size,
    child: Icon(
      Icons.account_circle,
      color: white,
      size: size,
    ),
  );
}

Future<void> clearUserSession() async {
  final waitList = <Future<void>>[];

  SharedPreferences prefs = await SharedPreferences.getInstance();

  waitList.add(prefs.remove(ID));
  waitList.add(prefs.remove(MOBILE));
  waitList.add(prefs.remove(EMAIL));
  CUR_USERID = '';
  CUR_USERNAME = "";
  CUR_BALANCE = '';

  await prefs.clear();
}

Future<void> saveUserDetail(
    String userId,
    String name,
    String email,
    String mobile) async {
  final waitList = <Future<void>>[];
  SharedPreferences prefs = await SharedPreferences.getInstance();
  waitList.add(prefs.setString(ID, userId));
  waitList.add(prefs.setString(USERNAME, name));
  waitList.add(prefs.setString(EMAIL, email));
  waitList.add(prefs.setString(MOBILE, mobile));
  await Future.wait(waitList);
}

String? validateField(String? value) {
  if (value!.length == 0)
    return FIELD_REQUIRED;
  else
    return null;
}

String? validateUserName(String? value) {
  if (value!.isEmpty) {
    return USER_REQUIRED;
  }
  if (value.length <= 1) {
    return USER_LENGTH;
  }
  return null;
}

String? validateMob(String? value) {
  if (value!.isEmpty) {
    return MOB_REQUIRED ;
  }
  if (value.length < 9) {
    return VALID_MOB;
  }
  return null;
}


String? validatePass(String? value) {
  if (value!.length == 0)
    return PWD_REQUIRED;
  else if (value.length <= 5)
    return PWD_LENGTH;
  else
    return null;
}

String? validateAltMob(String value) {
  if (value.isNotEmpty) if (value.length <9) {
    return VALID_MOB;
  }
  return null;
}



Widget getProgress() {
  return Center(child: CircularProgressIndicator());
}

Widget getNoItem() {
  return Center(child: Text(noItem));
}
String capitalize(String s) => s[0].toUpperCase() + s.substring(1);

Widget shimmer() {
  return Container(
    width: double.infinity,
    padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
    child: Shimmer.fromColors(
      baseColor: Colors.grey[300]!,
      highlightColor: Colors.grey[100]!,
      child: SingleChildScrollView(
        child: Column(
          children: [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
              .map((_) => Padding(
                    padding: const EdgeInsets.only(bottom: 8.0),
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: 80.0,
                          height: 80.0,
                          color: white,
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Container(
                                width: double.infinity,
                                height: 18.0,
                                color: white,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5.0),
                              ),
                              Container(
                                width: double.infinity,
                                height: 8.0,
                                color: white,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5.0),
                              ),
                              Container(
                                width: 100.0,
                                height: 8.0,
                                color: white,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 5.0),
                              ),
                              Container(
                                width: 20.0,
                                height: 8.0,
                                color: white,
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  ))
              .toList(),
        ),
      ),
    ),
  );
}

String getToken() {
  final claimSet =
      new JwtClaim(issuer: 'eshop', maxAge: const Duration(minutes: 5));

  String token = issueJwtHS256(claimSet, jwtKey);

  return token;
}

Map<String, String> get headers => {
      "Authorization": 'Bearer ' + getToken(),
    };

class MyBehavior extends ScrollBehavior {
  @override
  Widget buildViewportChrome(
      BuildContext context, Widget child, AxisDirection axisDirection) {
    return child;
  }
}
