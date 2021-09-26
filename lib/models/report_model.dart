import 'dart:typed_data';

class ReportModel {
  String? tenNV, idKH, tenKH, diaChi;
  String? maCTThao, soCTThao, chiSoCTThao;
  String? maCTTreo, soCTTreo, chiSoCTTreo;
  String? temKiemDinhCTTreo, ngayKiemDinhCTTreo;
  List<Uint8List>? anhCTThao, anhCTTreo;
  Uint8List? anhChuKy;

  List<String>? urlAnhCTThao, urlAnhCTTreo;
  String? urlAnhChuKy;

  ReportModel();

  void setInfo(staffName, clientCode, clientName, clientAddress) {
    this.tenNV = staffName;
    this.idKH = clientCode;
    this.tenKH = clientName;
    this.diaChi = clientAddress;
  }

  void setCongToThao(maCongTo, soCongTo, chiSoThao, pictures) {
    this.maCTThao = maCongTo;
    this.soCTThao = soCongTo;
    this.chiSoCTThao = chiSoThao;
    this.anhCTThao = pictures;
  }

  void setCongToTreo(
      maCongTo, soCongTo, chiSoThao, temKiemDinh, ngayKiemDinh, pictures) {
    this.maCTTreo = maCongTo;
    this.soCTTreo = soCongTo;
    this.chiSoCTTreo = chiSoThao;
    this.temKiemDinhCTTreo = temKiemDinh;
    this.ngayKiemDinhCTTreo = ngayKiemDinh;
    this.anhCTTreo = pictures;
  }

  ReportModel.fromJson(Map<String, dynamic> json) {
    idKH = json['idKH'];
    tenKH = json['tenKH'];
    diaChi = json['diaChi'];
    tenNV = json['tenNV'];
    maCTThao = json['maCTThao'];
    soCTThao = json['soCTThao'];
    chiSoCTThao = json['chiSoCTThao'];
    maCTTreo = json['maCTTreo'];
    soCTTreo = json['soCTTreo'];
    chiSoCTTreo = json['chiSoCTTreo'];
    temKiemDinhCTTreo = json['temKiemDinhCTTreo'];
    ngayKiemDinhCTTreo = json['ngayKiemDinhCTTreo'];
    anhChuKy = json['anhChuKy'];
    urlAnhChuKy = json['urlAnhChuKy'];
    if (json['anhCTThao'] != null) {
      anhCTThao = [];
      json['anhCTThao'].forEach((picture) {
        anhCTThao?.add(picture);
      });
    }

    if (json['anhCTTreo'] != null) {
      anhCTTreo = [];
      json['anhCTTreo'].forEach((picture) {
        anhCTTreo?.add(picture);
      });
    }

    if (json['urlAnhCTThao'] != null) {
      urlAnhCTThao = json['urlAnhCTThao'].cast<String>();
    }

    if (json['urlAnhCTTreo'] != null) {
      urlAnhCTTreo = json['urlAnhCTTreo'].cast<String>();
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'idKH': idKH,
      'tenKH': tenKH,
      'diaChi': diaChi,
      'tenNV': tenNV,
      'maCTThao': maCTThao,
      'soCTThao': soCTThao,
      'chiSoCTThao': chiSoCTThao,
      'maCTTreo': maCTTreo,
      'soCTTreo': soCTTreo,
      'chiSoCTTreo': chiSoCTTreo,
      'temKiemDinhCTTreo': temKiemDinhCTTreo,
      'ngayKiemDinhCTTreo': ngayKiemDinhCTTreo,
      'anhChuKy': anhChuKy,
      'urlAnhChuKy': urlAnhChuKy,
    };
  }
}
