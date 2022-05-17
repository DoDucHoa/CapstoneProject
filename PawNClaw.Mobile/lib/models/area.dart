class Area {
  String? _code;
  String? _name;
  List<Districts>? _districts;

  Area({String? code, String? name, List<Districts>? districts}) {
    if (code != null) {
      this._code = code;
    }
    if (name != null) {
      this._name = name;
    }
    if (districts != null) {
      this._districts = districts;
    }
  }

  String? get code => _code;
  set code(String? code) => _code = code;
  String? get name => _name;
  set name(String? name) => _name = name;
  List<Districts>? get districts => _districts;
  set districts(List<Districts>? districts) => _districts = districts;

  Area.fromJson(Map<String, dynamic> json) {
    _code = json['code'];
    _name = json['name'];
    if (json['districts'] != null) {
      _districts = <Districts>[];
      json['districts'].forEach((v) {
        _districts!.add(new Districts.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this._code;
    data['name'] = this._name;
    if (this._districts != null) {
      data['districts'] = this._districts!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class Districts {
  String? _code;
  String? _name;
  String? _cityCode;
  Null? _cityCodeNavigation;
  List<Null>? _locations;
  List<Null>? _wards;

  Districts({String? code, String? name, String? cityCode}) {
    if (code != null) {
      this._code = code;
    }
    if (name != null) {
      this._name = name;
    }
    if (cityCode != null) {
      this._cityCode = cityCode;
    }
  }

  String? get code => _code;
  set code(String? code) => _code = code;
  String? get name => _name;
  set name(String? name) => _name = name;
  String? get cityCode => _cityCode;
  set cityCode(String? cityCode) => _cityCode = cityCode;

  Districts.fromJson(Map<String, dynamic> json) {
    _code = json['code'];
    _name = json['name'];
    _cityCode = json['cityCode'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this._code;
    data['name'] = this._name;
    data['cityCode'] = this._cityCode;
    return data;
  }
}
