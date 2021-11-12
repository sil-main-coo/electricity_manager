import 'package:electricity_manager/data/remote/auth_remote_provider.dart';
import 'package:electricity_manager/di/locator.dart';
import 'package:electricity_manager/models/user.dart';
import 'package:electricity_manager/screens/components/app_field.dart';
import 'package:electricity_manager/screens/components/dialogs/dialogs.dart';
import 'package:electricity_manager/screens/components/floating_button_widget.dart';
import 'package:electricity_manager/utils/values/colors.dart';
import 'package:electricity_manager/utils/values/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CreateAccountScreen extends StatelessWidget {
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

  Future saveAccount(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();

      final user = User(
        profile: UserProfile(
          fullName: _fullNameCtrl.text.trim(),
          phone: _phoneCtrl.text.trim()
        ),
        useName: _accountNameCtrl.text.trim(),
        password: _passwordCtrl.text.trim(),
      );

      try {
        await getIt.get<AuthRemoteProvider>().addNewUserToDB(user);
        Navigator.pop(context);
      } catch (e) {
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
              )
            ],
          ),
        ),
      ),
    );
  }
}
