class ActivityRequestModel {
  CreateBookingActivityParameter? createBookingActivityParameter;
  CreatePhotoParameter? createPhotoParameter;

  ActivityRequestModel(
      {this.createBookingActivityParameter, this.createPhotoParameter});

  ActivityRequestModel.fromJson(Map<String, dynamic> json) {
    createBookingActivityParameter =
        json['createBookingActivityParameter'] != null
            ? new CreateBookingActivityParameter.fromJson(
                json['createBookingActivityParameter'])
            : null;
    createPhotoParameter = json['createPhotoParameter'] != null
        ? new CreatePhotoParameter.fromJson(json['createPhotoParameter'])
        : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    if (this.createBookingActivityParameter != null) {
      data['createBookingActivityParameter'] =
          this.createBookingActivityParameter!.toJson();
    }
    if (this.createPhotoParameter != null) {
      data['createPhotoParameter'] = this.createPhotoParameter!.toJson();
    }
    return data;
  }
}

class CreateBookingActivityParameter {
  String? provideTime;
  String? description;
  int? bookingId;
  int? line;
  int? petId;
  int? supplyId;
  int? serviceId;

  CreateBookingActivityParameter(
      {this.provideTime,
      this.description,
      this.bookingId,
      this.line,
      this.petId,
      this.supplyId,
      this.serviceId});

  CreateBookingActivityParameter.fromJson(Map<String, dynamic> json) {
    provideTime = json['provideTime'];
    description = json['description'];
    bookingId = json['bookingId'];
    line = json['line'];
    petId = json['petId'];
    supplyId = json['supplyId'];
    serviceId = json['serviceId'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['provideTime'] = this.provideTime;
    data['description'] = this.description;
    data['bookingId'] = this.bookingId;
    data['line'] = this.line;
    data['petId'] = this.petId;
    data['supplyId'] = this.supplyId;
    data['serviceId'] = this.serviceId;
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
