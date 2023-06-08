/// error : false
/// message : "Data retrieved successfully"
/// total : "1"
/// data : [{"id":"13","user_id":"250","address_id":"155","mobile":"7879864312","total":"226","delivery_charge":"10","is_delivery_charge_returnable":"1","wallet_balance":"0","promo_code":" ","promo_discount":"0","discount":"0","total_payable":"236","final_total":"236","payment_method":"COD","latitude":"22.7469442","longitude":"75.8980412","address":"151,Ratna Lok Colony,Indore, pardesipura, Indore, Madhya Pradesh, India, 101010","delivery_time":null,"delivery_date":null,"date_added":"2023-04-12 12:51:54","otp":"288711","notes":"","order_type":null,"new_order":"0","username":"Shivani","country_code":"91","name":"Everyday Milk Powder 400g","attachments":[],"courier_agency":"","tracking_id":"","url":"","order_otp":"288711","is_returnable":"1","is_cancelable":"1","is_already_returned":"0","is_already_cancelled":"0","return_request_submitted":null,"total_tax_percent":"0","total_tax_amount":"0","order_items":[{"id":"28","user_id":"250","order_id":"13","delivery_boy_id":"256","seller_id":"1","is_credited":"0","otp":"319817","product_name":"Everyday Milk Powder 400g","variant_name":"","product_variant_id":"10","quantity":"1","price":"226","discounted_price":null,"tax_percent":"0","tax_amount":"0","discount":"0","sub_total":"226","deliver_by":null,"status":[["received","12-04-2023 12:51:54pm"],["processed","12-04-2023 12:52:11pm"],["shipped","12-04-2023 12:52:58pm"],["delivered","12-04-2023 12:52:58pm"]],"active_status":"delivered","date_added":"2023-04-12 12:51:54","product_id":"11","is_cancelable":"1","store_name":"Alpha Shop","store_description":"Admin","seller_rating":"5.0","seller_profile":"https://developmentalphawizz.com/everyday_online/uploads/seller/download_(82)1.jpg","courier_agency":"","tracking_id":"","url":"","seller_name":"Admin","is_returnable":"1","image":"https://developmentalphawizz.com/everyday_online/uploads/media/2023/01122021043641_77455.jpg","name":"Everyday Milk Powder 400g","type":"simple_product","order_counter":"1","order_cancel_counter":"0","order_return_counter":"0","varaint_ids":"","variant_values":"","attr_name":"","image_sm":"https://developmentalphawizz.com/everyday_online/uploads/media/2023/thumb-sm/01122021043641_77455.jpg","image_md":"https://developmentalphawizz.com/everyday_online/uploads/media/2023/01122021043641_77455.jpg","is_already_returned":"0","is_already_cancelled":"0","return_request_submitted":null}]}]

class OrderPaymentModel {
  OrderPaymentModel({
      bool? error, 
      String? message, 
      String? total, 
      List<PaymentModeDataList>? data,}){
    _error = error;
    _message = message;
    _total = total;
    _data = data;
}

  OrderPaymentModel.fromJson(dynamic json) {
    _error = json['error'];
    _message = json['message'];
    _total = json['total'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(PaymentModeDataList.fromJson(v));
      });
    }
  }
  bool? _error;
  String? _message;
  String? _total;
  List<PaymentModeDataList>? _data;
OrderPaymentModel copyWith({  bool? error,
  String? message,
  String? total,
  List<PaymentModeDataList>? data,
}) => OrderPaymentModel(  error: error ?? _error,
  message: message ?? _message,
  total: total ?? _total,
  data: data ?? _data,
);
  bool? get error => _error;
  String? get message => _message;
  String? get total => _total;
  List<PaymentModeDataList>? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['error'] = _error;
    map['message'] = _message;
    map['total'] = _total;
    if (_data != null) {
      map['data'] = _data?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : "13"
/// user_id : "250"
/// address_id : "155"
/// mobile : "7879864312"
/// total : "226"
/// delivery_charge : "10"
/// is_delivery_charge_returnable : "1"
/// wallet_balance : "0"
/// promo_code : " "
/// promo_discount : "0"
/// discount : "0"
/// total_payable : "236"
/// final_total : "236"
/// payment_method : "COD"
/// latitude : "22.7469442"
/// longitude : "75.8980412"
/// address : "151,Ratna Lok Colony,Indore, pardesipura, Indore, Madhya Pradesh, India, 101010"
/// delivery_time : null
/// delivery_date : null
/// date_added : "2023-04-12 12:51:54"
/// otp : "288711"
/// notes : ""
/// order_type : null
/// new_order : "0"
/// username : "Shivani"
/// country_code : "91"
/// name : "Everyday Milk Powder 400g"
/// attachments : []
/// courier_agency : ""
/// tracking_id : ""
/// url : ""
/// order_otp : "288711"
/// is_returnable : "1"
/// is_cancelable : "1"
/// is_already_returned : "0"
/// is_already_cancelled : "0"
/// return_request_submitted : null
/// total_tax_percent : "0"
/// total_tax_amount : "0"
/// order_items : [{"id":"28","user_id":"250","order_id":"13","delivery_boy_id":"256","seller_id":"1","is_credited":"0","otp":"319817","product_name":"Everyday Milk Powder 400g","variant_name":"","product_variant_id":"10","quantity":"1","price":"226","discounted_price":null,"tax_percent":"0","tax_amount":"0","discount":"0","sub_total":"226","deliver_by":null,"status":[["received","12-04-2023 12:51:54pm"],["processed","12-04-2023 12:52:11pm"],["shipped","12-04-2023 12:52:58pm"],["delivered","12-04-2023 12:52:58pm"]],"active_status":"delivered","date_added":"2023-04-12 12:51:54","product_id":"11","is_cancelable":"1","store_name":"Alpha Shop","store_description":"Admin","seller_rating":"5.0","seller_profile":"https://developmentalphawizz.com/everyday_online/uploads/seller/download_(82)1.jpg","courier_agency":"","tracking_id":"","url":"","seller_name":"Admin","is_returnable":"1","image":"https://developmentalphawizz.com/everyday_online/uploads/media/2023/01122021043641_77455.jpg","name":"Everyday Milk Powder 400g","type":"simple_product","order_counter":"1","order_cancel_counter":"0","order_return_counter":"0","varaint_ids":"","variant_values":"","attr_name":"","image_sm":"https://developmentalphawizz.com/everyday_online/uploads/media/2023/thumb-sm/01122021043641_77455.jpg","image_md":"https://developmentalphawizz.com/everyday_online/uploads/media/2023/01122021043641_77455.jpg","is_already_returned":"0","is_already_cancelled":"0","return_request_submitted":null}]

class PaymentModeDataList {
  PaymentModeDataList({
      String? id, 
      String? userId, 
      String? addressId, 
      String? mobile, 
      String? total, 
      String? deliveryCharge, 
      String? isDeliveryChargeReturnable, 
      String? walletBalance, 
      String? promoCode, 
      String? promoDiscount, 
      String? discount, 
      String? totalPayable, 
      String? finalTotal, 
      String? paymentMethod, 
      String? latitude, 
      String? longitude, 
      String? address, 
      dynamic deliveryTime, 
      dynamic deliveryDate, 
      String? dateAdded, 
      String? otp, 
      String? notes, 
      dynamic orderType, 
      String? newOrder, 
      String? username, 
      String? countryCode, 
      String? name, 
      List<dynamic>? attachments, 
      String? courierAgency, 
      String? trackingId, 
      String? url, 
      String? orderOtp, 
      String? isReturnable, 
      String? isCancelable, 
      String? isAlreadyReturned, 
      String? isAlreadyCancelled, 
      dynamic returnRequestSubmitted, 
      String? totalTaxPercent, 
      String? totalTaxAmount, 
      List<OrderItems>? orderItems,}){
    _id = id;
    _userId = userId;
    _addressId = addressId;
    _mobile = mobile;
    _total = total;
    _deliveryCharge = deliveryCharge;
    _isDeliveryChargeReturnable = isDeliveryChargeReturnable;
    _walletBalance = walletBalance;
    _promoCode = promoCode;
    _promoDiscount = promoDiscount;
    _discount = discount;
    _totalPayable = totalPayable;
    _finalTotal = finalTotal;
    _paymentMethod = paymentMethod;
    _latitude = latitude;
    _longitude = longitude;
    _address = address;
    _deliveryTime = deliveryTime;
    _deliveryDate = deliveryDate;
    _dateAdded = dateAdded;
    _otp = otp;
    _notes = notes;
    _orderType = orderType;
    _newOrder = newOrder;
    _username = username;
    _countryCode = countryCode;
    _name = name;
    _attachments = attachments;
    _courierAgency = courierAgency;
    _trackingId = trackingId;
    _url = url;
    _orderOtp = orderOtp;
    _isReturnable = isReturnable;
    _isCancelable = isCancelable;
    _isAlreadyReturned = isAlreadyReturned;
    _isAlreadyCancelled = isAlreadyCancelled;
    _returnRequestSubmitted = returnRequestSubmitted;
    _totalTaxPercent = totalTaxPercent;
    _totalTaxAmount = totalTaxAmount;
    _orderItems = orderItems;
}

  PaymentModeDataList.fromJson(dynamic json) {
    _id = json['id'];
    _userId = json['user_id'];
    _addressId = json['address_id'];
    _mobile = json['mobile'];
    _total = json['total'];
    _deliveryCharge = json['delivery_charge'];
    _isDeliveryChargeReturnable = json['is_delivery_charge_returnable'];
    _walletBalance = json['wallet_balance'];
    _promoCode = json['promo_code'];
    _promoDiscount = json['promo_discount'];
    _discount = json['discount'];
    _totalPayable = json['total_payable'];
    _finalTotal = json['final_total'];
    _paymentMethod = json['payment_method'];
    _latitude = json['latitude'];
    _longitude = json['longitude'];
    _address = json['address'];
    _deliveryTime = json['delivery_time'];
    _deliveryDate = json['delivery_date'];
    _dateAdded = json['date_added'];
    _otp = json['otp'];
    _notes = json['notes'];
    _orderType = json['order_type'];
    _newOrder = json['new_order'];
    _username = json['username'];
    _countryCode = json['country_code'];
    _name = json['name'];
    if (json['attachments'] != null) {
      _attachments = [];
      json['attachments'].forEach((v) {
        _attachments?.add(v.fromJson(v));
      });
    }
    _courierAgency = json['courier_agency'];
    _trackingId = json['tracking_id'];
    _url = json['url'];
    _orderOtp = json['order_otp'];
    _isReturnable = json['is_returnable'];
    _isCancelable = json['is_cancelable'];
    _isAlreadyReturned = json['is_already_returned'];
    _isAlreadyCancelled = json['is_already_cancelled'];
    _returnRequestSubmitted = json['return_request_submitted'];
    _totalTaxPercent = json['total_tax_percent'];
    _totalTaxAmount = json['total_tax_amount'];
    if (json['order_items'] != null) {
      _orderItems = [];
      json['order_items'].forEach((v) {
        _orderItems?.add(OrderItems.fromJson(v));
      });
    }
  }
  String? _id;
  String? _userId;
  String? _addressId;
  String? _mobile;
  String? _total;
  String? _deliveryCharge;
  String? _isDeliveryChargeReturnable;
  String? _walletBalance;
  String? _promoCode;
  String? _promoDiscount;
  String? _discount;
  String? _totalPayable;
  String? _finalTotal;
  String? _paymentMethod;
  String? _latitude;
  String? _longitude;
  String? _address;
  dynamic _deliveryTime;
  dynamic _deliveryDate;
  String? _dateAdded;
  String? _otp;
  String? _notes;
  dynamic _orderType;
  String? _newOrder;
  String? _username;
  String? _countryCode;
  String? _name;
  List<dynamic>? _attachments;
  String? _courierAgency;
  String? _trackingId;
  String? _url;
  String? _orderOtp;
  String? _isReturnable;
  String? _isCancelable;
  String? _isAlreadyReturned;
  String? _isAlreadyCancelled;
  dynamic _returnRequestSubmitted;
  String? _totalTaxPercent;
  String? _totalTaxAmount;
  List<OrderItems>? _orderItems;
PaymentModeDataList copyWith({  String? id,
  String? userId,
  String? addressId,
  String? mobile,
  String? total,
  String? deliveryCharge,
  String? isDeliveryChargeReturnable,
  String? walletBalance,
  String? promoCode,
  String? promoDiscount,
  String? discount,
  String? totalPayable,
  String? finalTotal,
  String? paymentMethod,
  String? latitude,
  String? longitude,
  String? address,
  dynamic deliveryTime,
  dynamic deliveryDate,
  String? dateAdded,
  String? otp,
  String? notes,
  dynamic orderType,
  String? newOrder,
  String? username,
  String? countryCode,
  String? name,
  List<dynamic>? attachments,
  String? courierAgency,
  String? trackingId,
  String? url,
  String? orderOtp,
  String? isReturnable,
  String? isCancelable,
  String? isAlreadyReturned,
  String? isAlreadyCancelled,
  dynamic returnRequestSubmitted,
  String? totalTaxPercent,
  String? totalTaxAmount,
  List<OrderItems>? orderItems,
}) => PaymentModeDataList(  id: id ?? _id,
  userId: userId ?? _userId,
  addressId: addressId ?? _addressId,
  mobile: mobile ?? _mobile,
  total: total ?? _total,
  deliveryCharge: deliveryCharge ?? _deliveryCharge,
  isDeliveryChargeReturnable: isDeliveryChargeReturnable ?? _isDeliveryChargeReturnable,
  walletBalance: walletBalance ?? _walletBalance,
  promoCode: promoCode ?? _promoCode,
  promoDiscount: promoDiscount ?? _promoDiscount,
  discount: discount ?? _discount,
  totalPayable: totalPayable ?? _totalPayable,
  finalTotal: finalTotal ?? _finalTotal,
  paymentMethod: paymentMethod ?? _paymentMethod,
  latitude: latitude ?? _latitude,
  longitude: longitude ?? _longitude,
  address: address ?? _address,
  deliveryTime: deliveryTime ?? _deliveryTime,
  deliveryDate: deliveryDate ?? _deliveryDate,
  dateAdded: dateAdded ?? _dateAdded,
  otp: otp ?? _otp,
  notes: notes ?? _notes,
  orderType: orderType ?? _orderType,
  newOrder: newOrder ?? _newOrder,
  username: username ?? _username,
  countryCode: countryCode ?? _countryCode,
  name: name ?? _name,
  attachments: attachments ?? _attachments,
  courierAgency: courierAgency ?? _courierAgency,
  trackingId: trackingId ?? _trackingId,
  url: url ?? _url,
  orderOtp: orderOtp ?? _orderOtp,
  isReturnable: isReturnable ?? _isReturnable,
  isCancelable: isCancelable ?? _isCancelable,
  isAlreadyReturned: isAlreadyReturned ?? _isAlreadyReturned,
  isAlreadyCancelled: isAlreadyCancelled ?? _isAlreadyCancelled,
  returnRequestSubmitted: returnRequestSubmitted ?? _returnRequestSubmitted,
  totalTaxPercent: totalTaxPercent ?? _totalTaxPercent,
  totalTaxAmount: totalTaxAmount ?? _totalTaxAmount,
  orderItems: orderItems ?? _orderItems,
);
  String? get id => _id;
  String? get userId => _userId;
  String? get addressId => _addressId;
  String? get mobile => _mobile;
  String? get total => _total;
  String? get deliveryCharge => _deliveryCharge;
  String? get isDeliveryChargeReturnable => _isDeliveryChargeReturnable;
  String? get walletBalance => _walletBalance;
  String? get promoCode => _promoCode;
  String? get promoDiscount => _promoDiscount;
  String? get discount => _discount;
  String? get totalPayable => _totalPayable;
  String? get finalTotal => _finalTotal;
  String? get paymentMethod => _paymentMethod;
  String? get latitude => _latitude;
  String? get longitude => _longitude;
  String? get address => _address;
  dynamic get deliveryTime => _deliveryTime;
  dynamic get deliveryDate => _deliveryDate;
  String? get dateAdded => _dateAdded;
  String? get otp => _otp;
  String? get notes => _notes;
  dynamic get orderType => _orderType;
  String? get newOrder => _newOrder;
  String? get username => _username;
  String? get countryCode => _countryCode;
  String? get name => _name;
  List<dynamic>? get attachments => _attachments;
  String? get courierAgency => _courierAgency;
  String? get trackingId => _trackingId;
  String? get url => _url;
  String? get orderOtp => _orderOtp;
  String? get isReturnable => _isReturnable;
  String? get isCancelable => _isCancelable;
  String? get isAlreadyReturned => _isAlreadyReturned;
  String? get isAlreadyCancelled => _isAlreadyCancelled;
  dynamic get returnRequestSubmitted => _returnRequestSubmitted;
  String? get totalTaxPercent => _totalTaxPercent;
  String? get totalTaxAmount => _totalTaxAmount;
  List<OrderItems>? get orderItems => _orderItems;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['user_id'] = _userId;
    map['address_id'] = _addressId;
    map['mobile'] = _mobile;
    map['total'] = _total;
    map['delivery_charge'] = _deliveryCharge;
    map['is_delivery_charge_returnable'] = _isDeliveryChargeReturnable;
    map['wallet_balance'] = _walletBalance;
    map['promo_code'] = _promoCode;
    map['promo_discount'] = _promoDiscount;
    map['discount'] = _discount;
    map['total_payable'] = _totalPayable;
    map['final_total'] = _finalTotal;
    map['payment_method'] = _paymentMethod;
    map['latitude'] = _latitude;
    map['longitude'] = _longitude;
    map['address'] = _address;
    map['delivery_time'] = _deliveryTime;
    map['delivery_date'] = _deliveryDate;
    map['date_added'] = _dateAdded;
    map['otp'] = _otp;
    map['notes'] = _notes;
    map['order_type'] = _orderType;
    map['new_order'] = _newOrder;
    map['username'] = _username;
    map['country_code'] = _countryCode;
    map['name'] = _name;
    if (_attachments != null) {
      map['attachments'] = _attachments?.map((v) => v.toJson()).toList();
    }
    map['courier_agency'] = _courierAgency;
    map['tracking_id'] = _trackingId;
    map['url'] = _url;
    map['order_otp'] = _orderOtp;
    map['is_returnable'] = _isReturnable;
    map['is_cancelable'] = _isCancelable;
    map['is_already_returned'] = _isAlreadyReturned;
    map['is_already_cancelled'] = _isAlreadyCancelled;
    map['return_request_submitted'] = _returnRequestSubmitted;
    map['total_tax_percent'] = _totalTaxPercent;
    map['total_tax_amount'] = _totalTaxAmount;
    if (_orderItems != null) {
      map['order_items'] = _orderItems?.map((v) => v.toJson()).toList();
    }
    return map;
  }

}

/// id : "28"
/// user_id : "250"
/// order_id : "13"
/// delivery_boy_id : "256"
/// seller_id : "1"
/// is_credited : "0"
/// otp : "319817"
/// product_name : "Everyday Milk Powder 400g"
/// variant_name : ""
/// product_variant_id : "10"
/// quantity : "1"
/// price : "226"
/// discounted_price : null
/// tax_percent : "0"
/// tax_amount : "0"
/// discount : "0"
/// sub_total : "226"
/// deliver_by : null
/// status : [["received","12-04-2023 12:51:54pm"],["processed","12-04-2023 12:52:11pm"],["shipped","12-04-2023 12:52:58pm"],["delivered","12-04-2023 12:52:58pm"]]
/// active_status : "delivered"
/// date_added : "2023-04-12 12:51:54"
/// product_id : "11"
/// is_cancelable : "1"
/// store_name : "Alpha Shop"
/// store_description : "Admin"
/// seller_rating : "5.0"
/// seller_profile : "https://developmentalphawizz.com/everyday_online/uploads/seller/download_(82)1.jpg"
/// courier_agency : ""
/// tracking_id : ""
/// url : ""
/// seller_name : "Admin"
/// is_returnable : "1"
/// image : "https://developmentalphawizz.com/everyday_online/uploads/media/2023/01122021043641_77455.jpg"
/// name : "Everyday Milk Powder 400g"
/// type : "simple_product"
/// order_counter : "1"
/// order_cancel_counter : "0"
/// order_return_counter : "0"
/// varaint_ids : ""
/// variant_values : ""
/// attr_name : ""
/// image_sm : "https://developmentalphawizz.com/everyday_online/uploads/media/2023/thumb-sm/01122021043641_77455.jpg"
/// image_md : "https://developmentalphawizz.com/everyday_online/uploads/media/2023/01122021043641_77455.jpg"
/// is_already_returned : "0"
/// is_already_cancelled : "0"
/// return_request_submitted : null

class OrderItems {
  OrderItems({
      String? id, 
      String? userId, 
      String? orderId, 
      String? deliveryBoyId, 
      String? sellerId, 
      String? isCredited, 
      String? otp, 
      String? productName, 
      String? variantName, 
      String? productVariantId, 
      String? quantity, 
      String? price, 
      dynamic discountedPrice, 
      String? taxPercent, 
      String? taxAmount, 
      String? discount, 
      String? subTotal, 
      dynamic deliverBy,
      var status,
      String? activeStatus, 
      String? dateAdded, 
      String? productId, 
      String? isCancelable, 
      String? storeName, 
      String? storeDescription, 
      String? sellerRating, 
      String? sellerProfile, 
      String? courierAgency, 
      String? trackingId, 
      String? url, 
      String? sellerName, 
      String? isReturnable, 
      String? image, 
      String? name, 
      String? type, 
      String? orderCounter, 
      String? orderCancelCounter, 
      String? orderReturnCounter, 
      String? varaintIds, 
      String? variantValues, 
      String? attrName, 
      String? imageSm, 
      String? imageMd, 
      String? isAlreadyReturned, 
      String? isAlreadyCancelled, 
      dynamic returnRequestSubmitted,}){
    _id = id;
    _userId = userId;
    _orderId = orderId;
    _deliveryBoyId = deliveryBoyId;
    _sellerId = sellerId;
    _isCredited = isCredited;
    _otp = otp;
    _productName = productName;
    _variantName = variantName;
    _productVariantId = productVariantId;
    _quantity = quantity;
    _price = price;
    _discountedPrice = discountedPrice;
    _taxPercent = taxPercent;
    _taxAmount = taxAmount;
    _discount = discount;
    _subTotal = subTotal;
    _deliverBy = deliverBy;
    _status = status;
    _activeStatus = activeStatus;
    _dateAdded = dateAdded;
    _productId = productId;
    _isCancelable = isCancelable;
    _storeName = storeName;
    _storeDescription = storeDescription;
    _sellerRating = sellerRating;
    _sellerProfile = sellerProfile;
    _courierAgency = courierAgency;
    _trackingId = trackingId;
    _url = url;
    _sellerName = sellerName;
    _isReturnable = isReturnable;
    _image = image;
    _name = name;
    _type = type;
    _orderCounter = orderCounter;
    _orderCancelCounter = orderCancelCounter;
    _orderReturnCounter = orderReturnCounter;
    _varaintIds = varaintIds;
    _variantValues = variantValues;
    _attrName = attrName;
    _imageSm = imageSm;
    _imageMd = imageMd;
    _isAlreadyReturned = isAlreadyReturned;
    _isAlreadyCancelled = isAlreadyCancelled;
    _returnRequestSubmitted = returnRequestSubmitted;
}

  OrderItems.fromJson(dynamic json) {
    _id = json['id'];
    _userId = json['user_id'];
    _orderId = json['order_id'];
    _deliveryBoyId = json['delivery_boy_id'];
    _sellerId = json['seller_id'];
    _isCredited = json['is_credited'];
    _otp = json['otp'];
    _productName = json['product_name'];
    _variantName = json['variant_name'];
    _productVariantId = json['product_variant_id'];
    _quantity = json['quantity'];
    _price = json['price'];
    _discountedPrice = json['discounted_price'];
    _taxPercent = json['tax_percent'];
    _taxAmount = json['tax_amount'];
    _discount = json['discount'];
    _subTotal = json['sub_total'];
    _deliverBy = json['deliver_by'];
    _activeStatus = json['active_status'];
    _dateAdded = json['date_added'];
    _productId = json['product_id'];
    _isCancelable = json['is_cancelable'];
    _storeName = json['store_name'];
    _storeDescription = json['store_description'];
    _sellerRating = json['seller_rating'];
    _sellerProfile = json['seller_profile'];
    _courierAgency = json['courier_agency'];
    _trackingId = json['tracking_id'];
    _url = json['url'];
    _sellerName = json['seller_name'];
    _isReturnable = json['is_returnable'];
    _image = json['image'];
    _name = json['name'];
    _type = json['type'];
    _orderCounter = json['order_counter'];
    _orderCancelCounter = json['order_cancel_counter'];
    _orderReturnCounter = json['order_return_counter'];
    _varaintIds = json['varaint_ids'];
    _variantValues = json['variant_values'];
    _attrName = json['attr_name'];
    _imageSm = json['image_sm'];
    _imageMd = json['image_md'];
    _isAlreadyReturned = json['is_already_returned'];
    _isAlreadyCancelled = json['is_already_cancelled'];
    _returnRequestSubmitted = json['return_request_submitted'];
  }
  String? _id;
  String? _userId;
  String? _orderId;
  String? _deliveryBoyId;
  String? _sellerId;
  String? _isCredited;
  String? _otp;
  String? _productName;
  String? _variantName;
  String? _productVariantId;
  String? _quantity;
  String? _price;
  dynamic _discountedPrice;
  String? _taxPercent;
  String? _taxAmount;
  String? _discount;
  String? _subTotal;
  dynamic _deliverBy;
  List<List<String>>? _status;
  String? _activeStatus;
  String? _dateAdded;
  String? _productId;
  String? _isCancelable;
  String? _storeName;
  String? _storeDescription;
  String? _sellerRating;
  String? _sellerProfile;
  String? _courierAgency;
  String? _trackingId;
  String? _url;
  String? _sellerName;
  String? _isReturnable;
  String? _image;
  String? _name;
  String? _type;
  String? _orderCounter;
  String? _orderCancelCounter;
  String? _orderReturnCounter;
  String? _varaintIds;
  String? _variantValues;
  String? _attrName;
  String? _imageSm;
  String? _imageMd;
  String? _isAlreadyReturned;
  String? _isAlreadyCancelled;
  dynamic _returnRequestSubmitted;
OrderItems copyWith({  String? id,
  String? userId,
  String? orderId,
  String? deliveryBoyId,
  String? sellerId,
  String? isCredited,
  String? otp,
  String? productName,
  String? variantName,
  String? productVariantId,
  String? quantity,
  String? price,
  dynamic discountedPrice,
  String? taxPercent,
  String? taxAmount,
  String? discount,
  String? subTotal,
  dynamic deliverBy,
  List<List<String>>? status,
  String? activeStatus,
  String? dateAdded,
  String? productId,
  String? isCancelable,
  String? storeName,
  String? storeDescription,
  String? sellerRating,
  String? sellerProfile,
  String? courierAgency,
  String? trackingId,
  String? url,
  String? sellerName,
  String? isReturnable,
  String? image,
  String? name,
  String? type,
  String? orderCounter,
  String? orderCancelCounter,
  String? orderReturnCounter,
  String? varaintIds,
  String? variantValues,
  String? attrName,
  String? imageSm,
  String? imageMd,
  String? isAlreadyReturned,
  String? isAlreadyCancelled,
  dynamic returnRequestSubmitted,
}) => OrderItems(  id: id ?? _id,
  userId: userId ?? _userId,
  orderId: orderId ?? _orderId,
  deliveryBoyId: deliveryBoyId ?? _deliveryBoyId,
  sellerId: sellerId ?? _sellerId,
  isCredited: isCredited ?? _isCredited,
  otp: otp ?? _otp,
  productName: productName ?? _productName,
  variantName: variantName ?? _variantName,
  productVariantId: productVariantId ?? _productVariantId,
  quantity: quantity ?? _quantity,
  price: price ?? _price,
  discountedPrice: discountedPrice ?? _discountedPrice,
  taxPercent: taxPercent ?? _taxPercent,
  taxAmount: taxAmount ?? _taxAmount,
  discount: discount ?? _discount,
  subTotal: subTotal ?? _subTotal,
  deliverBy: deliverBy ?? _deliverBy,
  status: status ?? _status,
  activeStatus: activeStatus ?? _activeStatus,
  dateAdded: dateAdded ?? _dateAdded,
  productId: productId ?? _productId,
  isCancelable: isCancelable ?? _isCancelable,
  storeName: storeName ?? _storeName,
  storeDescription: storeDescription ?? _storeDescription,
  sellerRating: sellerRating ?? _sellerRating,
  sellerProfile: sellerProfile ?? _sellerProfile,
  courierAgency: courierAgency ?? _courierAgency,
  trackingId: trackingId ?? _trackingId,
  url: url ?? _url,
  sellerName: sellerName ?? _sellerName,
  isReturnable: isReturnable ?? _isReturnable,
  image: image ?? _image,
  name: name ?? _name,
  type: type ?? _type,
  orderCounter: orderCounter ?? _orderCounter,
  orderCancelCounter: orderCancelCounter ?? _orderCancelCounter,
  orderReturnCounter: orderReturnCounter ?? _orderReturnCounter,
  varaintIds: varaintIds ?? _varaintIds,
  variantValues: variantValues ?? _variantValues,
  attrName: attrName ?? _attrName,
  imageSm: imageSm ?? _imageSm,
  imageMd: imageMd ?? _imageMd,
  isAlreadyReturned: isAlreadyReturned ?? _isAlreadyReturned,
  isAlreadyCancelled: isAlreadyCancelled ?? _isAlreadyCancelled,
  returnRequestSubmitted: returnRequestSubmitted ?? _returnRequestSubmitted,
);
  String? get id => _id;
  String? get userId => _userId;
  String? get orderId => _orderId;
  String? get deliveryBoyId => _deliveryBoyId;
  String? get sellerId => _sellerId;
  String? get isCredited => _isCredited;
  String? get otp => _otp;
  String? get productName => _productName;
  String? get variantName => _variantName;
  String? get productVariantId => _productVariantId;
  String? get quantity => _quantity;
  String? get price => _price;
  dynamic get discountedPrice => _discountedPrice;
  String? get taxPercent => _taxPercent;
  String? get taxAmount => _taxAmount;
  String? get discount => _discount;
  String? get subTotal => _subTotal;
  dynamic get deliverBy => _deliverBy;
  List<List<String>>? get status => _status;
  String? get activeStatus => _activeStatus;
  String? get dateAdded => _dateAdded;
  String? get productId => _productId;
  String? get isCancelable => _isCancelable;
  String? get storeName => _storeName;
  String? get storeDescription => _storeDescription;
  String? get sellerRating => _sellerRating;
  String? get sellerProfile => _sellerProfile;
  String? get courierAgency => _courierAgency;
  String? get trackingId => _trackingId;
  String? get url => _url;
  String? get sellerName => _sellerName;
  String? get isReturnable => _isReturnable;
  String? get image => _image;
  String? get name => _name;
  String? get type => _type;
  String? get orderCounter => _orderCounter;
  String? get orderCancelCounter => _orderCancelCounter;
  String? get orderReturnCounter => _orderReturnCounter;
  String? get varaintIds => _varaintIds;
  String? get variantValues => _variantValues;
  String? get attrName => _attrName;
  String? get imageSm => _imageSm;
  String? get imageMd => _imageMd;
  String? get isAlreadyReturned => _isAlreadyReturned;
  String? get isAlreadyCancelled => _isAlreadyCancelled;
  dynamic get returnRequestSubmitted => _returnRequestSubmitted;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['id'] = _id;
    map['user_id'] = _userId;
    map['order_id'] = _orderId;
    map['delivery_boy_id'] = _deliveryBoyId;
    map['seller_id'] = _sellerId;
    map['is_credited'] = _isCredited;
    map['otp'] = _otp;
    map['product_name'] = _productName;
    map['variant_name'] = _variantName;
    map['product_variant_id'] = _productVariantId;
    map['quantity'] = _quantity;
    map['price'] = _price;
    map['discounted_price'] = _discountedPrice;
    map['tax_percent'] = _taxPercent;
    map['tax_amount'] = _taxAmount;
    map['discount'] = _discount;
    map['sub_total'] = _subTotal;
    map['deliver_by'] = _deliverBy;
    map['status'] = _status;
    map['active_status'] = _activeStatus;
    map['date_added'] = _dateAdded;
    map['product_id'] = _productId;
    map['is_cancelable'] = _isCancelable;
    map['store_name'] = _storeName;
    map['store_description'] = _storeDescription;
    map['seller_rating'] = _sellerRating;
    map['seller_profile'] = _sellerProfile;
    map['courier_agency'] = _courierAgency;
    map['tracking_id'] = _trackingId;
    map['url'] = _url;
    map['seller_name'] = _sellerName;
    map['is_returnable'] = _isReturnable;
    map['image'] = _image;
    map['name'] = _name;
    map['type'] = _type;
    map['order_counter'] = _orderCounter;
    map['order_cancel_counter'] = _orderCancelCounter;
    map['order_return_counter'] = _orderReturnCounter;
    map['varaint_ids'] = _varaintIds;
    map['variant_values'] = _variantValues;
    map['attr_name'] = _attrName;
    map['image_sm'] = _imageSm;
    map['image_md'] = _imageMd;
    map['is_already_returned'] = _isAlreadyReturned;
    map['is_already_cancelled'] = _isAlreadyCancelled;
    map['return_request_submitted'] = _returnRequestSubmitted;
    return map;
  }

}