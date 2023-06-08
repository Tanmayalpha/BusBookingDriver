import 'dart:async';
import 'dart:convert';

import 'package:deliveryboy_multivendor/Helper/Session.dart';
import 'package:deliveryboy_multivendor/Helper/app_assets.dart';
import 'package:deliveryboy_multivendor/Helper/app_btn.dart';
import 'package:deliveryboy_multivendor/Helper/color.dart';
import 'package:deliveryboy_multivendor/Helper/constant.dart';
import 'package:deliveryboy_multivendor/Helper/cropped_container.dart';
import 'package:deliveryboy_multivendor/Helper/string.dart';
import 'package:deliveryboy_multivendor/Screens/home.dart';
import 'package:deliveryboy_multivendor/Screens/privacy_policy.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart';

import '../Dashboard.dart';
import 'send_otp.dart';

class Login extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<Login> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  final mobileController = TextEditingController(text: "");
  final passwordController = TextEditingController(text: "");
  String? countryName;
  FocusNode? passFocus, monoFocus = FocusNode();

  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  bool visible = false;
  String? password, mobile, username, email, id, mobileno;
  bool _isNetworkAvail = true;
  Animation? buttonSqueezeanimation;

  AnimationController? buttonController;

  @override
  void initState() {
    super.initState();
    buttonController = AnimationController(
        duration: const Duration(milliseconds: 2000), vsync: this);

    buttonSqueezeanimation = Tween(
      begin: deviceWidth! * 0.8,
      end: 50.0,
    ).animate(CurvedAnimation(
      parent: buttonController!,
      curve: const Interval(
        0.0,
        0.150,
      ),
    ));
  }

  @override
  void dispose() {
    buttonController!.dispose();
    super.dispose();
  }

  Future<Null> _playAnimation() async {
    try {
      await buttonController!.forward();
    } on TickerCanceled {}
  }

  void validateAndSubmit() async {
    if (validateAndSave()) {
      _playAnimation();
      checkNetwork();
    }
  }

  Future<void> checkNetwork() async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      getLoginUser();
    } else {
      Future.delayed(Duration(seconds: 2)).then((_) async {
        await buttonController!.reverse();
        setState(() {
          _isNetworkAvail = false;
        });
      });
    }
  }

  bool validateAndSave() {
    final form = _formkey.currentState!;
    form.save();
    if (form.validate()) {
      return true;
    }
    return false;
  }

  setSnackbar(String msg) {
   ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        msg,
        textAlign: TextAlign.center,
        style: TextStyle(color: fontColor),
      ),
      backgroundColor: lightWhite,
      elevation: 1.0,
    ));
  }

  Widget noInternet(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
        padding: EdgeInsets.only(top: kToolbarHeight),
        child: Column(mainAxisSize: MainAxisSize.min, children: [
          noIntImage(),
          noIntText(context),
          noIntDec(context),
          AppBtn(
            title: TRY_AGAIN_INT_LBL,
            btnAnim: buttonSqueezeanimation,
            btnCntrl: buttonController,
            onBtnSelected: () async {
              _playAnimation();

              Future.delayed(Duration(seconds: 2)).then((_) async {
                _isNetworkAvail = await isNetworkAvailable();
                if (_isNetworkAvail) {
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                          builder: (BuildContext context) => super.widget));
                } else {
                  await buttonController!.reverse();
                  setState(() {});
                }
              });
            },
          )
        ]),
      ),
    );
  }

  Future<void> getLoginUser() async {
    var data = {MOBILE: mobile, PASSWORD: password};
    try {
      var response = await post(getUserLoginApi, body: data, headers: headers)
          .timeout(Duration(seconds: timeOut));
      if (response.statusCode == 200) {
        var getdata = json.decode(response.body);
        bool error = getdata["error"];
        String? msg = getdata["message"];
        await buttonController!.reverse();
        print("erorr here ${error}");
        if (!error) {
          setSnackbar(msg!);
          var i = getdata["data"][0];
          id = i[ID];
          username = i['name'];
          email = i[EMAIL];
          mobile = i[MOBILE];
          print("data is ${id}");
          print("data is ${response.body}");
          CUR_USERID = id;
          CUR_USERNAME = username;
          saveUserDetail(id!, username!, email!, mobile!);
          setPrefrenceBool(isLogin, true);
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => Home()),
          );
        } else {
          setSnackbar(msg!);
        }
      } else {
        await buttonController!.reverse();
      }
    } on TimeoutException catch (_) {
      await buttonController!.reverse();
      setSnackbar(somethingMSg);
    }
  }

  Widget signInTxt() {
    return Padding(
        padding: const EdgeInsets.only(top: 30.0, left: 30),
        child: Align(
          alignment: Alignment.topLeft,
          child: Text(
            SIGNIN_LBL,
            style: Theme.of(context).textTheme.headline5!.copyWith(
                  color: primary,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ));
  }

  Widget termAndPolicyTxt() {
    return Padding(
      padding: const EdgeInsets.only(
          bottom: 30.0, left: 25.0, right: 25.0, top: 10.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: [
          Text(CONTINUE_AGREE_LBL,
              style: Theme.of(context)
                  .textTheme
                  .caption!
                  .copyWith(color: fontColor, fontWeight: FontWeight.normal)),
          const SizedBox(
            height: 3.0,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => PrivacyPolicy(
                                title: TERM,
                              )));
                },
                child: Text(
                  TERMS_SERVICE_LBL,
                  style: Theme.of(context).textTheme.caption!.copyWith(
                      color: fontColor,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.normal),
                )),
            const SizedBox(
              width: 5.0,
            ),
            Text(AND_LBL,
                style: Theme.of(context)
                    .textTheme
                    .caption!
                    .copyWith(color: fontColor, fontWeight: FontWeight.normal)),
            const SizedBox(
              width: 5.0,
            ),
            InkWell(
                onTap: () {
                  Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const PrivacyPolicy(
                                title: PRIVACY,
                              )
                      )
                  );
                },
                child: Text(
                  PRIVACY_POLICY_LBL,
                  style: Theme.of(context).textTheme.caption!.copyWith(
                      color: fontColor,
                      decoration: TextDecoration.underline,
                      fontWeight: FontWeight.normal),
                )),
          ]),
        ],
      ),
    );
  }

  Widget setMobileNo() {
    return Container(
      width: deviceWidth! * 0.8,
      padding: const EdgeInsets.only(
        top: 30.0,
      ),
      child: TextFormField(
        maxLength: 10,
        onFieldSubmitted: (v) {
          FocusScope.of(context).requestFocus(passFocus);
        },
        keyboardType: TextInputType.number,
        controller: mobileController,
        style: const TextStyle(color: fontColor, fontWeight: FontWeight.normal),
        focusNode: monoFocus,
        textInputAction: TextInputAction.next,
        inputFormatters: [FilteringTextInputFormatter.digitsOnly],
        validator: validateMob,
        onSaved: (String? value) {
          mobile = value;
        },
        decoration: InputDecoration(
          counterText: "",
          prefixIcon: const Icon(
            Icons.call_outlined,
            color: fontColor,
            size: 17,
          ),
          hintText: MOBILEHINT_LBL,
          hintStyle: Theme.of(context)
              .textTheme
              .subtitle2!
              .copyWith(color: fontColor, fontWeight: FontWeight.normal),
          // filled: true,
          // fillColor: lightWhite,
          contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
          prefixIconConstraints: BoxConstraints(minWidth: 40, maxHeight: 20),
          focusedBorder: OutlineInputBorder(
            borderSide: BorderSide(color: fontColor),
            borderRadius: BorderRadius.circular(7.0),
          ),
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: lightBlack2),
            borderRadius: BorderRadius.circular(7.0),
          ),
        ),
      ),
    );
  }

  Widget setPass() {
    return Container(
        width: deviceWidth! * 0.8,
        padding: EdgeInsets.only(top: 20.0),
        child: TextFormField(
          keyboardType: TextInputType.text,
          obscureText: true,
          focusNode: passFocus,
          style: TextStyle(color: fontColor),
          controller: passwordController,
          validator: validatePass,
          onSaved: (String? value) {
            password = value;
          },
          decoration: InputDecoration(
            prefixIcon: Icon(
              Icons.lock_outline,
              color: fontColor,
              size: 17,
            ),
            hintText: PASSHINT_LBL,
            hintStyle: Theme.of(this.context)
                .textTheme
                .subtitle2!
                .copyWith(color: fontColor, fontWeight: FontWeight.normal),
            // filled: true,
            // fillColor: lightWhite,
            contentPadding: EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            prefixIconConstraints: BoxConstraints(minWidth: 40, maxHeight: 25),
            focusedBorder: OutlineInputBorder(
              borderSide: BorderSide(color: fontColor),
              borderRadius: BorderRadius.circular(10.0),
            ),
            enabledBorder: UnderlineInputBorder(
              borderSide: BorderSide(color: lightBlack2),
              borderRadius: BorderRadius.circular(10.0),
            ),
          ),
        ));
  }

  Widget forgetPass() {
    return Padding(
        padding: const EdgeInsets.only(left: 25.0, right: 25.0, top: 10.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            InkWell(
              onTap: () {
                // setPrefrence(ID, id!);
                // setPrefrence(MOBILE, mobile!);
                Navigator.push(context, MaterialPageRoute(builder: (context) => SendOtp(title: FORGOT_PASS_TITLE,)));
              },
              child: Text(FORGOT_PASSWORD_LBL,
                  style: Theme.of(context).textTheme.subtitle2!.copyWith(
                        color: fontColor,
                        fontWeight: FontWeight.normal,
                      )),
            ),
          ],
        ));
  }

  Widget loginBtn() {
    return AppBtn(
      title: SIGNIN_LBL,
      btnAnim: buttonSqueezeanimation,
      btnCntrl: buttonController,
      onBtnSelected: () async {
        validateAndSubmit();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    deviceHeight = MediaQuery.of(context).size.height;
    deviceWidth = MediaQuery.of(context).size.width;

    return Scaffold(
        key: _scaffoldKey,
        body: _isNetworkAvail
            ? Container(
                color: lightWhite,
                child: Stack(
                  children: [
                    Container(
                      width: double.infinity,
                      height: double.infinity,
                      decoration: back(),
                    ),
                    Image.asset(
                      'assets/images/doodle.png',
                      fit: BoxFit.fill,
                      width: double.infinity,
                      height: double.infinity,
                    ),
                    getLoginContainer(),
                    getLogo(),
                  ],
                ),
              )
            : noInternet(context));
  }

  Widget getLoginContainer() {
    return Positioned.directional(
      start: MediaQuery.of(context).size.width * 0.025,
      // end: width * 0.025,
      // top: width * 0.45,
      top: MediaQuery.of(context).size.height * 0.2, //original
      //    bottom: height * 0.1,
      textDirection: Directionality.of(context),
      child: ClipPath(
        clipper: ContainerClipper(),
        child: Container(
          alignment: Alignment.center,
          padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom * 0.8),
          height: MediaQuery.of(context).size.height * 0.7,
          width: MediaQuery.of(context).size.width * 0.95,
          color: white,
          child: Form(
            key: _formkey,
            child: ScrollConfiguration(
              behavior: MyBehavior(),
              child: SingleChildScrollView(
                child: ConstrainedBox(
                  constraints: BoxConstraints(
                    maxHeight: MediaQuery.of(context).size.height * 2,
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.10,
                      ),
                      signInTxt(),
                      setMobileNo(),
                      setPass(),
                      forgetPass(),
                      loginBtn(),
                      // termAndPolicyTxt(),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget getLogo() {
    return Positioned(
      // textDirection: Directionality.of(context),
      left: (MediaQuery.of(context).size.width / 2) - 50,
      // right: ((MediaQuery.of(context).size.width /2)-55),

      top: (MediaQuery.of(context).size.height * 0.2) - 50,
      //  bottom: height * 0.1,
      child: SizedBox(
        width: 100,
        height: 100,
        child: Image.asset(MyAsset.loginLogo
            // 'assets/images/loginlogo.png',
            ),
      ),
    );
  }
}
