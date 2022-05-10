class Account {
  String? _jwtToken;
  int? _id;
  String? _userName;
  String? _name;
  String? _phone;
  String? _email;
  String? _role;

  Account(
      {String? jwtToken,
      int? id,
      String? userName,
      String? name,
      String? phone,
      String? email,
      String? role}) {
    if (jwtToken != null) {
      this._jwtToken = jwtToken;
    }
    if (id != null) {
      this._id = id;
    }
    if (userName != null) {
      this._userName = userName;
    }
    if (name != null) {
      this._name = name;
    }
    if (phone != null) {
      this._phone = phone;
    }
    if (email != null) {
      this._email = email;
    }
    if (role != null) {
      this._role = role;
    }
  }

  String? get jwtToken => _jwtToken;
  set jwtToken(String? jwtToken) => _jwtToken = jwtToken;
  int? get id => _id;
  set id(int? id) => _id = id;
  String? get userName => _userName;
  set userName(String? userName) => _userName = userName;
  String? get name => _name;
  set name(String? name) => _name = name;
  String? get phone => _phone;
  set phone(String? phone) => _phone = phone;
  String? get email => _email;
  set email(String? email) => _email = email;
  String? get role => _role;
  set role(String? role) => _role = role;

  Account.fromJson(Map<String, dynamic> json) {
    _jwtToken = json['jwtToken'];
    _id = json['id'];
    _userName = json['userName'];
    _name = json['name'];
    _phone = json['phone'];
    _email = json['email'];
    _role = json['role'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['jwtToken'] = this._jwtToken;
    data['id'] = this._id;
    data['userName'] = this._userName;
    data['name'] = this._name;
    data['phone'] = this._phone;
    data['email'] = this._email;
    data['role'] = this._role;
    return data;
  }
}