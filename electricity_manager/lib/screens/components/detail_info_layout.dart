import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:electricity_manager/commons/text_styles.dart';
import 'package:electricity_manager/models/report_model.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

import 'hero_photo_view_screen.dart';
import 'layout_have_floating_button.dart';

enum VIEW_INFO_TYPE { PREVIEW, DETAIL }

class DetailInfoLayout extends StatelessWidget {
  const DetailInfoLayout(
      {Key? key, required this.reportModel, required this.type})
      : super(key: key);

  final ReportModel reportModel;
  final VIEW_INFO_TYPE type;

  @override
  Widget build(BuildContext context) {
    return LayoutHaveFloatingButton(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _info(),
          _dividerWidget(),
          _congToThaoWidget(context),
          _dividerWidget(),
          _congToTreoWidget(context),
          _dividerWidget(),
          _signWidget(context)
        ],
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
            'Họ và tên nhân viên: ', reportModel.tenNV?.toUpperCase()),
        _labelValueText('Mã khách hàng: ', reportModel.idKH),
        _labelValueText(
            'Họ và tên khách hàng: ', reportModel.tenKH?.toUpperCase()),
        _labelValueText('Địa chỉ: ', reportModel.diaChi)
      ],
    );
  }

  Widget _congToThaoWidget(BuildContext context) {
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
        _labelValueText('Mã công tơ tháo: ', reportModel.maCTThao),
        _labelValueText('Số công tơ tháo: ', reportModel.soCTThao),
        _labelValueText('Chỉ số tháo hữu công: ', reportModel.chiSoCTThao),
        _labelValueText('Ảnh công tơ tháo: '),
        SizedBox(
          height: 8.w,
        ),
        _imagesWidget(context, reportModel.anhCTThao, reportModel.urlAnhCTThao)
      ],
    );
  }

  Widget _congToTreoWidget(BuildContext context) {
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
        _labelValueText('Mã công tơ treo: ', reportModel.maCTTreo),
        _labelValueText('Số công tơ treo: ', reportModel.soCTTreo),
        _labelValueText('Chỉ số tháo hữu công: ', reportModel.chiSoCTTreo),
        _labelValueText('Tem kiểm định: ', reportModel.temKiemDinhCTTreo),
        _labelValueText('Ngày kiểm định: ', reportModel.ngayKiemDinhCTTreo),
        _labelValueText('Ảnh công tơ treo: '),
        SizedBox(
          height: 8.w,
        ),
        _imagesWidget(context, reportModel.anhCTTreo, reportModel.urlAnhCTTreo)
      ],
    );
  }

  Widget _imagesWidget(
      BuildContext context, List? pictures, List<String>? urlAnhCTThao) {
    return Row(
      children: List.generate(
          pictures != null ? pictures.length : urlAnhCTThao!.length,
          (index) => _containerHasPicture(
              context: context,
              image: pictures?[index],
              url: urlAnhCTThao?[index])),
    );
  }

  Widget _signWidget(BuildContext context) {
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
        _containerHasPicture(
            context: context,
            url: reportModel.urlAnhChuKy,
            image: reportModel.anhChuKy)
      ],
    );
  }

  Widget _labelValueText(String? label, [String? value]) {
    final labelStyle = body.copyWith(fontSize: 16.sp);
    final valueStyle = labelStyle.copyWith(
        fontWeight: FontWeight.w600, color: Colors.blueAccent);

    return RichText(
        text: TextSpan(
            style: labelStyle,
            text: label,
            children: [TextSpan(style: valueStyle, text: value)]));
  }

  Widget _containerHasPicture(
      {required BuildContext context, String? url, Uint8List? image}) {
    final isPreview = type == VIEW_INFO_TYPE.PREVIEW;

    final imageWidget = isPreview && image != null
        ? Image.memory(
            image,
            height: 100.w,
            width: 100.w,
            fit: BoxFit.fill,
          )
        : CachedNetworkImage(
            imageUrl: url!,
            height: 100.w,
            width: 100.w,
            fit: BoxFit.fill,
          );

    return Padding(
      padding: EdgeInsets.only(right: 8.w),
      child: InkWell(
        onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => HeroPhotoViewRouteWrapper(
              imageProvider:
                  isPreview ? Image.memory(image!).image : NetworkImage(url!),
              // tag: tagImage,
            ),
          ),
        ),
        child: SizedBox(
          height: 100.w,
          width: 100.w,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(8.0.w),
            child: Container(
              height: 100.w,
              width: 100.w,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(8.w),
                  border: Border.all(color: Colors.lightBlue)),
              alignment: Alignment.center,
              child: imageWidget,
            ),
          ),
        ),
      ),
    );
  }
}
