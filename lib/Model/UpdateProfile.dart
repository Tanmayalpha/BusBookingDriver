/// error : false
/// message : "Profile Update Succesfully"
/// data : {"pro_pic":"https://developmentalphawizz.com/everyday_online/uploads/user_image/welcome2.jpg"}

class UpdateProfile {
  UpdateProfile({
      bool? error, 
      String? message, 
      Data? data,}){
    _error = error;
    _message = message;
    _data = data;
}

  UpdateProfile.fromJson(dynamic json) {
    _error = json['error'];
    _message = json['message'];
    _data = json['data'] != null ? Data.fromJson(json['data']) : null;
  }
  bool? _error;
  String? _message;
  Data? _data;
UpdateProfile copyWith({  bool? error,
  String? message,
  Data? data,
}) => UpdateProfile(  error: error ?? _error,
  message: message ?? _message,
  data: data ?? _data,
);
  bool? get error => _error;
  String? get message => _message;
  Data? get data => _data;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['error'] = _error;
    map['message'] = _message;
    if (_data != null) {
      map['data'] = _data?.toJson();
    }
    return map;
  }

}

/// pro_pic : "https://developmentalphawizz.com/everyday_online/uploads/user_image/welcome2.jpg"

class Data {
  Data({
      String? proPic,}){
    _proPic = proPic;
}

  Data.fromJson(dynamic json) {
    _proPic = json['pro_pic'];
  }
  String? _proPic;
Data copyWith({  String? proPic,
}) => Data(  proPic: proPic ?? _proPic,
);
  String? get proPic => _proPic;

  Map<String, dynamic> toJson() {
    final map = <String, dynamic>{};
    map['pro_pic'] = _proPic;
    return map;
  }

}