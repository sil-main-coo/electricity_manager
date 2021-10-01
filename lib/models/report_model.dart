import 'dart:typed_data';

class ReportModel {
  String? id;
  String? tenNV, idKH, tenKH, diaChi, liDoTreoThao;
  String? maCTThao, soCTThao, chiSoCTThao;
  String? maCTTreo, soCTTreo, chiSoCTTreo;
  String? heSoNhanTreo,
      maChiKDTreo,
      soVienChiKDTreo,
      maChiBoocTreo,
      soVienChiBoocTreo,
      maChiHopTreo,
      soVienChiHopTreo;
  String? temKiemDinhCTTreo, ngayKiemDinhCTTreo;
  List<Uint8List>? anhCTThao, anhCTTreo;
  Uint8List? anhChuKy;

  List<String>? urlAnhCTThao, urlAnhCTTreo;
  String? urlAnhChuKy;
  String? urlWord;

  final now = DateTime.now();

  ReportModel();

  void addAnhThao(String url) {
    if (urlAnhCTThao == null) {
      urlAnhCTThao = [];
    }
    urlAnhCTThao?.add(url);
  }

  void addAnhTreo(String url) {
    if (urlAnhCTTreo == null) {
      urlAnhCTTreo = [];
    }
    urlAnhCTTreo?.add(url);
  }

  void setInfo(staffName, clientCode, clientName, clientAddress, liDo) {
    this.tenNV = staffName;
    this.idKH = clientCode;
    this.tenKH = clientName;
    this.diaChi = clientAddress;
    this.liDoTreoThao = liDo;
  }

  void setCongToThao(maCongTo, soCongTo, chiSoThao, pictures) {
    this.maCTThao = maCongTo;
    this.soCTThao = soCongTo;
    this.chiSoCTThao = chiSoThao;
    this.anhCTThao = pictures;
  }

  void setCongToTreo(
      maCongTo,
      soCongTo,
      heSoNhan,
      chiSoTreo,
      maChiKD,
      vienChiKD,
      maChiBooc,
      vienChiBooc,
      maChiHop,
      vienChiHop,
      temKiemDinh,
      ngayKiemDinh,
      pictures) {
    this.maCTTreo = maCongTo;
    this.soCTTreo = soCongTo;
    this.heSoNhanTreo = heSoNhan;
    this.chiSoCTTreo = chiSoTreo;
    this.maChiKDTreo = maChiKD;
    this.soVienChiKDTreo = vienChiKD;
    this.maChiBoocTreo = maChiBooc;
    this.soVienChiBoocTreo = vienChiBooc;
    this.maChiHopTreo = maChiHop;
    this.soVienChiHopTreo = vienChiHop;
    this.temKiemDinhCTTreo = temKiemDinh;
    this.ngayKiemDinhCTTreo = ngayKiemDinh;
    this.anhCTTreo = pictures;
  }

  ReportModel.fromJson(String id, Map<String, dynamic> json) {
    this.id = id;
    idKH = json['idKH'].toString();
    tenKH = json['tenKH'];
    diaChi = json['diaChi'];
    tenNV = json['tenNV'];
    liDoTreoThao = json['liDo'];

    maCTThao = json['maCTThao'];
    soCTThao = json['soCTThao'];
    chiSoCTThao = json['chiSoCTThao'];

    maCTTreo = json['maCTTreo'];
    soCTTreo = json['soCTTreo'];
    chiSoCTTreo = json['chiSoCTTreo'];
    heSoNhanTreo = json['heSoNhanTreo'];
    maChiKDTreo = json['maChiKDTreo'];
    soVienChiKDTreo = json['soVienChiKDTreo'];
    maChiBoocTreo = json['maChiBoocTreo'];
    soVienChiBoocTreo = json['soVienChiBoocTreo'];
    maChiHopTreo = json['maChiHopTreo'];
    soVienChiHopTreo = json['soVienChiHopTreo'];
    temKiemDinhCTTreo = json['temKiemDinhCTTreo'];
    ngayKiemDinhCTTreo = json['ngayKiemDinhCTTreo'];

    anhChuKy = json['anhChuKy'];
    urlAnhChuKy = json['urlAnhChuKy'];
    urlWord = json['urlWord'];
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

  Map<String, dynamic> toJsonInsertWord() {
    return {
      '@TEN_NV@': this.tenNV,
      '@TEN_KH@': this.tenKH,
      '@DIA_CHI@': this.diaChi,
      '@LI_DO@': this.liDoTreoThao,
      '@SO_THAO@': this.soCTThao,
      '@MA_THAO@': this.maCTThao,
      '@HC_THAO@': this.chiSoCTThao,
      '@SO_TREO@': this.soCTTreo,
      '@MA_TREO@': this.maCTTreo,
      '@HS_TREO': this.heSoNhanTreo,
      '@HC_TREO@': this.chiSoCTTreo,
      '@MS_CHI_KD_TREO@': this.maChiKDTreo,
      '@SO_CHI_KD_TREO@': this.soVienChiKDTreo,
      '@MS_CHI_BOOC_TREO@': this.maChiBoocTreo,
      '@SO_CHI_BOOC_TREO@': this.soVienChiBoocTreo,
      '@MS_CHI_HOP_TREO@': this.maChiHopTreo,
      '@SO_CHI_HOP_TREO@': this.soVienChiHopTreo,
      '@TEM_KD_TREO@': this.temKiemDinhCTTreo,
      '@NGAY_KD_TREO@': this.ngayKiemDinhCTTreo,
      '@NGAY@': this.now.day.toString(),
      '@THANG@': this.now.month.toString(),
    };
  }

  Map<String, dynamic> toWordJson() {
    return {'urlWord': this.urlWord};
  }

  Map<String, dynamic> toImagesJson() {
    return {
      'urlAnhChuKy': urlAnhChuKy,
      'urlAnhCTThao': urlAnhCTThao,
      'urlAnhCTTreo': urlAnhCTTreo
    };
  }

  Map<String, dynamic> toJson() {
    return {
      'idKH': idKH,
      'tenKH': tenKH,
      'diaChi': diaChi,
      'tenNV': tenNV,
      'liDo': liDoTreoThao,
      'maCTThao': maCTThao,
      'soCTThao': soCTThao,
      'chiSoCTThao': chiSoCTThao,
      'maCTTreo': maCTTreo,
      'soCTTreo': soCTTreo,
      'chiSoCTTreo': chiSoCTTreo,
      'heSoNhanTreo': heSoNhanTreo,
      'maChiKDTreo': maChiKDTreo,
      'soVienChiKDTreo': soVienChiKDTreo,
      'maChiBoocTreo': maChiBoocTreo,
      'soVienChiBoocTreo': soVienChiBoocTreo,
      'maChiHopTreo': maChiHopTreo,
      'soVienChiHopTreo': soVienChiHopTreo,
      'temKiemDinhCTTreo': temKiemDinhCTTreo,
      'ngayKiemDinhCTTreo': ngayKiemDinhCTTreo,
    };
  }
}
