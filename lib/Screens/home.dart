import 'dart:async';
import 'dart:convert';

import 'package:deliveryboy_multivendor/Helper/Session.dart';
import 'package:deliveryboy_multivendor/Helper/app_btn.dart';
import 'package:deliveryboy_multivendor/Helper/color.dart';
import 'package:deliveryboy_multivendor/Helper/constant.dart';
import 'package:deliveryboy_multivendor/Helper/location_details.dart';
import 'package:deliveryboy_multivendor/Helper/push_notification_service.dart';
import 'package:deliveryboy_multivendor/Helper/string.dart';
import 'package:deliveryboy_multivendor/Model/order_model.dart';
import 'package:deliveryboy_multivendor/Screens/Authentication/login.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:http/http.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../Model/BusdetailsModel.dart';
import 'notification_lIst.dart';
import 'order_detail.dart';
import 'privacy_policy.dart';
import 'profile.dart';
import 'wallet_history.dart';

class Home extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StateHome();
  }
}

int? total, offset;
List<Order_Model> orderList = [];
bool _isLoading = true;
bool isLoadingmore = true;
double cash_received = 0.0;
bool isLoadingItems = true;

class StateHome extends State<Home> with TickerProviderStateMixin {

  int curDrwSel = 0;
  bool _isNetworkAvail = true;
  List<Order_Model> tempList = [];
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Animation? buttonSqueezeanimation;
  AnimationController? buttonController;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  String? profile;
  ScrollController controller = ScrollController();
  List<String> statusList = [
    ALL,
    PLACED,
    PROCESSED,
    SHIPED,
    //DELIVERD,
    //CANCLED,
    //RETURNED,
    awaitingPayment
  ];
  String? activeStatus;

  @override
  void initState() {
    dateInput.text = "";
    offset = 0;
    total = 0;
    getBusDetails();
    // orderList.clear();
    getSetting();
    // getOrder();
    // getUserDetail();
    // updateLatLong()

    final pushNotificationService = PushNotificationService(context: context ,
      onResult: (result) async {
      print("this is notification result $result");
      _refresh();
        // Future.delayed(Duration(seconds: 1), (){
        //   getOrder();
        // });
    },);
    //pushNotificationService.initialise();
    // type: type

    // notificationService.initialise();
    buttonController = AnimationController(duration: Duration(milliseconds: 2000), vsync: this);
    buttonSqueezeanimation = Tween(
      begin: deviceWidth! * 0.7,
      end: 50.0,
    ).animate(CurvedAnimation(
      parent: buttonController!,
      curve: Interval(
        0.0,
        0.150,
      ),
    ));
    controller.addListener(_scrollListener);
    super.initState();
    getLocation();
  }

  latLongUpdate() async {
    Timer.periodic(Duration(seconds: 3), (timer) async {
      updateLatLong();
      // Update your UI or perform any necessary operations with the new latitude and longitude values.
    });
  }

  // getDateTime() {
  //   var time =  DateFormat('hh:mm').format(DateTime.now());
  //   DateTime.parse(time);
  //   DateTime.parse(busdetailsModel!.data![0].startTime.toString());
  //   print("date timeeeeee ${time}");
  // }

  bool isStart= false;
  getDateTime() {
    DateTime currentTime = DateTime.now();
    var time =  DateFormat('yyyy-MM-dd').format(DateTime.now());
    DateTime.parse(time);
    String stringTime = "${busdetailsModel!.data![0].startTime}:00"; // Replace with your string time
    DateTime parsedTime = DateTime.parse("$time $stringTime");
    if (parsedTime.isAfter(currentTime)) {
      print("The parsed time is after the current time.");
      isStart= true;
    } else if (parsedTime.isBefore(currentTime)) {
      print("The parsed time is before the current time.");
      isStart = false;
    } else {
      print("The parsed time is equal to the current time.");
    }
  }

  TextEditingController dateInput = TextEditingController();

  TextEditingController startTimeController = TextEditingController();
  var selectedTime1;
  _selectStartTime(BuildContext context) async {
    final TimeOfDay? timeOfDay = await showTimePicker(
        context: context,
        useRootNavigator: true,
        initialTime: TimeOfDay.now(),
        builder: (BuildContext context, Widget? child) {
          return Theme(
            data: ThemeData.light().copyWith(
                colorScheme: ColorScheme.light(primary: Colors.black),
                buttonTheme: ButtonThemeData(
                    colorScheme: ColorScheme.light(primary: Colors.black))),
            child: MediaQuery(
                data: MediaQuery.of(context)
                    .copyWith(alwaysUse24HourFormat: false),
                child: child!),
          );
        });
    if (timeOfDay != null || timeOfDay != selectedTime1) {
      setState(() {
        selectedTime1 = timeOfDay?.replacing(hour: timeOfDay.hourOfPeriod);
        startTimeController.text = selectedTime1!.format(context);
      });
    }
    var per = selectedTime1!.period.toString().split(".");
    print("selected time here ${selectedTime1!.format(context).toString()} and ${per[1]}");
  }

  dateTime() async {
    DateTime? datePicked = await showDatePicker(
        context: context,
        initialDate: DateTime.now(),
        firstDate: DateTime(2000),
        lastDate: DateTime(2024));
     if (datePicked != null) {
      print('Date Selected:${datePicked.day}-${datePicked.month}-${datePicked.year}');
      String formettedDate =
      DateFormat('dd-MM-yyyy').format(datePicked);
      setState(() {
        dateInput.text = formettedDate;
      });
    }
  }

  getLocation() {
    GetLocation location = new GetLocation((result) {
      if (mounted) {
        setState(() {
          address = result.first.addressLine;
          latitude = result.first.coordinates.latitude;
          longitude = result.first.coordinates.longitude;
          print("lat long@@@@@@@@@ ${latitude} and ${longitude}");
        });
      }
    });
    location.getLoc();
  }


  BusdetailsModel? busdetailsModel;
  getBusDetails() async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
    DateTime now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd').format(now);
    var headers = {
      'Cookie': 'ci_session=f88fc350bcc50117ef2e7e272de63ef59f205538'
    };
    var request = http.MultipartRequest('POST', Uri.parse('https://comforttourandtravels.com/driver/api/get_bus_details'));
    request.fields.addAll({
      'user_id': '${CUR_USERID}',
      'date': '${formatter}'
    });
    print("ddddddd ${request.fields}");
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      var finalResult = await response.stream.bytesToString();
      print("ssss ${finalResult}");
      final jsonResponse = BusdetailsModel.fromJson(json.decode(finalResult));
      print("okoko ${jsonResponse} and ${jsonResponse.error}");
      print("bus nameeeee ${busdetailsModel?.data?[0].name}");
      String? bus_id = jsonResponse.data![0].id.toString();
      preferences.setString("bus_id", bus_id);
      print("Bus id here ${bus_id}");
      setState(() {
        busdetailsModel = jsonResponse;
        _isLoading = false;
      });
      getDateTime();
    }
    else {
      print(response.reasonPhrase);
    }
 }

 String? bus_id;

  startBus( String status) async{
    SharedPreferences preferences = await SharedPreferences.getInstance();
   bus_id = preferences.getString("bus_id");
   print("bus id in this apiiii ${bus_id}");
    DateTime now = new DateTime.now();
    var formatter = new DateFormat('yyyy-MM-dd').format(now);
   var request = http.MultipartRequest('POST', Uri.parse('https://comforttourandtravels.com/driver/api/start_bus'));
   request.fields.addAll({
     'bus_id': "${bus_id}",
     'date': '${formatter}',
     'status': status
   });
   print("Start bus apiii para ${request.fields}");
   http.StreamedResponse response = await request.send();
   if (response.statusCode == 200) {
     print(await response.stream.bytesToString());
   }
   else {
     print(response.reasonPhrase);
   }
 }

  updateLatLong() async{
    print("updated lat long apiii");
    var headers = {
      'Cookie': 'ci_session=fc5d9ab7cd4275267ca3c06b10fd27229c319aa3'
    };
    var request = http.MultipartRequest('POST', Uri.parse('https://comforttourandtravels.com/driver/api/update_lat_lng'));
    var parameter = {
      USER_ID: CUR_USERID,
      'lat': latitude,
      'lng': longitude,
    };
    print("Update lat long parameter ${parameter}");
    request.headers.addAll(headers);
    http.StreamedResponse response = await request.send();
    if (response.statusCode == 200) {
      print(await response.stream.bytesToString());
    }
    else {
      print(response.reasonPhrase);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      backgroundColor: lightWhite,
      appBar: AppBar(
        title: Text(
          appName,
          style: TextStyle(
            color: grad2Color, fontSize: 18
          ),
        ),
        iconTheme: IconThemeData(color: grad2Color),
        backgroundColor: white,
        actions: [
          // InkWell(
          //   onTap: filterDialog,
          //   child: Padding(
          //     padding: const EdgeInsets.all(8.0),
          //     child: Icon(
          //       Icons.filter_alt_outlined,
          //       color: primary,
          //     ),
          //   ),
          // ),
        ],
      ),
      drawer: _getDrawer(),
      body: _isNetworkAvail
          ? _isLoading
              ? shimmer()
              : SingleChildScrollView(
               // controller: controller,
               // physics: const AlwaysScrollableScrollPhysics(),
                child: Padding(
                  padding: const EdgeInsets.all(10.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        // _detailHeader(),
                        busdetailsModel?.data?.isEmpty ?? false ? Center(child: CircularProgressIndicator(color: primary,),):
                        Card(
                          elevation: 5,
                          margin: const EdgeInsets.all(5.0),
                          child:
                          Padding(
                                padding: const EdgeInsets.all(8.0),
                                child: Column(
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        child: busdetailsModel!.data![0].profileImage == null || busdetailsModel!.data![0].profileImage =="" ? Center(child: CircularProgressIndicator(color: primary,),):
                                        Image.network("${busdetailsModel!.data![0].profileImage}")
                                      ),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8.0),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: <Widget>[
                                            Text("Bus Name:       "),
                                            Text(
                                              "${busdetailsModel!.data![0].name}",
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 5),
                                      // Spacer(),
                                     Padding(
                                       padding: const EdgeInsets.symmetric(horizontal: 8),
                                       child: Row(children: [
                                         Text("Bus Number:"),
                                         SizedBox(width: 10),
                                         Text("${busdetailsModel!.data![0].vehicleNo}"),
                                       ],
                                       ),
                                     ),
                                      Divider(),
                                      Padding(
                                        padding: const EdgeInsets.symmetric(
                                            horizontal: 8.0, vertical: 5),
                                        child: Row(
                                          children: [
                                            Flexible(
                                              child: Row(
                                                children: [
                                                 Text("Bus Type:    "),
                                                  Text("${busdetailsModel!.data![0].busType}")
                                                  // Expanded(
                                                  //   child: Text(
                                                  //     model.name != null &&
                                                  //         model.name!.isNotEmpty
                                                  //         ? " ${capitalize(model.name!)}"
                                                  //         : " ",
                                                  //     maxLines: 1,
                                                  //     overflow: TextOverflow.ellipsis,
                                                  //   ),
                                                  // ),
                                                ],
                                              ),
                                            ),
                                            // InkWell(
                                            //   child: Row(
                                            //     children: [
                                            //       const Icon(
                                            //         Icons.call,
                                            //         size: 14,
                                            //         color: fontColor,
                                            //       ),
                                            //       Text(
                                            //         " ${model.mobile!}",
                                            //         style: const TextStyle(
                                            //             color: fontColor,
                                            //             decoration: TextDecoration.underline),
                                            //       ),
                                            //     ],
                                            //   ),
                                            //   onTap: () {
                                            //     _launchCaller(index);
                                            //   },
                                            // ),
                                            // TextButton(onPressed: () { _launchCaller(index);}, child: Row(
                                            //   children: [
                                            //     const Icon(
                                            //       Icons.call,
                                            //       size: 14,
                                            //       color: fontColor,
                                            //     ),
                                            //     Text(
                                            //       " ${model.mobile!}",
                                            //       style: const TextStyle(
                                            //           color: fontColor,
                                            //           decoration: TextDecoration.underline),
                                            //     ),
                                            //   ],
                                            // ),
                                            // ),
                                          ],
                                        ),
                                      ),
                                      Container(
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 8.0, vertical: 5),
                                          child: Container(
                                            child: Row(
                                              children: [
                                                Row(
                                                  children: [
                                                    Padding(
                                                      padding: const EdgeInsets.only(left: 1),
                                                      child: Text("Destination:")
                                                    ),
                                                    Text("${busdetailsModel!.data![0].jsonData}")
                                                    // Text(
                                                    //   "Payable: ${CUR_CURRENCY!} ${model.payable!}",
                                                    //   style: TextStyle(
                                                    //       fontSize: 14, color: Colors.white),
                                                    // ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ),
                                      ),
                                     SizedBox(height: 5),
                                    InkWell(
                                      onTap: () {
                                        if(isStart){
                                          startBus("0");
                                        }else{
                                          startBus("1");
                                        }
                                        latLongUpdate();
                                        // String url =
                                        //     "https://www.google.com/maps/dir/?api=1&origin=${latitude.toString()},"
                                        //     "${longitude.toString()}&destination=${widget.model!.latitude},${widget.model!.longitude}&travel_mode=driving&dir_action=navigate";
                                        // print(url);
                                        // launch(url);
                                      },
                                      child: Padding(
                                        padding: const EdgeInsets.symmetric(horizontal: 8),
                                        child: Container(
                                          height: 30,
                                          width: 100,
                                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(5), color: primary),
                                          child: Center(
                                            child:
                                            Text(isStart ?  "Start" : "Complete", style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600, color: white)
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                    ],
                                ),
                          ),
                        ),
                        // ListView.builder(
                        //         shrinkWrap: true,
                        //         itemCount: (offset! < total!)
                        //             ? orderList.length + 1
                        //             : orderList.length,
                        //         physics: const NeverScrollableScrollPhysics(),
                        //         itemBuilder: (context, index) {
                        //           //print("order List Herreeee ${orderList[index].total}");
                        //           return (index == orderList.length &&
                        //                   isLoadingmore)
                        //               ? const Center(
                        //                   child: SizedBox.shrink())
                        //               // CircularProgressIndicator())
                        //               :orderItem(index);
                        //         },
                        //       ),
                      ]),
                ),
              ):noInternet(context),
    );
  }

  void filterDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return ButtonBarTheme(
            data: const ButtonBarThemeData(
              alignment: MainAxisAlignment.center,
            ),
            child: AlertDialog(
                elevation: 2.0,
                shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
                contentPadding: const EdgeInsets.all(0.0),
                content: SingleChildScrollView(
                  child: Column(mainAxisSize: MainAxisSize.min, children: [
                    Padding(
                        padding:
                            EdgeInsetsDirectional.only(top: 19.0, bottom: 16.0),
                        child: Text(
                          'Filter By',
                          style: Theme.of(context)
                              .textTheme
                              .headline6!
                              .copyWith(color: fontColor),
                        ),
                    ),
                    Divider(color: lightBlack),
                    Flexible(
                      child: SingleChildScrollView(
                        child: Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: getStatusList()),
                      ),
                    ),
                  ]),
                )),
          );
        });
  }

  List<Widget> getStatusList() {
    return statusList
        .asMap()
        .map(
          (index, element) => MapEntry(
            index,
            Column(
              children: [
                Container(
                  width: double.maxFinite,
                  child: TextButton(
                      child: Text(capitalize(statusList[index]),
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(color: lightBlack)),
                      onPressed: () {
                        setState(() {
                          activeStatus = index == 0 ? null : statusList[index];
                          isLoadingmore = true;
                          offset = 0;
                          isLoadingItems = true;
                        });
                        getOrder();
                        Navigator.pop(context, 'option $index');
                      }),
                ),
                const Divider(
                  color: lightBlack,
                  height: 1,
                ),
              ],
            ),
          ),
        )
        .values
        .toList();
  }

  _scrollListener() {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      if (this.mounted) {
        setState(() {
          isLoadingmore = true;
          if (offset! < total!) getOrder();
        });
      }
    }
  }

  Drawer _getDrawer() {
    return Drawer(
      child: SafeArea(
        child: Container(
          color: white,
          child: ListView(
            padding: EdgeInsets.all(0),
            shrinkWrap: true,
            physics: BouncingScrollPhysics(),
            children: <Widget>[
              _getHeader(),
              Divider(),
              _getDrawerItem(0, HOME_LBL, Icons.home_outlined),
              // _getDrawerItem(7, CASH, Icons.account_balance_wallet_outlined),
              // _getDrawerItem(5, NOTIFICATION, Icons.notifications_outlined),
              _getDivider(),
              _getDrawerItem(8, PRIVACY, Icons.lock_outline),
              _getDrawerItem(9, TERM, Icons.speaker_notes_outlined),
              CUR_USERID == "" || CUR_USERID == null
                  ? Container()
                  : _getDivider(),
              CUR_USERID == "" || CUR_USERID == null
                  ? Container()
                  : _getDrawerItem(11, LOGOUT, Icons.input),
            ],
          ),
        ),
      ),
    );
  }

  Widget _getHeader() {
    return InkWell(
      child: Container(
        decoration: back(),
        padding: const EdgeInsets.only(left: 10.0, bottom: 10),
        child: Row(
          children: [
            Padding(
                padding: const EdgeInsets.only(top: 20, left: 10),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      CUR_USERNAME!,
                      style: Theme.of(context)
                          .textTheme
                          .subtitle1!
                          .copyWith(color: white, fontWeight: FontWeight.bold),
                    ),
                    // Text("$WALLET_BAL: ${CUR_CURRENCY!}$cash_received",
                    //     style: Theme.of(context)
                    //         .textTheme
                    //         .caption!
                    //         .copyWith(color: white)),
                    Padding(
                        padding: const EdgeInsets.only(
                          top: 7,
                        ),
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(EDIT_PROFILE_LBL,
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(color: white)),
                            const Icon(
                              Icons.arrow_right_outlined,
                              color: white,
                              size: 20,
                            ),
                          ],
                        ))
                  ],
                )),
            Spacer(),
            // Container(
            //   margin: const EdgeInsets.only(top: 20, right: 20),
            //   height: 64,
            //   width: 64,
            //   decoration: BoxDecoration(
            //       shape: BoxShape.circle,
            //       border: Border.all(width: 1.0, color: white)),
            //   child: ClipRRect(
            //     borderRadius: BorderRadius.circular(100.0),
            //     child: imagePlaceHolder(62),
            //   ),
            // ),
          ],
        ),
      ),
      onTap: () async {
        await Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => Profile(),
            ));
        setState(() {});
      },
    );
  }

  Widget _getDivider() {
    return const Padding(
      padding: EdgeInsets.all(8.0),
      child: Divider(
        height: 1,
      ),
    );
  }

  Widget _getDrawerItem(int index, String title, IconData icn) {
    return Container(
      margin: const EdgeInsets.only(right: 20),
      decoration: BoxDecoration(
          gradient: curDrwSel == index
              ? LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                      secondary.withOpacity(0.2),
                      primary.withOpacity(0.2)
                    ],
                  stops: [
                      0,
                      1
                    ])
              : null,
          // color: curDrwSel == index ? primary.withOpacity(0.2) : Colors.transparent,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(50),
            bottomRight: Radius.circular(50),
          )),
      child: ListTile(
        dense: true,
        leading: Icon(
          icn,
          color: curDrwSel == index ? primary : lightBlack2,
        ),
        title: Text(
          title,
          style: TextStyle(
              color: curDrwSel == index ? primary : lightBlack2, fontSize: 15),
        ),
        onTap: () {
          Navigator.of(context).pop();
          if (title == HOME_LBL) {
            setState(() {
              curDrwSel = index;
            });
            Navigator.pushNamedAndRemoveUntil(context, "/home", (r) => false);
          } else if (title == NOTIFICATION) {
            setState(() {
              curDrwSel = index;
            });
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => NotificationList(),
                ));
          } else if (title == LOGOUT) {
            logOutDailog();
          } else if (title == PRIVACY) {
            setState(() {
              curDrwSel = index;
            });
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PrivacyPolicy(
                    title: PRIVACY,
                  ),
                ));
          } else if (title == TERM) {
            setState(() {
              curDrwSel = index;
            });
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const PrivacyPolicy(
                    title: TERM,
                  ),
                ));
          } else if (title == CASH) {
            Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => WalletHistory(),
                ));
          }
        },
      ),
    );
  }

  @override
  void dispose() {
    buttonController!.dispose();
    super.dispose();
  }

  Future<Null> _refresh() {
    print("refresh is working here!");
    offset = 0;
    total = 0;
    orderList.clear();

    setState(() {
      _isLoading = true;
      isLoadingItems = false;
    });
    orderList.clear();
    return getOrder();
  }

  logOutDailog() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setStater) {
            return AlertDialog(
              shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
              content: Text(
                LOGOUTTXT,
                style: Theme.of(this.context)
                    .textTheme
                    .subtitle1!
                    .copyWith(color: fontColor),
              ),
              actions: <Widget>[
                TextButton(
                    child: Text(
                      LOGOUTNO,
                      style: Theme.of(this.context)
                          .textTheme
                          .subtitle2!
                          .copyWith(
                              color: lightBlack, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Navigator.of(context).pop(false);
                    }),
                TextButton(
                    child: Text(
                      LOGOUTYES,
                      style: Theme.of(this.context)
                          .textTheme
                          .subtitle2!
                          .copyWith(
                              color: fontColor, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      clearUserSession();
                      Navigator.of(context).pushAndRemoveUntil(
                          MaterialPageRoute(builder: (context) => Login()),
                          (Route<dynamic> route) => false);
                    })
              ],
            );
          });
        });
  }

  Future<Null> _playAnimation() async {
    try {
      await buttonController!.forward();
    } on TickerCanceled {}
  }

  Widget noInternet(BuildContext context) {
    return Center(
      child: SingleChildScrollView(
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
                  getOrder();
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

  Future<Null> getOrder() async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      if (offset == 0) {
        orderList = [];
      }
      try {
        CUR_USERID = await getPrefrence(ID);
        CUR_USERNAME = await getPrefrence(USERNAME);

        var parameter = {
          USER_ID: CUR_USERID,
          LIMIT: perPage.toString(),
          OFFSET: offset.toString()
        };
        print("Get Order ${parameter.toString()}");
        if (activeStatus != null) {
          if (activeStatus == awaitingPayment) activeStatus = "awaiting";
          parameter[ACTIVE_STATUS] = activeStatus;
          print("statussss ${activeStatus}");
        }
        Response response =
            await post(getOrdersApi, body: parameter, headers: headers)
                .timeout(Duration(seconds: timeOut));
        var getdata = json.decode(response.body);
        print("response   ${response.body}");
        bool error = getdata["error"];
        String? msg = getdata["message"];
        total = int.parse(getdata["total"]);

        if (!error) {
          if (offset! < total!) {
            tempList.clear();
            var data = getdata["data"];
            tempList = (data as List)
                .map((data) => Order_Model.fromJson(data))
                .toList();
            orderList.addAll(tempList);
            offset = offset! + perPage;
            print("Order Listtt ${orderList.length}");
            print("templist length ${tempList.length}");
          }
        }
        if (mounted)
          setState(() {
            _isLoading = false;
            isLoadingItems = false;
          });
      } on TimeoutException catch (_) {
        setSnackbar(somethingMSg);
        setState(() {
          _isLoading = false;
          isLoadingItems = false;
        });
      }
    } else {
      if (mounted)
        setState(() {
          _isNetworkAvail = false;
          _isLoading = false;
          isLoadingItems = false;
        });
    }
    return null;
  }

  Future<Null> getUserDetail() async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      try {
        CUR_USERID = await getPrefrence(ID);

        var parameter = {ID: CUR_USERID};
        Response response =
            await post(getBoyDetailApi, body: parameter, headers: headers)
                .timeout(Duration(seconds: timeOut));
        print("Delivery boy details ${parameter.toString()}");
        var getdata = json.decode(response.body);
        bool error = getdata["error"];
        String? msg = getdata["message"];
        if (!error) {
          var data = getdata["data"][0];
          cash_received = double.parse(getdata['data'][0]['cash_received']);
          print("cash received ${cash_received}");
          CUR_BALANCE = double.parse(data[BALANCE]).toStringAsFixed(2);
          CUR_BONUS = data[BONUS];
        }
        setState(() {
          _isLoading = false;
        });
      } on TimeoutException catch (_) {
        setSnackbar(somethingMSg);
        setState(() {
          _isLoading = false;
        });
      }
    } else {
      if (mounted)
        setState(() {
          _isNetworkAvail = false;
          _isLoading = false;
        });
    }
    return null;
  }

  setSnackbar(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      content: Text(
        msg,
        textAlign: TextAlign.center,
        style: TextStyle(color: black),
      ),
      backgroundColor: white,
      elevation: 1.0,
    ));
  }

  Widget orderItem(int index) {
    Order_Model model = orderList[index];
    print('${model.itemList?.length}_________');
    Color back;

    if (model.itemList!.isNotEmpty && (model.itemList![0].status!) == DELIVERD)
      back = Colors.green;
    else if (model.itemList!.isNotEmpty &&
        (model.itemList![0].status!) == SHIPED)
      back = Colors.orange;
    else if (model.itemList!.isNotEmpty &&
            (model.itemList![0].status!) == CANCLED ||
        (model.itemList!.isNotEmpty && model.itemList![0].status! == RETURNED))
      back = Colors.red;
    else if (model.itemList!.isNotEmpty &&
        (model.itemList![0].status!) == PROCESSED)
      back = Colors.indigo;
    else if (model.itemList!.isNotEmpty &&
        model.itemList![0].status! == WAITING)
      back = Colors.black;
    else
      back = Colors.cyan;

    return model.itemList!.isEmpty ||
            model.itemList![0].status! == DELIVERD ||
            (model.itemList!.isNotEmpty &&
                model.itemList![0].status == CANCLED) ||
            (model.itemList!.isEmpty && model.itemList![0].status == RETURNED)
        ? SizedBox.shrink()
        :
    Card(
            elevation: 5,
            margin: const EdgeInsets.all(5.0),
            child: InkWell(
              borderRadius: BorderRadius.circular(10),
              child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Container(
                          child: Image.asset("assets/images/homelogo.png", fit: BoxFit.fill,),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 8.0),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: <Widget>[
                              Text("Bus No.${model.id!}"),
                              const Spacer(),
                              Container(
                                margin: const EdgeInsets.only(left: 8),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 2),
                                decoration: BoxDecoration(
                                    color: back,
                                    borderRadius: const BorderRadius.all(
                                        Radius.circular(4.0))),
                                child: Text(
                                  model.itemList![0].status!,
                                  style: const TextStyle(color: white),
                                ),
                              ),
                            ],
                          ),
                        ),
                        Divider(),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 5),
                          child: Row(
                            children: [
                              Flexible(
                                child: Row(
                                  children: [
                                    const Icon(Icons.person, size: 14),
                                    Expanded(
                                      child: Text(
                                        model.name != null &&
                                                model.name!.isNotEmpty
                                            ? " ${capitalize(model.name!)}"
                                            : " ",
                                        maxLines: 1,
                                        overflow: TextOverflow.ellipsis,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              InkWell(
                                child: Row(
                                  children: [
                                    const Icon(
                                      Icons.call,
                                      size: 14,
                                      color: fontColor,
                                    ),
                                    Text(
                                      " ${model.mobile!}",
                                      style: const TextStyle(
                                          color: fontColor,
                                          decoration: TextDecoration.underline),
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  _launchCaller(index);
                                },
                              ),
                              // TextButton(onPressed: () { _launchCaller(index);}, child: Row(
                              //   children: [
                              //     const Icon(
                              //       Icons.call,
                              //       size: 14,
                              //       color: fontColor,
                              //     ),
                              //     Text(
                              //       " ${model.mobile!}",
                              //       style: const TextStyle(
                              //           color: fontColor,
                              //           decoration: TextDecoration.underline),
                              //     ),
                              //   ],
                              // ),
                              // ),
                            ],
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 5),
                          child: Container(
                            child: Row(
                              children: [
                                Container(
                                  height: 38,
                                  width: 135,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: primary),
                                  child: Row(
                                    children: [
                                      Padding(
                                        padding: const EdgeInsets.only(left: 5),
                                        child: Icon(Icons.money,
                                            size: 14, color: Colors.white),
                                      ),
                                      Text(
                                        "Payable: ${CUR_CURRENCY!} ${model.payable!}",
                                        style: TextStyle(
                                            fontSize: 14, color: Colors.white),
                                      ),
                                    ],
                                  ),
                                ),
                                Spacer(),
                                Container(
                                  height: 35,
                                  width: 115,
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(10),
                                      color: primary),
                                  child: Padding(
                                    padding: const EdgeInsets.only(left: 15),
                                    child: Row(
                                      children: [
                                        const Icon(
                                          Icons.payment,
                                          size: 16,
                                          color: white,
                                        ),
                                        Text(
                                          " ${model.payMethod!}",
                                          style: TextStyle(
                                              color: white,
                                              fontSize: 16,
                                              fontWeight: FontWeight.w800),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 8.0, vertical: 5),
                          child: Row(
                            children: [
                              const Icon(Icons.date_range, size: 14),
                              Text(" Order on:   ${model.orderDate!}"),
                            ],
                          ),
                        )
                      ])),
              onTap: () async {
                // await Navigator.push(
                //   context,
                //   MaterialPageRoute(
                //       builder: (context) =>
                //           OrderDetail(model: orderList[index])),
                // );
                setState(() {
                  /* _isLoading = true;
             total=0;
             offset=0;
orderList.clear();*/
                  getUserDetail();
                });
                // getOrder();
              },
            ),
          );
  }

  _launchCaller(index) async {
    var url = "tel:${orderList[index].mobile}";
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  _detailHeader() {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: Card(
              elevation: 0,
              child: Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    const Icon(
                      Icons.shopping_cart,
                      color: fontColor,
                    ),
                    Text(ORDER),
                    Text(
                      total.toString(),
                      style: const TextStyle(
                          color: fontColor, fontWeight: FontWeight.bold),
                    )
                  ],
                ),
              )),
        ),
        // Expanded(
        //   flex: 3,
        //   child: Card(
        //     elevation: 0,
        //     child: Padding(
        //       padding: const EdgeInsets.all(18.0),
        //       child: Column(
        //         children: [
        //           const Icon(
        //             Icons.account_balance_wallet,
        //             color: fontColor,
        //           ),
        //           Text(BAL_LBL),
        //           Text(
        //             "${CUR_CURRENCY!} $CUR_BALANCE",
        //             style: const TextStyle(
        //                 color: fontColor, fontWeight: FontWeight.bold),
        //           )
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
        // Expanded(
        //   flex: 2,
        //   child: Card(
        //     elevation: 0,
        //     child: Padding(
        //       padding: const EdgeInsets.all(18.0),
        //       child: Column(
        //         children: [
        //           const Icon(
        //             Icons.wallet_giftcard,
        //             color: fontColor,
        //           ),
        //           const Text(BONUS_LBL),
        //           Text(
        //             CUR_BONUS!,
        //             style: const TextStyle(
        //                 color: fontColor, fontWeight: FontWeight.bold),
        //           )
        //         ],
        //       ),
        //     ),
        //   ),
        // ),
      ],
    );
  }

  Future<void> getSetting() async {
    try {
      CUR_USERID = await getPrefrence(ID);

      var parameter = {TYPE: CURRENCY};

      Response response =
          await post(getSettingApi, body: parameter, headers: headers)
              .timeout(Duration(seconds: timeOut));
      if (response.statusCode == 200) {
        var getdata = json.decode(response.body);
        bool error = getdata["error"];
        String? msg = getdata["message"];
        if (!error) {
          CUR_CURRENCY = getdata["currency"];
        } else {
          setSnackbar(msg!);
        }
      }
    } on TimeoutException catch (_) {
      setSnackbar(somethingMSg);
    }
  }
}
