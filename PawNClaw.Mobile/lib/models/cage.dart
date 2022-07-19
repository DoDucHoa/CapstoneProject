class Cages {
  String? code;
  int? centerId;
  String? name;
  String? color;

  Cages({
    this.code,
    this.centerId,
    this.name,
    this.color,
  });

  Cages.fromJson(Map<String, dynamic> json) {
    code = json['code'];
    centerId = json['centerId'];
    name = json['name'];
    color = json['color'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['code'] = this.code;
    data['centerId'] = this.centerId;
    data['name'] = this.name;
    data['color'] = this.color;

    return data;
  }
}
