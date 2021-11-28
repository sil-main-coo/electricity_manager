import 'dart:typed_data';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:electricity_manager/models/resolve_report_model.dart';
import 'package:electricity_manager/screens/components/hero_photo_view_screen.dart';
import 'package:electricity_manager/screens/components/layout_have_floating_button.dart';
import 'package:electricity_manager/utils/commons/text_styles.dart';
import 'package:electricity_manager/utils/enums/detail_view_enum.dart';

class ResolveReportDetailLayout extends StatelessWidget {
  const ResolveReportDetailLayout(
      {Key? key, required this.reportModel, required this.type})
      : super(key: key);

  final ResolveReportModel reportModel;
  final DETAIL_VIEW type;

  @override
  Widget build(BuildContext context) {
    return LayoutHaveFloatingButton(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _info(),
          _dividerWidget(),
          _units(),
          _dividerWidget(),
          _resolveWidget(),
          _dividerWidget(),
          _devicesWidget(context),
          _dividerWidget(),
          _conclude(context),
          _dividerWidget(),
          _relatedSignWidget(context),
          _dividerWidget(),
          _regionSignWidget(context),
          _dividerWidget(),
          _electricitySignWidget(context),
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
          'THÔNG TIN CƠ BẢN',
          style: titleStyle,
        ),
        SizedBox(
          height: 8.w,
        ),
        _labelValueText('Ngày lập biên bản: ', reportModel.createAtString),
        _labelValueText('Tên sự cố: ', reportModel.resolveName),
        _labelValueText('Địa chỉ: ', reportModel.resolveAddress),
      ],
    );
  }

  Widget _units() {
    final titleStyle = TextStyle(
        fontWeight: FontWeight.bold, fontSize: 20.sp, color: Colors.blue[600]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Đơn vị quản lý vận hành lưới điện'.toUpperCase(),
          style: titleStyle,
        ),
        SizedBox(
          height: 8.w,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            reportModel.electricityUnits!.length,
            (index) => _labelValueText('Ông/Bà: ',
                '${reportModel.electricityUnits![index].fullName?.toUpperCase()} (${reportModel.electricityUnits![index].roleName})'),
          ),
        ),
        _dividerWidget(),
        Text(
          'Chính quyền địa phương '.toUpperCase(),
          style: titleStyle,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            reportModel.regionUnits!.length,
            (index) => _labelValueText('Ông/Bà: ',
                '${reportModel.regionUnits![index].fullName?.toUpperCase()} (${reportModel.regionUnits![index].roleName})'),
          ),
        ),
        _dividerWidget(),
        Text(
          'Tổ chức cá nhân liên quan đến sự cố '.toUpperCase(),
          style: titleStyle,
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            reportModel.relatedUnits!.length,
            (index) => _labelValueText('Ông/Bà: ',
                '${reportModel.relatedUnits![index].fullName?.toUpperCase()} (${reportModel.relatedUnits![index].roleName})'),
          ),
        ),
      ],
    );
  }

  Widget _resolveWidget() {
    final titleStyle = TextStyle(
        fontWeight: FontWeight.bold, fontSize: 20.sp, color: Colors.blue[600]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'THÔNG TIN SỰ CỐ',
          style: titleStyle,
        ),
        SizedBox(
          height: 8.w,
        ),
        _labelValueText('Tóm tắt diễn biến: ', reportModel.happening),
        SizedBox(
          height: 8.w,
        ),
        _labelValueText('Hiện trường sau sự cố: ', reportModel.scene)
      ],
    );
  }

  Widget _devicesWidget(BuildContext context) {
    final titleStyle = TextStyle(
        fontWeight: FontWeight.bold, fontSize: 20.sp, color: Colors.blue[600]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'DANH SÁCH VẬT TƯ (${reportModel.deviceTotal()})',
          style: titleStyle,
        ),
        SizedBox(
          height: 8.w,
        ),
        _deviceItem('STT', 'Tên vật tư', 'SL', 'Tình trạng', 'Thu/Lắp', true),
        if (reportModel.devices != null)
          Column(
            children: List.generate(
                reportModel.devices!.length,
                (index) => _deviceItem(
                    '${index + 1}',
                    reportModel.devices?[index].name ?? '',
                    reportModel.devices?[index].count.toString() ?? '0',
                    reportModel.devices?[index].state ?? '',
                    reportModel.devices?[index].actionString ?? '')),
          )
      ],
    );
  }

  Widget _deviceItem(
      String stt, String name, String count, String state, String action,
      [bool isMenu = false]) {
    final style = TextStyle(
        fontSize: 18.sp,
        fontWeight: isMenu ? FontWeight.bold : null,
        color: isMenu ? Colors.blue : null);

    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.w),
      child: Row(
        children: [
          Expanded(
            flex: 1,
            child: Text(
              stt,
              style: style,
            ),
          ),
          SizedBox(
            width: 8.w,
          ),
          Expanded(
            flex: 3,
            child: Text(
              name,
              style: style,
            ),
          ),
          Expanded(
            flex: 1,
            child: Text(
              count,
              style: style,
            ),
          ),
          SizedBox(
            width: 8.w,
          ),
          Expanded(
            flex: 3,
            child: Text(
              state,
              style: style,
            ),
          ),
          SizedBox(
            width: 8.w,
          ),
          Expanded(
            flex: 1,
            child: Text(
              action,
              textAlign: TextAlign.end,
              style: style,
            ),
          ),
        ],
      ),
    );
  }

  Widget _conclude(BuildContext context) {
    final titleStyle = TextStyle(
        fontWeight: FontWeight.bold, fontSize: 20.sp, color: Colors.blue[600]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'TỔNG KẾT',
          style: titleStyle,
        ),
        SizedBox(
          height: 16.w,
        ),
        _labelValueText('Ảnh hiện trường sự cố: '),
        SizedBox(
          height: 8.w,
        ),
        _imagesWidget(
            context, reportModel.beforeImages, reportModel.beforeImageURLs),
        SizedBox(
          height: 8.w,
        ),
        _labelValueText('Ảnh sau sự cố: '),
        SizedBox(
          height: 8.w,
        ),
        _imagesWidget(
            context, reportModel.beforeImages, reportModel.finishedImageURLs),
        _dividerWidget(),
        _labelValueText('Phán đoán nguyên nhân: ', reportModel.resolveReason),
        SizedBox(
          height: 8.w,
        ),
        _labelValueText(
            'Biện pháp, thời gian xử lý: ', reportModel.resolveMeasure),
        SizedBox(
          height: 8.w,
        ),
        _labelValueText('Kết luận: ', reportModel.conclude),
      ],
    );
  }

  Widget _relatedSignWidget(BuildContext context) {
    final titleStyle = TextStyle(
        fontWeight: FontWeight.bold, fontSize: 20.sp, color: Colors.blue[600]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ĐẠI DIỆN GÂY RA SỰ CỐ',
          style: titleStyle,
        ),
        SizedBox(
          height: 8.w,
        ),
        _containerHasPicture(
            context: context,
            url: reportModel.relatedUnitSignURL,
            image: reportModel.relatedUnitSign)
      ],
    );
  }

  Widget _regionSignWidget(BuildContext context) {
    final titleStyle = TextStyle(
        fontWeight: FontWeight.bold, fontSize: 20.sp, color: Colors.blue[600]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ĐẠI DIỆN CHÍNH QUYỀN ĐỊA PHƯƠNG',
          style: titleStyle,
        ),
        SizedBox(
          height: 8.w,
        ),
        _containerHasPicture(
            context: context,
            url: reportModel.regionUnitSignURL,
            image: reportModel.regionUnitSign)
      ],
    );
  }

  Widget _electricitySignWidget(BuildContext context) {
    final titleStyle = TextStyle(
        fontWeight: FontWeight.bold, fontSize: 20.sp, color: Colors.blue[600]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'ĐẠI DIỆN QUẢN LÝ VẬN HÀNH',
          style: titleStyle,
        ),
        SizedBox(
          height: 8.w,
        ),
        _containerHasPicture(
            context: context,
            url: reportModel.electricityUnitSignURL,
            image: reportModel.electricityUnitSign)
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

  Widget _labelValueText(String? label, [String? value]) {
    final labelStyle = body.copyWith(fontSize: 16.sp);
    final valueStyle =
        labelStyle.copyWith(fontWeight: FontWeight.w600, color: Colors.black);

    return RichText(
        text: TextSpan(
            style: labelStyle,
            text: label,
            children: [TextSpan(style: valueStyle, text: value)]));
  }

  Widget _containerHasPicture(
      {required BuildContext context, String? url, Uint8List? image}) {
    final isPreview = type == DETAIL_VIEW.PREVIEW;

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
