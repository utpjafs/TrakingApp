class User {
  String id;
  String name;
  String email;
  String password;
  String apiToken;
  String deviceToken;
  String phone;
  String address;
  String bio;
  String languageDefault;

  bool auth;
  User();

  User.fromJSON(Map<String, dynamic> jsonMap) {
    try {
      id = jsonMap['id'].toString();
      name = jsonMap['name'];
      email = jsonMap['email'];
      apiToken = jsonMap['api_token'];
      deviceToken = jsonMap['device_token'];
      languageDefault = jsonMap['language_default'];
      phone = jsonMap['phone'];
    } catch (e) {
      print(e);
    }
  }

  Map toMap() {
    var map = new Map<String, dynamic>();
    map["id"] = id;
    map["email"] = email;
    map["name"] = name;
    map["password"] = password;
    map["api_token"] = apiToken;
    if (deviceToken != null) {
      map["device_token"] = deviceToken;
    }
    map["phone"] = phone.toString();

    return map;
  }

  @override
  String toString() {
    var map = this.toMap();
    map["auth"] = this.auth;
    return map.toString();
  }
}
