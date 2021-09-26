import 'package:electricity_manager/commons/text_styles.dart';
import 'package:electricity_manager/models/report_model.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ConfirmInfoScreen extends StatefulWidget {
  const ConfirmInfoScreen({Key? key, required this.reportModel})
      : super(key: key);

  final ReportModel reportModel;

  @override
  _ConfirmInfoScreenState createState() => _ConfirmInfoScreenState();
}

class _ConfirmInfoScreenState extends State<ConfirmInfoScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Thông tin treo tháo công tơ',
          style: titleWhite.copyWith(fontSize: 22.sp),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _info(),
              _dividerWidget(),
              _congToThaoWidget(),
              _dividerWidget(),
              _congToTreoWidget(),
              _dividerWidget(),
              _signWidget()
            ],
          ),
        ),
      ),
    );
  }

  Widget _dividerWidget() {
    return Column(
      children: [
        SizedBox(
          height: 8.w,
        ),
        Divider(),
        SizedBox(
          height: 8.w,
        ),
      ],
    );
  }

  Widget _info() {
    final titleStyle = TextStyle(
        fontWeight: FontWeight.bold, fontSize: 20.sp, color: Colors.blue[600]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'THÔNG TIN',
          style: titleStyle,
        ),
        SizedBox(
          height: 8.w,
        ),
        _labelValueText(
            'Họ và tên nhân viên: ', widget.reportModel.tenNV?.toUpperCase()),
        _labelValueText('Mã khách hàng: ', widget.reportModel.idKH),
        _labelValueText(
            'Họ và tên khách hàng: ', widget.reportModel.tenNV?.toUpperCase()),
        _labelValueText('Địa chỉ: ', widget.reportModel.diaChi)
      ],
    );
  }

  Widget _congToThaoWidget() {
    final titleStyle = TextStyle(
        fontWeight: FontWeight.bold, fontSize: 20.sp, color: Colors.blue[600]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'CÔNG TƠ THÁO',
          style: titleStyle,
        ),
        SizedBox(
          height: 8.w,
        ),
        _labelValueText('Mã công tơ tháo: ', widget.reportModel.maCTThao),
        _labelValueText('Số công tơ tháo: ', widget.reportModel.soCTThao),
        _labelValueText(
            'Chỉ số tháo hữu công: ', widget.reportModel.chiSoCTThao),
        _labelValueText('Ảnh công tơ tháo: ', widget.reportModel.diaChi)
      ],
    );
  }

  Widget _congToTreoWidget() {
    final titleStyle = TextStyle(
        fontWeight: FontWeight.bold, fontSize: 20.sp, color: Colors.blue[600]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'CÔNG TƠ TREO',
          style: titleStyle,
        ),
        SizedBox(
          height: 8.w,
        ),
        _labelValueText('Mã công tơ treo: ', widget.reportModel.maCTThao),
        _labelValueText('Số công tơ treo: ', widget.reportModel.soCTThao),
        _labelValueText(
            'Chỉ số tháo hữu công: ', widget.reportModel.chiSoCTThao),
        _labelValueText(
            'Tem kiểm định: ', widget.reportModel.temKiemDinhCTTreo),
        _labelValueText(
            'Ngày kiểm định: ', widget.reportModel.ngayKiemDinhCTTreo),
        _labelValueText('Ảnh công tơ treo: ', widget.reportModel.diaChi)
      ],
    );
  }

  Widget _signWidget() {
    final titleStyle = TextStyle(
        fontWeight: FontWeight.bold, fontSize: 20.sp, color: Colors.blue[600]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'CHỮ KÝ',
          style: titleStyle,
        ),
        SizedBox(
          height: 8.w,
        ),
      ],
    );
  }

  Widget _labelValueText(String? label, String? value) {
    final labelStyle = body.copyWith(fontSize: 16.sp);
    final valueStyle = labelStyle.copyWith(
        fontWeight: FontWeight.w600, color: Colors.blueAccent);

    return RichText(
        text: TextSpan(
            style: labelStyle,
            text: label,
            children: [TextSpan(style: valueStyle, text: value)]));
  }
}
