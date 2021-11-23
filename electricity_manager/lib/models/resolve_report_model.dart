import 'dart:typed_data';

import 'package:electricity_manager/models/user.dart';

import 'device.dart';

class ResolveReportModel {
  String? id;

  // basic info
  String? resolveName;
  String? resolveAddress;
  List<UserProfile>? electricityUnits;
  List<UserProfile>? regionUnits;
  List<UserProfile>? relatedUnits;

  // resolve info
  String? happening;
  String? scene;
  String? resolveReason;

  // device
  List<Device>? devices;

  // conclude
  List<String>? beforeImageURLs;
  List<String>? finishedImageURLs;
  String? resolveMeasure;
  String? conclude;
  String? signImageURL;
  String? urlWord;

  int createAt = DateTime.now().millisecondsSinceEpoch;
  int updateAt = DateTime.now().millisecondsSinceEpoch;

  List<Uint8List>? beforeImages, finishedImages;
  Uint8List? signImage;

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

  ResolveReportModel();

  void addURLBeforeImages(String url) {
    if (beforeImageURLs == null) {
      beforeImageURLs = [];
    }
    beforeImageURLs?.add(url);
  }

  void addURLFinishedImages(String url) {
    if (finishedImageURLs == null) {
      finishedImageURLs = [];
    }
    finishedImageURLs?.add(url);
  }

  void setBasicInfo(
      {required String resolveName,
      required String resolveAddress,
      required List<UserProfile> electricityUnits,
      required List<UserProfile> regionUnits,
      required List<UserProfile> relatedUnits}) {
    this.resolveName = resolveName;
    this.resolveAddress = resolveAddress;
    this.electricityUnits = electricityUnits;
    this.regionUnits = regionUnits;
    this.relatedUnits = relatedUnits;
  }

  void setResolveInfo(
      {required String happening,
      required String scene,
      required String resolveReason}) {
    this.happening = happening;
    this.scene = scene;
    this.resolveReason = resolveReason;
  }

  void setDevices({required List<Device> devices}) {
    this.devices = devices;
  }

  void setConcludeInfo(
      {required List<Uint8List> beforeImages,
      required List<Uint8List> finishedImages,
      required Uint8List signImage,
      required String resolveMeasure,
      required String conclude}) {
    this.beforeImages = beforeImages;
    this.finishedImages = finishedImages;
    this.resolveMeasure = resolveMeasure;
    this.conclude = conclude;
    this.signImage = signImage;
  }

  ResolveReportModel.fromJson(String id, Map<String, dynamic> json) {
    this.id = id;
    resolveName = json['resolveName'];
    resolveAddress = json['resolveAddress'];
    resolveReason = json['resolveReason'];
    resolveMeasure = json['resolveMeasure'];
    conclude = json['conclude'];
    happening = json['happening'];
    scene = json['scene'];
    signImageURL = json['signImageURL'];
    urlWord = json['urlWord'];
    if (json['beforeImageURLs'] != null) {
      beforeImageURLs = [];
      json['beforeImageURLs'].forEach((v) {
        beforeImageURLs?.add(v);
      });
    }

    if (json['finishedImageURLs'] != null) {
      finishedImageURLs = [];
      json['finishedImageURLs'].forEach((v) {
        finishedImageURLs?.add(v);
      });
    }

    if (json['devices'] != null) {
      devices = [];
      json['devices'].forEach((v) {
        devices?.add(new Device.fromJson(Map.from(v)));
      });
    }
    if (json['electricityUnits'] != null) {
      electricityUnits = [];
      json['electricityUnits'].forEach((v) {
        electricityUnits?.add(new UserProfile.fromJson(Map.from(v)));
      });
    }
    if (json['regionUnits'] != null) {
      regionUnits = [];
      json['regionUnits'].forEach((v) {
        regionUnits?.add(new UserProfile.fromJson(Map.from(v)));
      });
    }
    if (json['relatedUnits'] != null) {
      relatedUnits = [];
      json['relatedUnits'].forEach((v) {
        relatedUnits?.add(new UserProfile.fromJson(Map.from(v)));
      });
    }
  }

  Map<String, dynamic> toImagesJson() {
    return {
      'beforeImageURLs': beforeImageURLs,
      'finishedImageURLs': finishedImageURLs,
      'signImageURL': signImageURL
    };
  }

  Map<String, dynamic> toDataWordJson() {
    Map<String, dynamic> electriUnitMap = {
      "\$cc": "",
      "\$dd": "",
      "\$ee": "",
      "\$ff": ""
    };
    Map<String, dynamic> regionUnitMap = {
      "\$gg": "",
      "\$hh": "",
      "\$ii": "",
      "\$jj": ""
    };
    Map<String, dynamic> relatedUnitMap = {
      "\$kk": "",
      "\$ll": "",
      "\$mm": "",
      "\$nn": ""
    };

    if (this.electricityUnits != null) {
      for (int i = 0; i < this.electricityUnits!.length; i++) {
        if (i == 2) break;
        final user = electricityUnits![i];

        switch (i) {
          case 0:
            electriUnitMap["\$cc"] = user.fullName;
            electriUnitMap["\$dd"] = user.roleName;
            break;
          case 1:
            electriUnitMap["\$ee"] = user.fullName;
            electriUnitMap["\$ff"] = user.roleName;
            break;
        }
      }
    }

    if (this.regionUnits != null) {
      for (int i = 0; i < regionUnits!.length; i++) {
        if (i == 2) break;
        final user = electricityUnits![i];

        switch (i) {
          case 0:
            regionUnitMap["\$gg"] = user.fullName;
            regionUnitMap["\$hh"] = user.roleName;
            break;
          case 1:
            regionUnitMap["\$ii"] = user.fullName;
            regionUnitMap["\$jj"] = user.roleName;
            break;
        }
      }
    }

    if (this.relatedUnits != null) {
      for (int i = 0; i < relatedUnits!.length; i++) {
        if (i == 2) break;
        final user = relatedUnits![i];

        switch (i) {
          case 0:
            relatedUnitMap["\$kk"] = user.fullName;
            relatedUnitMap["\$ll"] = user.roleName;
            break;
          case 1:
            relatedUnitMap["\$mm"] = user.fullName;
            relatedUnitMap["\$nn"] = user.roleName;
            break;
        }
      }
    }

    return {
      "\$aa": this.resolveName,
      "\$bb": this.resolveAddress,
      ...electriUnitMap,
      ...regionUnitMap,
      ...relatedUnitMap,
      "\$oo": this.happening,
      "\$pp": this.scene,
      "\$qq": this.resolveReason,
      "\$rr": this.resolveMeasure,
      "\$ss": this.conclude,
    };
  }

  Map<String, dynamic> toTableWordJson() {
    if (this.devices != null) {
      final tableMap = Map<String, dynamic>();

      for (int i = 0; i < this.devices!.length; i++) {
        final device = devices![i];

        tableMap['$i'] = {
          "1": device.name,
          "2": device.count?.toString() ?? '0',
          "3": device.state,
          "4": device.actionString,
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
    data['id'] = this.id;
    data['resolveName'] = this.resolveName;
    data['resolveAddress'] = this.resolveAddress;
    data['resolveReason'] = this.resolveReason;
    data['resolveMeasure'] = this.resolveMeasure;
    data['conclude'] = this.conclude;
    data['happening'] = this.happening;
    data['scene'] = this.scene;
    data['beforeImageURLs'] = this.beforeImageURLs;
    data['finishedImageURLs'] = this.finishedImageURLs;
    data['signImageURL'] = this.signImageURL;
    if (this.devices != null) {
      data['devices'] = this.devices?.map((v) => v.toJson()).toList();
    }
    if (this.electricityUnits != null) {
      data['electricityUnits'] =
          this.electricityUnits?.map((v) => v.toJson()).toList();
    }
    if (this.regionUnits != null) {
      data['regionUnits'] = this.regionUnits?.map((v) => v.toJson()).toList();
    }
    if (this.relatedUnits != null) {
      data['relatedUnits'] = this.relatedUnits?.map((v) => v.toJson()).toList();
    }
    return data;
  }
}
