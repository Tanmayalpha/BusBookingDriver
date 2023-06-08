/// error : true
/// message : "Cash collection does not exist"
/// total : 0
/// data : []

class CashPaymentModel {
  CashPaymentModel({
      bool? error, 
      String? message, 
      num? total, 
      List<dynamic>? data,}){
    _error = error;
    _message = message;
    _total = total;
    _data = data;
}

  CashPaymentModel.fromJson(dynamic json) {
    _error = json['error'];
    _message = json['message'];
    _total = json['total'];
    if (json['data'] != null) {
      _data = [];
      json['data'].forEach((v) {
        _data?.add(v.fromJson(v));
      });
    }
  }
  bool? _error;
  String? _message;
  num? _total;
  List<dynamic>? _data;
CashPaymentModel copyWith({  bool? error,
  String? message,
  num? total,
  List<dynamic>? data,
}) => CashPaymentModel(  error: error ?? _error,
  message: message ?? _message,
  total: total ?? _total,
  data: data ?? _data,
);
  bool? get error => _error;
  String? get message => _message;
  num? get total => _total;
  List<dynamic>? get data => _data;

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