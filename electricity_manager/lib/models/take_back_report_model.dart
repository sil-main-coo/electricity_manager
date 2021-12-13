import 'dart:typed_data';
import 'package:electricity_manager/models/user.dart';
import 'device.dart';
import 'electricity_model.dart';

class TakeBackReportModel {
  String? id;
  String? clientCode;
  String? clientName;
  String? clientAddress;
  List<UserProfile>? staffs;
  List<Device>? devices;
  ElectricModel? outputElectric;
  ElectricModel? hangingElectric;
  List<String>? urlBeforeImages;
  List<String>? urlFinishedImages;
  String? urlManagerSignImage;
  String? urlPresidentSignImage;
  String? urlStaffSignImage;
  String? urlWord;
  Uint8List? managerSignImage, staffSignImage, presidentSignImage;
  List<Uint8List>? beforeImages, finishedImages;
  DateTime? createAt;
  DateTime? updateAt;

  String get createAtString => _createAtString(createAt);

  String get updateAtString => _createAtString(updateAt);

  int deviceTotal() {
    int count = 0;
    devices?.forEach((element) {
      count += element.count ?? 0;
    });

    return count;
  }

  String _createAtString(DateTime? date) {
    if (date == null) return '';
    return '${date.day < 10 ? '0${date.day}' : date.day}/${date.month < 10 ? '0${date.month}' : date.month}/${date.year}';
  }

  TakeBackReportModel();

  void addURLBeforeImages(String url) {
    if (urlBeforeImages == null) {
      urlBeforeImages = [];
    }
    urlBeforeImages?.add(url);
  }

  void addURLFinishedImages(String url) {
    if (urlFinishedImages == null) {
      urlFinishedImages = [];
    }
    urlFinishedImages?.add(url);
  }

  void setBasicInfo(
      {required String clientCode,
      required String clientName,
      required String clientAddress,
      required List<UserProfile> staffs}) {
    this.clientCode = clientCode;
    this.clientName = clientName;
    this.clientAddress = clientAddress;
    this.staffs = staffs;
    this.createAt = DateTime.now();
    this.updateAt = DateTime.now();
  }

  void setElectricityInfo(
      {required ElectricModel outputElectric,
        required ElectricModel hangingElectric,
      required List<Uint8List> beforeImages,
      required List<Uint8List> finishedImages}) {
    this.outputElectric = outputElectric;
    this.hangingElectric = hangingElectric;
    this.beforeImages = beforeImages;
    this.finishedImages = finishedImages;
  }

  void setDevices({required List<Device> devices}) {
    this.devices = devices;
  }

  void setAdditional(
      {required Uint8List managerSignImage,
      required Uint8List staffSignImage,
      required Uint8List presidentSignImage}) {
    this.managerSignImage = managerSignImage;
    this.staffSignImage = staffSignImage;
    this.presidentSignImage = presidentSignImage;
  }

  TakeBackReportModel.fromJson(String id, Map<String, dynamic> json) {
    this.id = id;
    clientCode = json['clientCode'];
    clientName = json['clientName'];
    clientAddress = json['clientAddress'];
    if (json['outputElectric'] != null) {
      outputElectric = ElectricModel.fromJson(Map.from(json['outputElectric']));
    }
    if (json['hangingElectric'] != null) {
      hangingElectric =
          ElectricModel.fromJson(Map.from(json['hangingElectric']));
    }
    if (json['staffs'] != null) {
      staffs = [];
      json['staffs'].forEach((v) {
        staffs?.add(new UserProfile.fromJson(Map.from(v)));
      });
    }
    if (json['devices'] != null) {
      devices = [];
      json['devices'].forEach((v) {
        devices?.add(new Device.fromJson(Map.from(v)));
      });
    }
    if (json['urlBeforeImages'] != null) {
      urlBeforeImages = [];
      json['urlBeforeImages'].forEach((picture) {
        urlBeforeImages?.add(picture);
      });
    }

    if (json['urlFinishedImages'] != null) {
      urlFinishedImages = [];
      json['urlFinishedImages'].forEach((picture) {
        urlFinishedImages?.add(picture);
      });
    }

    urlManagerSignImage = json['urlManagerSignImage'];
    urlStaffSignImage = json['urlStaffSignImage'];
    urlPresidentSignImage = json['urlPresidentSignImage'];
    urlWord = json['urlWord'];
    if (json['createAt'] != null)
      createAt = DateTime.fromMillisecondsSinceEpoch(json['createAt']);
    if (json['updateAt'] != null)
      updateAt = DateTime.fromMillisecondsSinceEpoch(json['updateAt']);
  }

  Map<String, dynamic> toImagesJson() {
    return {
      'urlPresidentSignImage': urlPresidentSignImage,
      'urlManagerSignImage': urlManagerSignImage,
      'urlStaffSignImage': urlStaffSignImage,
      'urlBeforeImages': urlBeforeImages,
      'urlFinishedImages': urlFinishedImages
    };
  }

  Map<String, dynamic> toDataWordJson() {
    Map<String, dynamic> staffMap = {
      "\$hh": "",
      "\$ii": "",
      "\$kk": "",
      "\$ll": "",
      "\$mm": "",
      "\$nn": "",
    };

    if (staffs != null) {
      for (int i = 0; i < staffs!.length; i++) {
        if (i == 3) break;
        final staff = staffs![i];

        switch (i) {
          case 0:
            staffMap["\$hh"] = staff.fullName;
            staffMap["\$ii"] = staff.roleName ?? staff.roleString;
            break;
          case 1:
            staffMap["\$kk"] = staff.fullName;
            staffMap["\$ll"] = staff.roleName ?? staff.roleString;
            break;
          case 2:
            staffMap["\$mm"] = staff.fullName;
            staffMap["\$nn"] = staff.roleName ?? staff.roleString;
            break;
        }
      }
    }

    return {
      "\$aa": this.clientName,
      "\$bb": this.clientCode,
      "\$cc": this.outputElectric?.electricCode??'',
      "\$dd": this.clientAddress,
      "\$ee": createAt?.day.toString(),
      "\$ff": createAt?.month.toString(),
      "\$gg": createAt?.year.toString().substring(2),
      ...staffMap,
      "\$oo": "",
    };
  }

  Map<String, dynamic> toTableWordJson() {
    if (this.devices != null) {
      final tableMap = Map<String, dynamic>();

      for (int i = 0; i < this.devices!.length; i++) {
        final device = devices![i];

        tableMap['$i'] = {
          "1": device.name,
          "2": "",
          "3": device.count?.toString() ?? '0',
          "4": device.note ?? ''
        };
      }
      return tableMap;
    }

    return {};
  }

  Map<String, dynamic> toWordJson() {
    return {'urlWord': this.urlWord};
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['clientCode'] = this.clientCode;
    data['clientName'] = this.clientName;
    data['clientAddress'] = this.clientAddress;
    data['outputElectric'] = this.outputElectric?.toJson();
    data['hangingElectric'] = this.hangingElectric?.toJson();
    if (this.staffs != null) {
      data['staffs'] = this.staffs?.map((v) => v.toJson()).toList();
    }
    if (this.devices != null) {
      data['devices'] = this.devices?.map((v) => v.toJson()).toList();
    }
    data['urlBeforeImages'] = this.urlFinishedImages;
    data['urlFinishedImages'] = this.urlFinishedImages;
    data['urlManagerSignImage'] = this.urlManagerSignImage;
    data['urlPresidentSignImage'] = this.urlPresidentSignImage;
    data['urlStaffSignImage'] = this.urlStaffSignImage;
    data['createAt'] = this.createAt?.millisecondsSinceEpoch;
    data['updateAt'] = this.updateAt?.millisecondsSinceEpoch;
    return data;
  }
}
