import 'dart:async';
import 'dart:convert';

import 'package:deliveryboy_multivendor/Helper/Session.dart';
import 'package:deliveryboy_multivendor/Helper/app_btn.dart';
import 'package:deliveryboy_multivendor/Helper/color.dart';
import 'package:deliveryboy_multivendor/Helper/constant.dart';
import 'package:deliveryboy_multivendor/Helper/string.dart';
import 'package:deliveryboy_multivendor/Model/notification_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart';

class NotificationList extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => StateNoti();
}

List<Notification_Model> notiList = [];
int offset = 0;
int total = 0;
bool isLoadingmore = true;
bool _isLoading = true;

class StateNoti extends State<NotificationList> with TickerProviderStateMixin {
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  ScrollController controller = new ScrollController();
  List<Notification_Model> tempList = [];
  Animation? buttonSqueezeanimation;
  AnimationController? buttonController;
  bool _isNetworkAvail = true;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      new GlobalKey<RefreshIndicatorState>();

  @override
  void initState() {
    getNotification();
    controller.addListener(_scrollListener);
    buttonController = new AnimationController(
        duration: new Duration(milliseconds: 2000), vsync: this);

    buttonSqueezeanimation = new Tween(
      begin: deviceWidth! * 0.7,
      end: 50.0,
    ).animate(new CurvedAnimation(
      parent: buttonController!,
      curve: new Interval(
        0.0,
        0.150,
      ),
    ));
    super.initState();
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
                  getNotification();
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

  Future<Null> _refresh() {
    setState(() {
      _isLoading = true;
    });
    offset = 0;
    total = 0;
    notiList.clear();
    return getNotification();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: lightWhite,
        key: _scaffoldKey,
        appBar: getAppBar(NOTIFICATION, context),
        body: _isNetworkAvail
            ? _isLoading
                ? shimmer()
                : notiList.length == 0
                    ? Padding(
                        padding: const EdgeInsets.only(top: kToolbarHeight),
                        child: Center(child: Text(noNoti)))
                    : RefreshIndicator(
                        key: _refreshIndicatorKey,
                        onRefresh: _refresh,
                        child: ListView.builder(
                          controller: controller,
                          itemCount: (offset < total)
                              ? notiList.length + 1
                              : notiList.length,
                          physics: AlwaysScrollableScrollPhysics(),
                          itemBuilder: (context, index) {
                            return (index == notiList.length && isLoadingmore)
                                ? Center(child: CircularProgressIndicator())
                                : listItem(index);
                          },
                        ))
            : noInternet(context));
  }

  Widget listItem(int index) {
    Notification_Model model = notiList[index];
    return Card(
      elevation: 0,
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Row(
          children: <Widget>[
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                    model.date!,
                    style: TextStyle(color: primary),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      model.title!,
                      style: TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ),
                  Text(model.desc!)
                ],
              ),
            ),
            model.img != null && model.img != ''
                ? Container(
                    width: 50,
                    height: 50,
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(3.0),
                        child: CircleAvatar(
                          backgroundImage: NetworkImage(model.img!),
                          radius: 25,
                        )),
                  )
                : Container(
                    height: 0,
                  ),
          ],
        ),
      ),
    );
  }

  Future<Null> getNotification() async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      try {
        var parameter = {
          LIMIT: perPage.toString(),
          OFFSET: offset.toString(),
        };

        Response response =
            await post(getNotificationApi, headers: headers, body: parameter)
                .timeout(Duration(seconds: timeOut));
        if (response.statusCode == 200) {
          var getdata = json.decode(response.body);
          bool error = getdata["error"];
          String? msg = getdata["message"];

          if (!error) {
            total = int.parse(getdata["total"]);

            if ((offset) < total) {
              tempList.clear();
              var data = getdata["data"];
              tempList = (data as List)
                  .map((data) => new Notification_Model.fromJson(data))
                  .toList();

              notiList.addAll(tempList);

              offset = offset + perPage;
            }
          } else {
            isLoadingmore = false;
          }
        }
        if (mounted)
          setState(() {
            _isLoading = false;
          });
      } on TimeoutException catch (_) {
        setSnackbar(somethingMSg);
        setState(() {
          _isLoading = false;
        });
      }
    } else
      setState(() {
        _isNetworkAvail = false;
      });

    return null;
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

  _scrollListener() {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      if (this.mounted) {
        setState(() {
          isLoadingmore = true;

          if (offset < total) getNotification();
        });
      }
    }
  }
}
