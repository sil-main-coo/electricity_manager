import 'dart:typed_data';

import 'package:electricity_manager/di/locator.dart';
import 'package:electricity_manager/screens/components/app_field.dart';
import 'package:electricity_manager/screens/components/floating_button_widget.dart';
import 'package:electricity_manager/screens/components/layout_have_floating_button.dart';
import 'package:electricity_manager/screens/components/picker_image_bottomsheet.dart';
import 'package:electricity_manager/utils/commons/text_styles.dart';
import 'package:electricity_manager/utils/helpers/image_picker_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum ConcludePictures { BEFORE, AFTER, SIGN }

class ResolveConcludePage extends StatefulWidget {
  const ResolveConcludePage(
      {Key? key, required this.nextCallback, required this.backCallback})
      : super(key: key);

  final Function(List<Uint8List> beforeImages, List<Uint8List> finishedImages,
      Uint8List signImage, String resolveMeasure, String conclude) nextCallback;
  final Function backCallback;

  @override
  _ResolveConcludePageState createState() => _ResolveConcludePageState();
}

class _ResolveConcludePageState extends State<ResolveConcludePage> {
  final _picker = getIt.get<ImagePickerHelper>();
  final _measureCtrl = TextEditingController();
  final _concludeCtrl = TextEditingController();

  Uint8List? _signPicture;
  List<Uint8List> _beforePictures = [];
  List<Uint8List> _afterPictures = [];

  void _cameraCallback(ConcludePictures type) async {
    final xfile = await _picker.imgFromCamera();
    if (xfile != null) {
      final picture = await xfile.readAsBytes();
      setState(() {
        switch (type) {
          case ConcludePictures.BEFORE:
            _beforePictures.add(picture);
            return;
          case ConcludePictures.AFTER:
            _afterPictures.add(picture);
            return;
          default:
            _signPicture = picture;
        }
      });
    }
  }

  void _galleryCallback(ConcludePictures type) async {
    final xfile = await _picker.imgFromGallery();
    if (xfile != null) {
      final picture = await xfile.readAsBytes();
      setState(() {
        switch (type) {
          case ConcludePictures.BEFORE:
            _beforePictures.add(picture);
            return;
          case ConcludePictures.AFTER:
            _afterPictures.add(picture);
            return;
          default:
            _signPicture = picture;
        }
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
        title: Column(
          children: [
            Text(
              'Xử lý sự cố',
              style: titleWhite.copyWith(fontSize: 20.sp),
            ),
            SizedBox(
              height: 4.w,
            ),
            Text(
              'Kết luận',
              style: caption.copyWith(fontSize: 14.sp),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: LayoutHaveFloatingButton(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _pictures(ConcludePictures.BEFORE),
            SizedBox(
              height: 24.w,
            ),
            _pictures(ConcludePictures.AFTER),
            SizedBox(
              height: 24.w,
            ),
            _fields(),
            SizedBox(
              height: 24.w,
            ),
            _signImage(),
          ],
        ),
      ),
      floatingActionButton: FloatingButtonWidget(
        onPressed: () {
          if (_beforePictures.isNotEmpty &&
              _afterPictures.isNotEmpty &&
              _signPicture != null) {
            widget.nextCallback(_beforePictures, _afterPictures, _signPicture!,
                _measureCtrl.text.trim(), _concludeCtrl.text.trim());
          }
        },
        label: 'Tiếp tục',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _fields() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Biện pháp và thời gian xử lý'.toUpperCase(),
          style: Theme.of(context).textTheme.headline6?.copyWith(
              color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 20.sp),
        ),
        SizedBox(
          height: 8.w,
        ),
        SizedBox(
          height: 150.h,
          child: AppField(
            controller: _measureCtrl,
            autoFocus: true,
            isMultiLine: true,
            keyboardType: TextInputType.multiline,
            hintText: 'Biện pháp và thời gian xử lý sự cố...',
          ),
        ),
        SizedBox(
          height: 24.w,
        ),
        Text(
          'Kết luận'.toUpperCase(),
          style: Theme.of(context).textTheme.headline6?.copyWith(
              color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 20.sp),
        ),
        SizedBox(
          height: 8.w,
        ),
        SizedBox(
          height: 150.h,
          child: AppField(
            controller: _concludeCtrl,
            autoFocus: true,
            isMultiLine: true,
            keyboardType: TextInputType.multiline,
            hintText: 'Kết luận sự cố...',
          ),
        ),
      ],
    );
  }

  Widget _signImage() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Ảnh xác nhận chữ ký: ',
          style: body.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),
        SizedBox(
          height: 16.h,
        ),
        _aPictureContainer(),
        SizedBox(
          height: 8.h,
        ),
        if (_signPicture == null)
          Text(
            'Thiếu ảnh',
            style: body.copyWith(fontSize: 11.sp, color: Colors.red),
          ),
      ],
    );
  }

  Widget _pictures(ConcludePictures electricPictures) {
    final label = electricPictures == ConcludePictures.BEFORE
        ? 'Ảnh hiện trường sự cố'.toUpperCase()
        : 'Ảnh sau sự cố'.toUpperCase();
    final pictures = electricPictures == ConcludePictures.BEFORE
        ? _beforePictures
        : _afterPictures;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 16.h,
        ),
        Text(
          label,
          style: Theme.of(context).textTheme.headline6?.copyWith(
              color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 20.sp),
        ),
        SizedBox(
          height: 16.h,
        ),
        _picturesContainer(electricPictures),
        SizedBox(
          height: 8.h,
        ),
        if (pictures.isEmpty)
          Text(
            'Thiếu ảnh',
            style: body.copyWith(fontSize: 11.sp, color: Colors.red),
          ),
      ],
    );
  }

  Widget _aPictureContainer() {
    if (_signPicture == null) {
      return _pictureEmptyContainer(ConcludePictures.SIGN);
    }

    return _containerHasPicture(_signPicture!);
  }

  Widget _picturesContainer(ConcludePictures type) {
    final pictures =
        type == ConcludePictures.BEFORE ? _beforePictures : _afterPictures;
    final countPicture = pictures.length;
    final space = SizedBox(
      width: 8.w,
    );
    List<Widget> widgets = [];

    if (countPicture == 0) {
      widgets.add(_pictureEmptyContainer(type));
      widgets.add(space);
      widgets.add(_pictureEmptyContainer(type));
      widgets.add(space);
      widgets.add(_pictureEmptyContainer(type));
    } else {
      pictures.forEach((picture) {
        widgets.add(_containerHasPicture(picture));
        widgets.add(space);
      });

      for (int i = 0; i < 3 - countPicture; i++) {
        widgets.add(_pictureEmptyContainer(type));
        widgets.add(space);
      }
    }

    return Row(
      children: widgets,
    );
  }

  Widget _pictureEmptyContainer(ConcludePictures type) {
    return GestureDetector(
      onTap: () => PickerImageBottomSheet.show(
          context: context,
          cameraCallback: () => _cameraCallback(type),
          galleryCallback: () => _galleryCallback(type)),
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
