import 'dart:typed_data';

import 'package:electricity_manager/commons/text_styles.dart';
import 'package:electricity_manager/di/locator.dart';
import 'package:electricity_manager/screens/components/floating_button_widget.dart';
import 'package:electricity_manager/screens/components/picker_image_bottomsheet.dart';
import 'package:electricity_manager/utils/helpers/image_picker_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class AdditionalPage extends StatefulWidget {
  const AdditionalPage(
      {Key? key, required this.nextCallback, required this.backCallback})
      : super(key: key);

  final Function(Uint8List) nextCallback;
  final Function backCallback;

  @override
  _AdditionalPageState createState() => _AdditionalPageState();
}

class _AdditionalPageState extends State<AdditionalPage> {
  final _picker = getIt.get<ImagePickerHelper>();

  Uint8List? _signPicture;

  void _cameraCallback() async {
    final xfile = await _picker.imgFromCamera();
    if (xfile != null) {
      final picture = await xfile.readAsBytes();
      setState(() {
        _signPicture = picture;
      });
    }
  }

  void _galleryCallback() async {
    final xfile = await _picker.imgFromGallery();
    if (xfile != null) {
      final picture = await xfile.readAsBytes();
      setState(() {
        _signPicture = picture;
      });
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
        title: Text(
          'Thông tin bổ sung',
          style: titleWhite.copyWith(fontSize: 22.sp),
        ),
        centerTitle: true,
      ),
      body: _pictureContainer(),
      floatingActionButton: FloatingButtonWidget(
        onPressed: () {
          if (_signPicture != null) {
            widget.nextCallback(_signPicture!);
          }
        },
        label: 'Tiếp tục',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _pictureContainer() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Ảnh xác nhận chữ ký: ',
              style:
                  body.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w600),
            ),
            SizedBox(
              height: 16.h,
            ),
            _picturesContainer(),
            SizedBox(
              height: 8.h,
            ),
            if (_signPicture == null)
              Text(
                'Thiếu ảnh',
                style: body.copyWith(fontSize: 11.sp, color: Colors.red),
              ),
          ],
        ),
      ),
    );
  }

  Widget _picturesContainer() {
    if (_signPicture == null) {
      return _pictureEmptyContainer();
    }

    return _containerHasPicture(_signPicture!);
  }

  Widget _pictureEmptyContainer() {
    return GestureDetector(
      onTap: () => PickerImageBottomSheet.show(
          context: context,
          cameraCallback: _cameraCallback,
          galleryCallback: _galleryCallback),
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
