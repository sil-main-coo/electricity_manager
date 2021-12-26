import 'dart:typed_data';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:electricity_manager/models/electricity_model.dart';
import 'package:electricity_manager/models/take_back_report_model.dart';
import 'package:electricity_manager/screens/components/hero_photo_view_screen.dart';
import 'package:electricity_manager/screens/components/layout_have_floating_button.dart';
import 'package:electricity_manager/utils/commons/text_styles.dart';
import 'package:electricity_manager/utils/enums/detail_view_enum.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter/material.dart';

class TakeBackDetailLayout extends StatelessWidget {
  const TakeBackDetailLayout(
      {Key? key, required this.reportModel, required this.type})
      : super(key: key);

  final TakeBackReportModel reportModel;
  final DETAIL_VIEW type;

  @override
  Widget build(BuildContext context) {
    return LayoutHaveFloatingButton(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _info(),
          _dividerWidget(),
          _electricityInfoWidget(context),
          _dividerWidget(),
          _devicesWidget(context),
          _dividerWidget(),
          _staffSignWidget(context),
          _dividerWidget(),
          _managerSignWidget(context),
          _dividerWidget(),
          _presidentSignWidget(context),
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
        _labelValueText('Ngày lập biên bản: ', reportModel.createAtString),
        _labelValueText('Mã khách hàng: ', reportModel.clientCode),
        _labelValueText(
            'Họ và tên khách hàng: ', reportModel.clientName?.toUpperCase()),
        _labelValueText('Địa chỉ khách hàng: ', reportModel.clientAddress),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: List.generate(
            reportModel.staffs!.length,
            (index) => _labelValueText(
                'Nhân viên ${reportModel.staffs!.length > 1 ? index + 1 : ''}: ',
                '${reportModel.staffs![index].fullName?.toUpperCase()} (${reportModel.staffs![index].roleString})'),
          ),
        )
      ],
    );
  }

  Widget _electricityInfoWidget(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        _electricInfo('CÔNG TƠ THÁO', reportModel.outputElectric!),
        SizedBox(
          height: 16.w,
        ),
        _electricInfo('CÔNG TƠ TREO', reportModel.hangingElectric!),
        SizedBox(
          height: 20.w,
        ),
        _labelValueText('Ảnh hiện trường sự cố: '),
        SizedBox(
          height: 8.w,
        ),
        _imagesWidget(
            context, reportModel.beforeImages, reportModel.urlBeforeImages),
        SizedBox(
          height: 16.w,
        ),
        _labelValueText('Ảnh sau sự cố: '),
        SizedBox(
          height: 8.w,
        ),
        _imagesWidget(
            context, reportModel.finishedImages, reportModel.urlFinishedImages),
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
          'VẬT TƯ THU HỒI (${reportModel.deviceTotal()})',
          style: titleStyle,
        ),
        SizedBox(
          height: 8.w,
        ),
        _deviceItem('STT', 'Tên vật tư', 'SL', 'Ghi chú', true),
        if (reportModel.devices != null)
          Column(
            children: List.generate(
                reportModel.devices!.length,
                (index) => _deviceItem(
                      '${index + 1}',
                      reportModel.devices?[index].name ?? '',
                      reportModel.devices?[index].count.toString() ?? '0',
                      reportModel.devices?[index].note ?? '',
                    )),
          )
      ],
    );
  }

  Widget _deviceItem(String stt, String name, String count, String note,
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
            width: 16.w,
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
          Expanded(
            flex: 2,
            child: Text(
              note,
              textAlign: TextAlign.end,
              style: style,
            ),
          ),
        ],
      ),
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

  Widget _staffSignWidget(BuildContext context) {
    final titleStyle = TextStyle(
        fontWeight: FontWeight.bold, fontSize: 20.sp, color: Colors.blue[600]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'CHỮ KÝ NHÂN VIÊN',
          style: titleStyle,
        ),
        SizedBox(
          height: 8.w,
        ),
        _containerHasPicture(
            context: context,
            url: reportModel.urlStaffSignImage,
            image: reportModel.staffSignImage)
      ],
    );
  }

  Widget _managerSignWidget(BuildContext context) {
    final titleStyle = TextStyle(
        fontWeight: FontWeight.bold, fontSize: 20.sp, color: Colors.blue[600]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'CHỮ KÝ TRƯỞNG PHÒNG',
          style: titleStyle,
        ),
        SizedBox(
          height: 8.w,
        ),
        _containerHasPicture(
            context: context,
            url: reportModel.urlManagerSignImage,
            image: reportModel.managerSignImage)
      ],
    );
  }

  Widget _presidentSignWidget(BuildContext context) {
    final titleStyle = TextStyle(
        fontWeight: FontWeight.bold, fontSize: 20.sp, color: Colors.blue[600]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'CHỮ KÝ GIÁM ĐỐC',
          style: titleStyle,
        ),
        SizedBox(
          height: 8.w,
        ),
        _containerHasPicture(
            context: context,
            url: reportModel.urlPresidentSignImage,
            image: reportModel.presidentSignImage)
      ],
    );
  }

  Widget _labelValueText(String? label,
      [String? value, bool labelBold = false]) {
    final labelStyle = body.copyWith(
        fontSize: 16.sp, fontWeight: labelBold ? FontWeight.w600 : null);
    final valueStyle = labelStyle.copyWith(
        fontWeight: FontWeight.w600, color: Colors.blueAccent);

    return RichText(
        text: TextSpan(
            style: labelStyle,
            text: label,
            children: [TextSpan(style: valueStyle, text: ' ${value ?? ''}')]));
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

  Widget _electricInfo(String title, ElectricModel electric) {
    final titleStyle = TextStyle(
        fontWeight: FontWeight.bold, fontSize: 20.sp, color: Colors.blue[600]);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: titleStyle,
        ),
        SizedBox(
          height: 8.w,
        ),
        _labelValueText('Số công tơ: ', electric.electricCode ?? ''),
        SizedBox(
          height: 4.w,
        ),
        _labelValueText('Chỉ số công tơ: ', electric.electricValue ?? ''),
        SizedBox(
          height: 16.w,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _labelValueText('CHIỀU GIAO', '', true),
                  SizedBox(
                    height: 8.w,
                  ),
                  _labelValueText(
                      'Giờ bình thường: ', electric.normalTime?.ship ?? ''),
                  SizedBox(
                    height: 4.w,
                  ),
                  _labelValueText(
                      'Giờ cao điểm:', '${electric.highTime?.ship ?? ''}'),
                  SizedBox(
                    height: 4.w,
                  ),
                  _labelValueText(
                      'Giờ thấp điểm:', '${electric.lowTime?.ship ?? ''}'),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 2),
              child: VerticalDivider(
                width: 1,
                color: Colors.blue,
              ),
            ),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _labelValueText('CHIỀU NHẬN', '', true),
                  SizedBox(
                    height: 8.w,
                  ),
                  _labelValueText(
                      'Giờ bình thường: ', electric.normalTime?.receive ?? ''),
                  SizedBox(
                    height: 4.w,
                  ),
                  _labelValueText(
                      'Giờ cao điểm:', '${electric.highTime?.receive ?? ''}'),
                  SizedBox(
                    height: 4.w,
                  ),
                  _labelValueText(
                      'Giờ thấp điểm:', '${electric.lowTime?.receive ?? ''}'),
                ],
              ),
            )
          ],
        )
      ],
    );
  }
}
