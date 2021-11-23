import 'dart:typed_data';
import 'package:electricity_manager/di/locator.dart';
import 'package:electricity_manager/screens/components/floating_button_widget.dart';
import 'package:electricity_manager/screens/components/layout_have_floating_button.dart';
import 'package:electricity_manager/screens/components/picker_image_bottomsheet.dart';
import 'package:electricity_manager/utils/commons/text_styles.dart';
import 'package:electricity_manager/utils/helpers/image_picker_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum AdditionalPictures { SIGN_CUSTOMER, SIGN_STAFF }

class AdditionalPage extends StatefulWidget {
  const AdditionalPage(
      {Key? key, required this.nextCallback, required this.backCallback})
      : super(key: key);

  final Function(Uint8List, Uint8List) nextCallback;
  final Function backCallback;

  @override
  _AdditionalPageState createState() => _AdditionalPageState();
}

class _AdditionalPageState extends State<AdditionalPage> {
  final _picker = getIt.get<ImagePickerHelper>();

  Uint8List? _signCustomerPicture, _signStaffPicture;

  void _cameraCallback(AdditionalPictures additionalPictures) async {
    final xfile = await _picker.imgFromCamera();
    if (xfile != null) {
      final picture = await xfile.readAsBytes();
      setState(() {
        additionalPictures == AdditionalPictures.SIGN_CUSTOMER
            ? _signCustomerPicture = picture
            : _signStaffPicture = picture;
      });
    }
  }

  void _galleryCallback(AdditionalPictures additionalPictures) async {
    final xfile = await _picker.imgFromGallery();
    if (xfile != null) {
      final picture = await xfile.readAsBytes();
      setState(() {
        additionalPictures == AdditionalPictures.SIGN_CUSTOMER
            ? _signCustomerPicture = picture
            : _signStaffPicture = picture;
      });
    }
  }

  void _next() {
    if (_signCustomerPicture != null && _signStaffPicture != null) {
      widget.nextCallback(_signCustomerPicture!, _signStaffPicture!);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => widget.backCallback(),
        ),
        title: Column(
          children: [
            Text(
              'Thu hồi công tơ',
              style: titleWhite.copyWith(fontSize: 20.sp),
            ),
            SizedBox(
              height: 4.w,
            ),
            Text(
              'Xác nhận',
              style: caption.copyWith(fontSize: 14.sp),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: _buildBody(),
      floatingActionButton: FloatingButtonWidget(
        onPressed: _next,
        label: 'Tiếp tục',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildBody() {
    return LayoutHaveFloatingButton(
      child: Column(
        children: [
          _pictureContainer(AdditionalPictures.SIGN_CUSTOMER),
          SizedBox(
            height: 24.w,
          ),
          _pictureContainer(AdditionalPictures.SIGN_STAFF)
        ],
      ),
    );
  }

  Widget _pictureContainer(AdditionalPictures additionalPictures) {
    final label = additionalPictures == AdditionalPictures.SIGN_CUSTOMER
        ? 'Ảnh chữ ký khách hàng'
        : 'Ảnh chữ ký nhân viên';
    final picture = additionalPictures == AdditionalPictures.SIGN_CUSTOMER
        ? _signCustomerPicture
        : _signStaffPicture;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: body.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),
        SizedBox(
          height: 16.h,
        ),
        picture == null
            ? _pictureEmptyContainer(additionalPictures)
            : _containerHasPicture(picture),
        SizedBox(
          height: 8.h,
        ),
        if (picture == null)
          Text(
            'Thiếu ảnh',
            style: body.copyWith(fontSize: 11.sp, color: Colors.red),
          ),
      ],
    );
  }

  Widget _pictureEmptyContainer(AdditionalPictures additionalPictures) {
    return GestureDetector(
      onTap: () => PickerImageBottomSheet.show(
          context: context,
          cameraCallback: () => _cameraCallback(additionalPictures),
          galleryCallback: () => _galleryCallback(additionalPictures)),
      child: Container(
        height: 100.w,
        width: 100.w,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8.w),
            border: Border.all(color: Colors.lightBlue)),
        alignment: Alignment.center,
        child: Icon(
          Icons.add,
          color: Colors.blue,
        ),
      ),
    );
  }

  Widget _containerHasPicture(Uint8List picture) {
    return SizedBox(
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
          child: Image.memory(
            picture,
            height: 100.w,
            width: 100.w,
            fit: BoxFit.fill,
          ),
        ),
      ),
    );
  }
}
