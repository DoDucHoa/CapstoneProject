class ActivityRequestModel {
  int? id;
  String? provideTime;
  String? description;
  CreatePhotoParameter? createPhotoParameter;

  ActivityRequestModel(
      {this.id, this.provideTime, this.description, this.createPhotoParameter});

  ActivityRequestModel.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    provideTime = json['provideTime'];
    description = json['description'];
    createPhotoParameter = json['createPhotoParameter'] != null
        ? new CreatePhotoParameter.fromJson(json['createPhotoParameter'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['provideTime'] = this.provideTime;
    data['description'] = this.description;
    if (this.createPhotoParameter != null) {
      data['createPhotoParameter'] = this.createPhotoParameter!.toJson();
    }
    return data;
  }
}

class CreatePhotoParameter {
  int? photoTypeId;
  int? idActor;
  String? url;
  bool? isThumbnail;

  CreatePhotoParameter(
      {this.photoTypeId, this.idActor, this.url, this.isThumbnail});

  CreatePhotoParameter.fromJson(Map<String, dynamic> json) {
    photoTypeId = json['photoTypeId'];
    idActor = json['idActor'];
    url = json['url'];
    isThumbnail = json['isThumbnail'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['photoTypeId'] = this.photoTypeId;
    data['idActor'] = this.idActor;
    data['url'] = this.url;
    data['isThumbnail'] = this.isThumbnail;
    return data;
  }
}
