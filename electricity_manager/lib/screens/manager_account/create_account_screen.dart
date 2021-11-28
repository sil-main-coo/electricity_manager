import 'dart:typed_data';

import 'package:electricity_manager/data/remote/auth_remote_provider.dart';
import 'package:electricity_manager/di/locator.dart';
import 'package:electricity_manager/models/user.dart';
import 'package:electricity_manager/screens/components/app_field.dart';
import 'package:electricity_manager/screens/components/dialogs/dialogs.dart';
import 'package:electricity_manager/screens/components/dialogs/loading_dialog.dart';
import 'package:electricity_manager/screens/components/floating_button_widget.dart';
import 'package:electricity_manager/screens/components/picker_image_bottomsheet.dart';
import 'package:electricity_manager/utils/helpers/image_picker_helper.dart';
import 'package:electricity_manager/utils/values/colors.dart';
import 'package:electricity_manager/utils/values/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreateAccountScreen extends StatefulWidget {
  @override
  _CreateAccountScreenState createState() => _CreateAccountScreenState();
}

class _CreateAccountScreenState extends State<CreateAccountScreen> {
  final _fullNameCtrl = TextEditingController();

  final _phoneCtrl = TextEditingController();

  final _accountNameCtrl = TextEditingController();

  final _passwordCtrl = TextEditingController();

  final _confirmPasswordCtrl = TextEditingController();

  final _phoneNode = FocusNode();

  final _accountNameNode = FocusNode();

  final _passwordNode = FocusNode();

  final _confirmPasswordNode = FocusNode();

  final _formKey = GlobalKey<FormState>(debugLabel: 'create-account');

  final _picker = getIt.get<ImagePickerHelper>();
  final _authProvider = getIt.get<AuthRemoteProvider>();

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

  Future saveAccount(BuildContext context) async {
    if (_formKey.currentState!.validate() && _signPicture != null) {
      LoadingDialog.show(context);
      FocusScope.of(context).unfocus();

      final user = User(
        profile: UserProfile(
            fullName: _fullNameCtrl.text.trim(), phone: _phoneCtrl.text.trim()),
        useName: _accountNameCtrl.text.trim(),
        password: _passwordCtrl.text.trim(),
      );

      try {
        final newUser = await _authProvider.addNewUserToDB(user);
        final urlImage = await _authProvider.uploadImageToStorage(
            newUser!.profile!.id!, 'chu-ky.jpg', _signPicture!);

        if (urlImage != null) {
          newUser.profile?.signImageURL = urlImage;
          _authProvider.updateUseProfileOnDB(
              newUser.profile!.id!, newUser.profile!.toImagesJson());
        }
        LoadingDialog.hide(context);
        Navigator.pop(context);
      } catch (e) {
        LoadingDialog.hide(context);
        AppDialog.showNotifyDialog(
            context: context,
            mess: e.toString(),
            textBtn: 'OK',
            function: () => Navigator.pop(context),
            color: secondary);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Thêm tài khoản',
          style: titleWhite.copyWith(fontSize: 22.sp),
        ),
        centerTitle: true,
      ),
      body: _buildBody(),
      floatingActionButton: FloatingButtonWidget(
        onPressed: () => saveAccount(context),
        label: 'Lưu lại',
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
                controller: _fullNameCtrl,
                nextFcNode: _phoneNode,
                autoFocus: true,
                isName: true,
                textInputAction: TextInputAction.next,
                label: 'Họ và tên:',
                hintText: 'Nhập họ và tên',
              ),
              AppField(
                controller: _phoneCtrl,
                fcNode: _phoneNode,
                nextFcNode: _accountNameNode,
                isName: true,
                keyboardType: TextInputType.phone,
                textInputAction: TextInputAction.next,
                label: 'Số điện thoại:',
                hintText: 'Nhập sđt',
              ),
              AppField(
                controller: _accountNameCtrl,
                label: 'Tên tài khoản:',
                fcNode: _accountNameNode,
                nextFcNode: _passwordNode,
                textInputAction: TextInputAction.next,
                hintText: 'Nhập tên tài khoản',
              ),
              AppField(
                controller: _passwordCtrl,
                textInputAction: TextInputAction.done,
                fcNode: _passwordNode,
                nextFcNode: _confirmPasswordNode,
                obscureText: true,
                label: 'Mật khẩu:',
                hintText: 'Nhập mật khẩu',
                validator: (value) {
                  if (value == null || value.isEmpty || value.length < 6) {
                    return 'Mật khẩu phải từ 6 ký tự trở lên';
                  }
                },
              ),
              AppField(
                controller: _confirmPasswordCtrl,
                textInputAction: TextInputAction.done,
                fcNode: _confirmPasswordNode,
                obscureText: true,
                label: 'Nhập lại mật khẩu:',
                hintText: 'Nhập lại mật khẩu',
                validator: (value) {
                  if (value == null || value.isEmpty || value.length < 6) {
                    return 'Mật khẩu phải từ 6 ký tự trở lên';
                  }

                  if (value != _passwordCtrl.text.trim()) {
                    return 'Mật khẩu chưa khớp';
                  }
                },
              ),
              SizedBox(
                height: 8.h,
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
        Text(
          'Ảnh chữ ký nhân viên: ',
          style: body.copyWith(fontSize: 16.sp, fontWeight: FontWeight.w600),
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
