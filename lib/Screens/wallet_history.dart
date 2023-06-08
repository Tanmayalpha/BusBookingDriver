import 'dart:async';
import 'dart:convert';
import 'package:deliveryboy_multivendor/Helper/Session.dart';
import 'package:deliveryboy_multivendor/Helper/app_btn.dart';
import 'package:deliveryboy_multivendor/Helper/color.dart';
import 'package:deliveryboy_multivendor/Helper/constant.dart';
import 'package:deliveryboy_multivendor/Helper/sim_btn.dart';
import 'package:deliveryboy_multivendor/Helper/string.dart';
import 'package:deliveryboy_multivendor/Model/CashPaymentModel.dart';
import 'package:deliveryboy_multivendor/Model/order_model.dart';
import 'package:deliveryboy_multivendor/Model/transaction_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:http/http.dart';

import '../Model/OrderPaymentModel.dart';
import 'home.dart';
import 'order_detail.dart';


class WalletHistory extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return StateWallet();
  }
}

List<TransactionModel> tranList = [];
List<CashPaymentModel> cashList = [];
int offset = 0;
int total = 0;
bool isLoadingmore = true;
bool _isLoading = true;

class StateWallet extends State<WalletHistory> with TickerProviderStateMixin {
  bool _isNetworkAvail = true;
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey<ScaffoldState>();
  Animation? buttonSqueezeanimation;
  AnimationController? buttonController;
  final GlobalKey<RefreshIndicatorState> _refreshIndicatorKey =
      GlobalKey<RefreshIndicatorState>();
  ScrollController controller = ScrollController();
  List<Order_Model> tempList = [];
  List<PaymentModeDataList> paymentList = [];
  TextEditingController? amtC, bankDetailC;

  @override
  void initState() {
    super.initState();
    getOrder();
    // getTransaction();
    getCashCollection();
    controller.addListener(_scrollListener);
    buttonController = AnimationController(duration: Duration(milliseconds: 2000), vsync: this);
    buttonSqueezeanimation = Tween(begin: deviceWidth! * 0.7, end: 50.0,
    ).animate(CurvedAnimation(
      parent: buttonController!,
      curve: Interval(
        0.0,
        0.150,
      ),
    ));
    amtC = TextEditingController();
    bankDetailC = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: lightWhite,
        key: _scaffoldKey,
        appBar: getAppBar(CASH, context),
        body: _isNetworkAvail
            ? _isLoading
                ? shimmer()
                : RefreshIndicator(
                    key: _refreshIndicatorKey,
                    onRefresh: _refresh,
                    child: SingleChildScrollView(
                      controller: controller,
                      child: Column(
                          children: [
                        Padding(
                          padding: const EdgeInsets.only(top: 5.0),
                          child: Card(
                            elevation: 0,
                            child: Padding(
                              padding: const EdgeInsets.all(18.0),
                              child: Column(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Icon(
                                        Icons.account_balance_wallet,
                                        color: fontColor,
                                      ),
                                      Text(
                                        " " + CASH,
                                        style: Theme.of(context)
                                            .textTheme
                                            .subtitle2!
                                            .copyWith(
                                                color: fontColor,
                                                fontWeight: FontWeight.bold),
                                      ),
                                    ],
                                  ),
                                 Padding(
                                   padding: EdgeInsets.only(left: 130),
                                   child: Row(
                                     children: [
                                       Text(CUR_CURRENCY!,
                                           style: Theme.of(context)
                                               .textTheme
                                               .headline6!
                                               .copyWith(
                                               color: fontColor,
                                               fontWeight: FontWeight.bold)
                                       ),
                                       SizedBox(width: 5),
                                       // cashList == null || cashList == "" ? Center(child: Text("No Data")):
                                       Text("${cash_received}",
                                           style: Theme.of(context)
                                               .textTheme
                                               .headline6!
                                               .copyWith(
                                               color: fontColor,
                                               fontWeight: FontWeight.bold),
                                       ),
                                     ],
                                   ),
                                 ),
                                  // Text(CUR_CURRENCY! + " " + CUR_BALANCE,
                                  //     style: Theme.of(context)
                                  //         .textTheme
                                  //         .headline6!
                                  //         .copyWith(
                                  //         color: fontColor,
                                  //         fontWeight: FontWeight.bold)
                                  // ),
                                  // SimBtn(
                                  //   size: 0.8,
                                  //   title: WITHDRAW_MONEY,
                                  //   onBtnSelected: () {
                                  //     _showDialog();
                                  //   },
                                  // ),
                                ],
                              ),
                            ),
                          ),
                        ),
                            paymentList.isEmpty
                                ? isLoadingItems
                                ? const Center(
                                child: CircularProgressIndicator())
                                : const Center(child: Text(noItem))
                                : ListView.builder(
                              shrinkWrap: true,
                              itemCount: paymentList.length,
                              physics:
                              const NeverScrollableScrollPhysics(),
                              itemBuilder: (context, index) {
                                return (index == paymentList.length &&
                                    isLoadingmore)
                                    ? const Center(
                                    child: SizedBox.shrink())
                                // CircularProgressIndicator())
                                    :
                                orderItem(index);
                              },
                            )
                            // cashList.length == 0
                            // ? Center(child: Text(noItem))
                            // : ListView.builder(
                            //     shrinkWrap: true,
                            //     itemCount: cashList.length,
                            //     physics: NeverScrollableScrollPhysics(),
                            //     itemBuilder: (context, index) {
                            //       return (index == cashList.length &&
                            //               isLoadingmore)
                            //           ? Center(
                            //               child: CircularProgressIndicator())
                            //           : listItem(index);
                            //     },
                            //   ),
                      ]),
                    ))
            : noInternet(context));
  }

  Widget orderItem(int index) {
    var model = paymentList[index];
    Color back;

    // if ((model.itemList![0].status!) == DELIVERD)
    //   back = Colors.green;
    // else if ((model.itemList![0].status!) == SHIPED)
    //   back = Colors.orange;
    // else if ((model.itemList![0].status!) == CANCLED ||
    //     model.itemList![0].status! == RETURNED)
    //   back = Colors.red;
    // else if ((model.itemList![0].status!) == PROCESSED)
    //   back = Colors.indigo;
    // else if (model.itemList![0].status! == WAITING)
    //   back = Colors.black;
    // else
    //   back = Colors.cyan;

    return
      model.orderItems![0].activeStatus!= DELIVERD ?
      SizedBox.shrink()
          :
      Card(
        elevation: 0,
        margin: const EdgeInsets.all(5.0),
        child: InkWell(
          borderRadius: BorderRadius.circular(4),
          child: Padding(
              padding: const EdgeInsets.all(8.0),
              child:
              Column(crossAxisAlignment: CrossAxisAlignment.start, children: <Widget>[
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8.0),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text("Order No.${model.id!}"),
                      const Spacer(),
                      Container(
                        margin: const EdgeInsets.only(left: 8),
                        padding:
                        const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                        decoration: BoxDecoration(
                            // color: back,
                            borderRadius:
                            const BorderRadius.all(Radius.circular(4.0))),
                        child: Text(
                          capitalize(model.orderItems![0].activeStatus!),
                          style: const TextStyle(color: white),
                        ),
                      )
                    ],
                  ),
                ),
                Divider(),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                  child: Row(
                    children: [
                      Flexible(
                        child: Row(
                          children: [
                            const Icon(Icons.person, size: 14),
                            Expanded(
                              child: Text(
                                model.name != null && model.name!.isNotEmpty
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
                          // _launchCaller(index);
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
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                  child: Container(
                    child: Row(
                      children: [
                        Container(
                          height: 38,
                          width: 135,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: primary),
                          child: Row(
                            children: [
                              Padding(
                                padding: const EdgeInsets.only(left: 5),
                                child: Icon(Icons.money, size: 14, color: Colors.white),
                              ),
                              Text("Payable: ${CUR_CURRENCY!} ${model.totalPayable!}", style: TextStyle(fontSize: 14, color: Colors.white),),
                            ],
                          ),
                        ),
                        Spacer(),
                        Container(
                          height: 35,
                          width: 115,
                          decoration: BoxDecoration(borderRadius: BorderRadius.circular(10), color: primary),
                          child: Padding(
                            padding: const EdgeInsets.only(left: 15),
                            child: Row(
                              children: [
                                const Icon(Icons.payment, size: 16, color: white,),
                                Text("${model.paymentMethod!}", style: TextStyle(color: white, fontSize: 16, fontWeight: FontWeight.w800),),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding:
                  const EdgeInsets.symmetric(horizontal: 8.0, vertical: 5),
                  child: Row(
                    children: [
                      const Icon(Icons.date_range, size: 14),
                      Text(" Order on: ${model.dateAdded.toString().substring(0,10) ?? ''}"),
                    ],
                  ),
                )
              ])),
          onTap: () async {
            await Navigator.push(
              context,
              MaterialPageRoute(
                  builder: (context) => OrderDetail(model: orderList[index])),
            );
            setState(() {
              /* _isLoading = true;
             total=0;
             offset=0;
orderList.clear();*/
              // getUserDetail();
            });
            // getOrder();
          },
        ),
      );
  }
  Future<Null> sendRequest() async {
    _isNetworkAvail = await isNetworkAvailable();
    if (_isNetworkAvail) {
      try {
        var parameter = {
          USER_ID: CUR_USERID,
          AMOUNT: amtC!.text.toString(),
          PAYMENT_ADD: bankDetailC!.text.toString()
        };
        Response response =
            await post(sendWithReqApi, body: parameter, headers: headers)
                .timeout(Duration(seconds: timeOut));

        var getdata = json.decode(response.body);
        bool error = getdata["error"];
        String msg = getdata["message"];

        if (!error) {
          CUR_BALANCE = double.parse(getdata["data"]).toStringAsFixed(2);
        }
        if (mounted) setState(() {});
        setSnackbar(msg);
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
      // actions: [
      //   Container(
      //       margin: EdgeInsets.symmetric(vertical: 10, horizontal: 10),
      //       child: InkWell(
      //         borderRadius: BorderRadius.circular(4),
      //         onTap: () {
      //           return filterDialog();
      //         },
      //         child: Padding(
      //           padding: const EdgeInsets.all(4.0),
      //           child: Icon(
      //             Icons.filter_alt_outlined,
      //             color: primary,
      //           ),
      //         ),
      //       ))
      // ],
    );
  }

  void filterDialog() {
    showDialog(
        context: context,
        builder: (BuildContext context) {
          return ButtonBarTheme(
            data: ButtonBarThemeData(
              alignment: MainAxisAlignment.center,
            ),
            child: AlertDialog(
                elevation: 2.0,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.all(Radius.circular(5.0))),
                contentPadding: const EdgeInsets.all(0.0),
                content: Column(mainAxisSize: MainAxisSize.min, children: [
                  Padding(
                      padding: EdgeInsets.only(top: 19.0, bottom: 16.0),
                      child: Text(
                        FILTER_BY,
                        style: Theme.of(context).textTheme.headline6,
                      )),
                  Divider(color: lightBlack),
                  TextButton(
                      child: Text(SHOW_TRANS,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(color: lightBlack)),
                      onPressed: () {
                        tranList.clear();
                        offset = 0;
                        total = 0;
                        setState(() {
                          _isLoading = true;
                        });
                        // getTransaction();
                        Navigator.pop(context, 'option 1');
                      }),
                  Divider(color: lightBlack),
                  TextButton(
                      child: Text(SHOW_REQ,
                          style: Theme.of(context)
                              .textTheme
                              .subtitle1!
                              .copyWith(color: lightBlack)),
                      onPressed: () {
                        tranList.clear();
                        offset = 0;
                        total = 0;
                        setState(() {
                          _isLoading = true;
                        });
                        // getRequest();
                        Navigator.pop(context, 'option 1');
                      }),
                  Divider(
                    color: white,
                  )
                ])),
          );
        });
  }

  _showDialog() async {
    await showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(
              builder: (BuildContext context, StateSetter setStater) {
            return AlertDialog(
              contentPadding: const EdgeInsets.all(0.0),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.all(Radius.circular(5.0))),
              content: SingleChildScrollView(
                  scrollDirection: Axis.vertical,
                  child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Padding(
                            padding: EdgeInsets.fromLTRB(20.0, 20.0, 0, 2.0),
                            child: Text(
                              SEND_REQUEST,
                              style: Theme.of(this.context)
                                  .textTheme
                                  .subtitle1!
                                  .copyWith(color: fontColor),
                            )),
                        Divider(color: lightBlack),
                        Form(
                            key: _formkey,
                            child: Column(
                              children: <Widget>[
                                Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                                    child: TextFormField(
                                      keyboardType: TextInputType.number,
                                      validator: validateField,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      decoration: InputDecoration(
                                        hintText: WITHDRWAL_AMT,
                                        hintStyle: Theme.of(this.context)
                                            .textTheme
                                            .subtitle1!
                                            .copyWith(
                                                color: lightBlack,
                                                fontWeight: FontWeight.normal),
                                      ),
                                      controller: amtC,
                                    )),
                                Padding(
                                    padding:
                                        EdgeInsets.fromLTRB(20.0, 0, 20.0, 0),
                                    child: TextFormField(
                                      validator: validateField,
                                      keyboardType: TextInputType.multiline,
                                      maxLines: null,
                                      autovalidateMode:
                                          AutovalidateMode.onUserInteraction,
                                      decoration: InputDecoration(
                                        hintText: BANK_DETAIL,
                                        hintStyle: Theme.of(this.context)
                                            .textTheme
                                            .subtitle1!
                                            .copyWith(
                                                color: lightBlack,
                                                fontWeight: FontWeight.normal),
                                      ),
                                      controller: bankDetailC,
                                    )),
                              ],
                            ))
                      ])),
              actions: <Widget>[
                ElevatedButton(
                    child: Text(
                      CANCEL,
                      style: Theme.of(this.context)
                          .textTheme
                          .subtitle2!
                          .copyWith(
                              color: lightBlack, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    }),
                ElevatedButton(
                    child: Text(
                      SEND_LBL,
                      style: Theme.of(this.context)
                          .textTheme
                          .subtitle2!
                          .copyWith(
                              color: fontColor, fontWeight: FontWeight.bold),
                    ),
                    onPressed: () {
                      final form = _formkey.currentState!;
                      if (form.validate()) {
                        form.save();
                        setState(() {
                          Navigator.pop(context);
                        });
                        sendRequest();
                      }
                    })
              ],
            );
          });
        });
  }

  listItem(int index) {
    // Color back;
    // if (tranList[index].status == "success" ||
    //     tranList[index].status == ACCEPTED) {
    //   back = Colors.green;
    // } else if (tranList[index].status == PENDING)
    //   back = Colors.orange;
    // else
    //   back = Colors.red;
    return Card(
      elevation: 4,
      margin: EdgeInsets.all(5.0),
      child: InkWell(
          borderRadius: BorderRadius.circular(4),
          child: Padding(
              padding: EdgeInsets.all(8.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(
                          AMT_LBL +
                              " : " +
                              CUR_CURRENCY! +
                              " " +
                              tranList[index].amt!,
                          style: TextStyle(
                              color: fontColor, fontWeight: FontWeight.bold),
                        ),
                        Spacer(),
                        Text(tranList[index].date!),
                      ],
                    ),
                    Divider(),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: <Widget>[
                        Text(ID_LBL + " : " + tranList[index].id!),
                        Spacer(),
                        Container(
                          margin: EdgeInsets.only(left: 8),
                          padding:
                              EdgeInsets.symmetric(horizontal: 10, vertical: 2),
                          decoration: BoxDecoration(
                              // color: back,
                              borderRadius:
                                  BorderRadius.all(const Radius.circular(4.0))),
                          child: Text(
                            capitalize(tranList[index].status!),
                            style: TextStyle(color: white),
                          ),
                        )
                      ],
                    ),
                  ]))),
    );
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
                  // getTransaction();
                  getCashCollection();
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


   // cashcollection() async{
   //   var headers = {
   //     'Cookie': 'ci_session=c40d29a8848c5df3e406733615c5bd52b068641f'
   //   };
   //   var request = http.MultipartRequest('POST', Uri.parse('https://developmentalphawizz.com/everyday_online/delivery_boy/app/v1/api/get_delivery_boy_cash_collection'));
   //   request.fields.addAll({
   //     DEL_BOY_ID: CUR_USERID,
   //   });
   //
   //   request.headers.addAll(headers);
   //   http.StreamedResponse response = await request.send();
   //
   //   if (response.statusCode == 200) {
   //     print(await response.stream.bytesToString());
   //   }
   //   else {
   //     print(response.reasonPhrase);
   //   }
   // }


  Future<Null> getCashCollection() async{
    _isNetworkAvail = await isNetworkAvailable();
    if(_isNetworkAvail) {
      try{
        var parameter = {
          DEL_BOY_ID: CUR_USERID,
        };
        print("Cash Param ${parameter.toString()}");
        Response response =
        await post(getDeliveryBoyCashCollection, headers: headers, body: parameter)
            .timeout(Duration(seconds: timeOut));
        if (response.statusCode == 200) {
          var getdata = json.decode(response.body);
          bool error = getdata["error"];
          String? msg = getdata["message"];
          // final jsonresponse = CashPaymentModel.fromJson(jsonDecode(response));
          // setState(() {
          //   CashPaymentModel = jsonresponse;
          // });
          if (!error) {
            total = int.parse(getdata["total"]);
            // if () {
            //   cashList.clear();
            //   var data = getdata["data"];
            //   cashList = (data as List).map((data) => CashPaymentModel.fromJson(data)).toList();
            //   cashList.addAll(cashList);
            // }
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
          isLoadingmore = false;
        });
      }
    } else
      setState(() {
        _isNetworkAvail = false;
      });
    return null;
  }


  getOrder() async {
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
          // LIMIT: perPage.toString(),
          // OFFSET: offset.toString(),
          // ACTIVE_STATUS : status,
          "payment_method": 'Cod',
        };
        Response response =
        await post(getOrdersApi, body: parameter, headers: headers)
            .timeout(Duration(seconds: timeOut));
        print(" ${parameter.toString()}");
        print("response  ${response.body}");
        var getdata = json.decode(response.body);
       // var orderPayment = OrderPaymentModel.fromJson(jsonDecode(getdata)).data;
       // print("Order Paymnent ${orderPayment}");
       // paymentList = orderPayment ?? [];
        bool error = getdata["error"];
        String? msg = getdata["message"];

        total = int.parse(getdata["total"]);
        print("total ${total}");
        print("message ${msg}");
        print("error ${error}");
        // print("error ${}");

        if (!error) {
          var data2 = getdata["data"];
          paymentList = (data2 as List).map((data) => PaymentModeDataList.fromJson(data))
              .toList();
          if (offset < total) {
            tempList.clear();
            var data = getdata["data"];
            tempList = (data as List)
                .map((data) => Order_Model.fromJson(data))
                .toList();
            orderList.addAll(tempList);
            offset = offset + perPage;
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


  // Future<Null> getTransaction() async {
  //   _isNetworkAvail = await isNetworkAvailable();
  //   if (_isNetworkAvail) {
  //     try {
  //       var parameter = {
  //         LIMIT: perPage.toString(),
  //         OFFSET: offset.toString(),
  //         USER_ID: CUR_USERID,
  //       };
  //       print("Transactionnnn ${parameter.toString()}");
  //       Response response =
  //           await post(getFundTransferApi, headers: headers, body: parameter)
  //               .timeout(Duration(seconds: timeOut));
  //       if (response.statusCode == 200) {
  //         var getdata = json.decode(response.body);
  //         bool error = getdata["error"];
  //         String? msg = getdata["message"];
  //
  //         if (!error) {
  //           total = int.parse(getdata["total"]);
  //
  //           if ((offset) < total) {
  //             tempList.clear();
  //             var data = getdata["data"];
  //             tempList = (data as List)
  //                 .map((data) => TransactionModel.fromJson(data))
  //                 .toList();
  //
  //             tranList.addAll(tempList);
  //
  //             offset = offset + perPage;
  //           }
  //         } else {
  //           isLoadingmore = false;
  //         }
  //       }
  //       if (mounted)
  //         setState(() {
  //           _isLoading = false;
  //         });
  //     } on TimeoutException catch (_) {
  //       setSnackbar(somethingMSg);
  //       setState(() {
  //         _isLoading = false;
  //         isLoadingmore = false;
  //       });
  //     }
  //   } else
  //     setState(() {
  //       _isNetworkAvail = false;
  //     });
  //   return null;
  // }

  // Future<Null> getRequest() async {
  //   _isNetworkAvail = await isNetworkAvailable();
  //   if (_isNetworkAvail) {
  //     try {
  //       var parameter = {
  //         LIMIT: perPage.toString(),
  //         OFFSET: offset.toString(),
  //         USER_ID: CUR_USERID,
  //       };
  //
  //       Response response =
  //           await post(getWithReqApi, headers: headers, body: parameter)
  //               .timeout(Duration(seconds: timeOut));
  //
  //       if (response.statusCode == 200) {
  //         var getdata = json.decode(response.body);
  //         bool error = getdata["error"];
  //         String? msg = getdata["message"];
  //
  //         if (!error) {
  //           total = int.parse(getdata["total"]);
  //           if ((offset) < total) {
  //             tempList.clear();
  //             var data = getdata["data"];
  //             tempList = (data as List)
  //                 .map((data) => TransactionModel.fromReqJson(data))
  //                 .toList();
  //
  //             tranList.addAll(tempList);
  //
  //             offset = offset + perPage;
  //           }
  //         } else {
  //           isLoadingmore = false;
  //         }
  //       }
  //       if (mounted)
  //         setState(() {
  //           _isLoading = false;
  //         });
  //     } on TimeoutException catch (_) {
  //       setSnackbar(somethingMSg);
  //       setState(() {
  //         _isLoading = false;
  //         isLoadingmore = false;
  //       });
  //     }
  //   } else
  //     setState(() {
  //       _isNetworkAvail = false;
  //     });
  //
  //   return null;
  // }

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

  @override
  void dispose() {
    buttonController!.dispose();
    super.dispose();
  }

  Future<Null> _refresh() {
    setState(() {
      _isLoading = true;
    });
    offset = 0;
    total = 0;
    tranList.clear();
    return getOrder();
  }

  _scrollListener() {
    if (controller.offset >= controller.position.maxScrollExtent &&
        !controller.position.outOfRange) {
      if (this.mounted) {
        // setState(() {
        //   isLoadingmore = true;
        //   if (offset < total) getTransaction();
        // });
      }
    }
  }
}
