class ElectricModel {
  String? electricCode;
  String? electricValue;

  ElectricModel({this.electricCode, this.electricValue});

  ElectricModel.fromJson(Map<String, dynamic> json) {
    electricCode = json['electricCode'];
    electricValue = json['electricValue'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['electricCode'] = this.electricCode;
    data['electricValue'] = this.electricValue;
    return data;
  }
}