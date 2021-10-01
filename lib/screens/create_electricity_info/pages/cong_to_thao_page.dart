import 'dart:typed_data';

import 'package:electricity_manager/commons/text_styles.dart';
import 'package:electricity_manager/di/locator.dart';
import 'package:electricity_manager/screens/components/app_field.dart';
import 'package:electricity_manager/screens/components/floating_button_widget.dart';
import 'package:electricity_manager/screens/components/picker_image_bottomsheet.dart';
import 'package:electricity_manager/utils/helpers/image_picker_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CongToThaoPage extends StatefulWidget {
  const CongToThaoPage(
      {Key? key, required this.nextCallback, required this.backCallback})
      : super(key: key);

  final Function(String, String, String, List<Uint8List>) nextCallback;
  final Function backCallback;

  @override
  _CongToThaoPageState createState() => _CongToThaoPageState();
}

class _CongToThaoPageState extends State<CongToThaoPage> {
  final _maCongToCtrl = TextEditingController();
  final _soCongToCtrl = TextEditingController();
  final _chiSoThaoCtrl = TextEditingController();

  final _maCongToNode = FocusNode();
  final _soCongToNode = FocusNode();
  final _chiSoThaoNode = FocusNode();

  final _formKey = GlobalKey<FormState>(debugLabel: 'congtothao');
  final _picker = getIt.get<ImagePickerHelper>();

  List<Uint8List> _pictures = [];

  void _cameraCallback() async {
    final xfile = await _picker.imgFromCamera();
    if (xfile != null) {
      final picture = await xfile.readAsBytes();
      setState(() {
        _pictures.add(picture);
      });
    }
  }

  void _galleryCallback() async {
    final xfile = await _picker.imgFromGallery();
    if (xfile != null) {
      final picture = await xfile.readAsBytes();
      setState(() {
        _pictures.add(picture);
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
          'Công tơ tháo',
          style: titleWhite.copyWith(fontSize: 22.sp),
        ),
        centerTitle: true,
      ),
      body: _buildBody(),
      floatingActionButton: FloatingButtonWidget(
        onPressed: () {
          if (_formKey.currentState!.validate() && _pictures.isNotEmpty) {
            FocusScope.of(context).unfocus();
            widget.nextCallback(
                _maCongToCtrl.text.trim(),
                _soCongToCtrl.text.trim(),
                _chiSoThaoCtrl.text.trim(),
                _pictures);
          }
        },
        label: 'Tiếp tục',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildBody() {
    return SingleChildScrollView(
      child: Padding(
        padding: EdgeInsets.all(16.w),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AppField(
                controller: _maCongToCtrl,
                fcNode: _maCongToNode,
                nextFcNode: _soCongToNode,
                // autoFocus: true,
                textInputAction: TextInputAction.next,
                label: 'Mã công tơ:',
                hintText: 'Nhập mã công tơ tháo',
              ),
              AppField(
                controller: _soCongToCtrl,
                label: 'Số công tơ:',
                fcNode: _soCongToNode,
                nextFcNode: _chiSoThaoNode,
                textInputAction: TextInputAction.next,
                keyboardType: TextInputType.number,
                hintText: 'Nhập số công tơ tháo',
              ),
              AppField(
                controller: _chiSoThaoCtrl,
                textInputAction: TextInputAction.done,
                keyboardType: TextInputType.number,
                fcNode: _chiSoThaoNode,
                label: 'Chỉ số tháo hữu công:',
                hintText: 'Nhập chỉ số tháo hữu công',
              ),
              _pictureContainer()
            ],
          ),
        ),
      ),
    );
  }

  Widget _pictureContainer() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          height: 16.h,
        ),
        Text(
          'Ảnh công tơ tháo: ',
          style: body.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w600),
        ),
        SizedBox(
          height: 16.h,
        ),
        _picturesContainer(),
        SizedBox(
          height: 8.h,
        ),
        if (_pictures.isEmpty)
          Text(
            'Thiếu ảnh',
            style: body.copyWith(fontSize: 11.sp, color: Colors.red),
          ),
      ],
    );
  }

  Widget _picturesContainer() {
    final countPicture = _pictures.length;
    final space = SizedBox(
      width: 8.w,
    );
    List<Widget> widgets = [];

    if (countPicture == 0) {
      widgets.add(_pictureEmptyContainer());
      widgets.add(space);
      widgets.add(_pictureEmptyContainer());
      widgets.add(space);
      widgets.add(_pictureEmptyContainer());
    } else {
      _pictures.forEach((picture) {
        widgets.add(_containerHasPicture(picture));
        widgets.add(space);
      });

      for (int i = 0; i < 3 - countPicture; i++) {
        widgets.add(_pictureEmptyContainer());
        widgets.add(space);
      }
    }

    return Row(
      children: widgets,
    );
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
