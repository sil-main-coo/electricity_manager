import 'dart:typed_data';
import 'package:electricity_manager/models/user.dart';
import 'device.dart';

class TakeBackReportModel {
  String? id;
  String? clientCode;
  String? clientName;
  String? clientAddress;
  List<UserProfile>? staffs;
  List<Device>? devices;
  String? electricNumber;
  List<String>? urlBeforeImages;
  List<String>? urlFinishedImages;
  String? urlCustomerSignImage;
  String? urlStaffSignImage;
  String? urlWord;
  int createAt = DateTime.now().millisecondsSinceEpoch;
  int updateAt = DateTime.now().millisecondsSinceEpoch;

  DateTime parseDate(int input) {
    return DateTime.fromMillisecondsSinceEpoch(input);
  }

  int deviceTotal() {
    int count = 0;
    devices?.forEach((element) {
      count += element.count ?? 0;
    });

    return count;
  }

  String createAtString() {
    final date = DateTime.fromMillisecondsSinceEpoch(createAt);

    return '${date.day < 10 ? '0${date.day}' : date.day}/${date.month < 10 ? '0${date.month}' : date.month}/${date.year}';
  }

  Uint8List? customerSignImage, staffSignImage;
  List<Uint8List>? beforeImages, finishedImages;

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
  }

  void setElectricityInfo(
      {required String electricNumber,
      required List<Uint8List> beforeImages,
      required List<Uint8List> finishedImages}) {
    this.electricNumber = electricNumber;
    this.beforeImages = beforeImages;
    this.finishedImages = finishedImages;
  }

  void setDevices({required List<Device> devices}) {
    this.devices = devices;
  }

  void setAdditional(
      {required Uint8List customerSignImage,
      required Uint8List staffSignImage}) {
    this.customerSignImage = customerSignImage;
    this.staffSignImage = staffSignImage;
  }

  TakeBackReportModel.fromJson(String id, Map<String, dynamic> json) {
    this.id = id;
    clientCode = json['clientCode'];
    clientName = json['clientName'];
    clientAddress = json['clientAddress'];
    electricNumber = json['electricNumber'];
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
    urlCustomerSignImage = json['urlCustomerSignImage'];
    urlStaffSignImage = json['urlStaffSignImage'];
    urlWord = json['urlWord'];
    createAt = json['createAt'];
    updateAt = json['updateAt'];
  }

  Map<String, dynamic> toImagesJson() {
    return {
      'urlCustomerSignImage': urlCustomerSignImage,
      'urlStaffSignImage': urlStaffSignImage,
      'urlBeforeImages': urlBeforeImages,
      'urlFinishedImages': urlFinishedImages
    };
  }

  Map<String, dynamic> toDataWordJson() {
    final createAtDate = parseDate(this.createAt);

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
      "\$cc": this.electricNumber,
      "\$dd": this.clientAddress,
      "\$ee": createAtDate.day.toString(),
      "\$ff": createAtDate.month.toString(),
      "\$gg": createAtDate.year.toString().substring(2),
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
          "4": ""
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
    data['electricNumber'] = this.electricNumber;
    if (this.staffs != null) {
      data['staffs'] = this.staffs?.map((v) => v.toJson()).toList();
    }
    if (this.devices != null) {
      data['devices'] = this.devices?.map((v) => v.toJson()).toList();
    }
    data['urlBeforeImages'] = this.urlFinishedImages;
    data['urlFinishedImages'] = this.urlFinishedImages;
    data['urlCustomerSignImage'] = this.urlCustomerSignImage;
    data['urlStaffSignImage'] = this.urlStaffSignImage;
    data['createAt'] = this.createAt;
    data['updateAt'] = this.updateAt;
    return data;
  }
}
