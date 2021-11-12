import 'package:electricity_manager/app_bloc/bloc.dart';
import 'package:electricity_manager/di/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../app_textfield.dart';

class AuthenDialog {
  static void show(BuildContext context, Function authenticatedCallback) {
    showDialog(
        context: context,
        builder: (_) => AuthDialogLayout(
              authenticatedCallback: authenticatedCallback,
            ));
  }
}

class AuthDialogLayout extends StatefulWidget {
  const AuthDialogLayout({Key? key, required this.authenticatedCallback})
      : super(key: key);

  final Function authenticatedCallback;

  @override
  _AuthDialogLayoutState createState() => _AuthDialogLayoutState();
}

class _AuthDialogLayoutState extends State<AuthDialogLayout> {
  final _passwordController = TextEditingController();

  final _formKey = GlobalKey<FormState>();
  final _appBloc = getIt.get<AppBloc>();

  String? _errorText;

  void _continue() {
    if (_formKey.currentState!.validate()) {
      final pwd = _passwordController.text.trim();
      if (_appBloc.user?.password == pwd) {
        setState(() {
          _errorText = null;
          widget.authenticatedCallback();
        });
      } else {
        setState(() {
          _errorText = 'Mật khẩu không đúng. Vui lòng thử lại';
        });
      }
    }
  }

  @override
  void dispose() {
    super.dispose();
    _passwordController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Nhập mật khẩu để tiếp tục'),
      content: Form(
        key: _formKey,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            AppTextField.tfOnBody(context, _passwordController, 'Mật khẩu',
                TextInputAction.done, false,
                obscureText: true, errorText: _errorText, autoFocus: true),
            SizedBox(
              height: 24.h,
            ),
            RaisedButton(
              onPressed: () => _continue(),
              color: Colors.blue,
              child: Text(
                'Tiếp tục',
                style: TextStyle(color: Colors.white, fontSize: 18.sp),
              ),
            )
          ],
        ),
      ),
    );
  }
}
