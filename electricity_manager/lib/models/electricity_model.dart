class ElectricModel {
  String? electricCode;
  String? electricValue;
  PointTimeModel? lowTime, normalTime, highTime;

  ElectricModel(
      {this.electricCode,
      this.electricValue,
      this.highTime,
      this.lowTime,
      this.normalTime});

  ElectricModel.fromJson(Map<String, dynamic> json) {
    electricCode = json['electricCode'];
    electricValue = json['electricValue'];

    if (json['lowTime'] != null) {
      lowTime = PointTimeModel.fromJson(Map.from(json['lowTime']));
    }

    if (json['normalTime'] != null) {
      lowTime = PointTimeModel.fromJson(Map.from(json['normalTime']));
    }

    if (json['highTime'] != null) {
      lowTime = PointTimeModel.fromJson(Map.from(json['highTime']));
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['electricCode'] = this.electricCode;
    data['electricValue'] = this.electricValue;
    data['lowTime'] = this.lowTime?.toJson();
    data['normalTime'] = this.normalTime?.toJson();
    data['highTime'] = this.highTime?.toJson();
    return data;
  }
}

class PointTimeModel {
  String? ship;
  String? receive;

  PointTimeModel({this.ship, this.receive});

  PointTimeModel.fromJson(Map<String, dynamic> json) {
    receive = json['receive'];
    ship = json['ship'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['receive'] = this.receive;
    data['ship'] = this.ship;
    return data;
  }
}
