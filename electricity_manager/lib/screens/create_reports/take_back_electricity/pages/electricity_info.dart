import 'dart:typed_data';

import 'package:electricity_manager/di/locator.dart';
import 'package:electricity_manager/models/electricity_model.dart';
import 'package:electricity_manager/screens/components/app_field.dart';
import 'package:electricity_manager/screens/components/floating_button_widget.dart';
import 'package:electricity_manager/screens/components/layout_have_floating_button.dart';
import 'package:electricity_manager/screens/components/picker_image_bottomsheet.dart';
import 'package:electricity_manager/utils/commons/text_styles.dart';
import 'package:electricity_manager/utils/helpers/image_picker_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

enum ElectricPictures { BEFORE, AFTER }

class ElectricityInfoPage extends StatefulWidget {
  const ElectricityInfoPage(
      {Key? key, required this.nextCallback, required this.backCallback})
      : super(key: key);

  final Function(ElectricModel, ElectricModel, List<Uint8List>, List<Uint8List>)
      nextCallback;
  final Function backCallback;

  @override
  _ElectricityInfoPageState createState() => _ElectricityInfoPageState();
}

class _ElectricityInfoPageState extends State<ElectricityInfoPage> {
  final _electricOutputCodeCtrl = TextEditingController();
  final _electricOutputValueCtrl = TextEditingController();

  final _electricHangingCodeCtrl = TextEditingController();
  final _electricHangingValueCtrl = TextEditingController();

  final _formKey = GlobalKey<FormState>();

  final _picker = getIt.get<ImagePickerHelper>();

  List<Uint8List> _beforePictures = [];
  List<Uint8List> _afterPictures = [];

  void _cameraCallback(ElectricPictures electricPictures) async {
    final xfile = await _picker.imgFromCamera();
    if (xfile != null) {
      final picture = await xfile.readAsBytes();
      setState(() {
        electricPictures == ElectricPictures.BEFORE
            ? _beforePictures.add(picture)
            : _afterPictures.add(picture);
      });
    }
  }

  void _galleryCallback(ElectricPictures electricPictures) async {
    final xfile = await _picker.imgFromGallery();
    if (xfile != null) {
      final picture = await xfile.readAsBytes();
      setState(() {
        electricPictures == ElectricPictures.BEFORE
            ? _beforePictures.add(picture)
            : _afterPictures.add(picture);
      });
    }
  }

  void _next() {
    if (_formKey.currentState!.validate() &&
        _beforePictures.isNotEmpty &&
        _afterPictures.isNotEmpty) {
      FocusScope.of(context).unfocus();
      widget.nextCallback(
          ElectricModel(
            electricCode: _electricOutputCodeCtrl.text.trim(),
            electricValue: _electricOutputValueCtrl.text.trim(),
          ),
          ElectricModel(
            electricCode: _electricHangingCodeCtrl.text.trim(),
            electricValue: _electricHangingValueCtrl.text.trim(),
          ),
          _beforePictures,
          _afterPictures
      );
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
              'Tình trạng công tơ',
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
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _electricityOutput(),
            SizedBox(
              height: 16.w,
            ),
            _electricityHanging(),
            SizedBox(
              height: 24.w,
            ),
            _pictureContainer(ElectricPictures.BEFORE),
            SizedBox(
              height: 24.w,
            ),
            _pictureContainer(ElectricPictures.AFTER),
          ],
        ),
      ),
    );
  }

  Widget _electricityOutput() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Công tơ tháo'.toUpperCase(),
          style: Theme.of(context).textTheme.headline6?.copyWith(
              color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 20.sp),
        ),
        AppField(
          controller: _electricOutputCodeCtrl,
          label: 'Số công tơ:',
          keyboardType: TextInputType.number,
          isRequired: false,
          textInputAction: TextInputAction.done,
          hintText: 'Nhập số công tơ',
        ),
        AppField(
          controller: _electricOutputValueCtrl,
          label: 'Chỉ số:',
          keyboardType: TextInputType.number,
          isRequired: false,
          textInputAction: TextInputAction.done,
          hintText: 'Nhập chỉ số công tơ',
        ),
      ],
    );
  }

  Widget _electricityHanging() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Công tơ treo'.toUpperCase(),
          style: Theme.of(context).textTheme.headline6?.copyWith(
              color: Colors.blue, fontWeight: FontWeight.bold, fontSize: 20.sp),
        ),
        AppField(
          controller: _electricHangingCodeCtrl,
          label: 'Số công tơ:',
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          isRequired: false,
          hintText: 'Nhập số công tơ',
        ),
        AppField(
          controller: _electricHangingValueCtrl,
          label: 'Chỉ số:',
          isRequired: false,
          keyboardType: TextInputType.number,
          textInputAction: TextInputAction.done,
          hintText: 'Nhập chỉ số công tơ',
        ),
      ],
    );
  }

  Widget _pictureContainer(ElectricPictures electricPictures) {
    final label = electricPictures == ElectricPictures.BEFORE
        ? 'Ảnh hiện trường sự cố'
        : 'Ảnh sau sự cố';
    final pictures = electricPictures == ElectricPictures.BEFORE
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
          style: body.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w600),
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

  Widget _picturesContainer(ElectricPictures electricPictures) {
    final pictures = electricPictures == ElectricPictures.BEFORE
        ? _beforePictures
        : _afterPictures;
    final countPicture = pictures.length;
    final space = SizedBox(
      width: 8.w,
    );
    List<Widget> widgets = [];

    if (countPicture == 0) {
      widgets.add(_pictureEmptyContainer(electricPictures));
      widgets.add(space);
      widgets.add(_pictureEmptyContainer(electricPictures));
      widgets.add(space);
      widgets.add(_pictureEmptyContainer(electricPictures));
    } else {
      pictures.forEach((picture) {
        widgets.add(_containerHasPicture(picture));
        widgets.add(space);
      });

      for (int i = 0; i < 3 - countPicture; i++) {
        widgets.add(_pictureEmptyContainer(electricPictures));
        widgets.add(space);
      }
    }

    return Row(
      children: widgets,
    );
  }

  Widget _pictureEmptyContainer(ElectricPictures electricPictures) {
    return GestureDetector(
      onTap: () => PickerImageBottomSheet.show(
          context: context,
          cameraCallback: () => _cameraCallback(electricPictures),
          galleryCallback: () => _galleryCallback(electricPictures)),
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
