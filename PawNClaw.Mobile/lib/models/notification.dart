class Notification {
  String? content;
  String? title;
  int? actorId;
  String? actorType;
  int? targetId;
  String? targetType;
  String? time;
  bool? seen;

  Notification(
      {this.content,
      this.title,
      this.actorId,
      this.actorType,
      this.targetId,
      this.targetType,
      this.time,
      this.seen});

  Notification.fromJson(Map<String, dynamic> json) {
    content = json['content'];
    title = json['title'];
    actorId = json['actorId'];
    actorType = json['actorType'];
    targetId = json['targetId'];
    targetType = json['targetType'];
    time = json['time'];
    seen = json['seen'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['content'] = this.content;
    data['title'] = this.title;
    data['actorId'] = this.actorId;
    data['actorType'] = this.actorType;
    data['targetId'] = this.targetId;
    data['targetType'] = this.targetType;
    data['time'] = this.time;
    data['seen'] = this.seen;
    return data;
  }
}
