import 'package:electricity_manager/app_bloc/app_bloc.dart';
import 'package:electricity_manager/data/remote/auth_remote_provider.dart';
import 'package:electricity_manager/di/locator.dart';
import 'package:electricity_manager/models/user.dart';
import 'package:electricity_manager/screens/components/dialogs/dialogs.dart';
import 'package:electricity_manager/screens/components/layout_have_floating_button.dart';
import 'package:electricity_manager/utils/values/colors.dart';
import 'package:electricity_manager/utils/values/text_styles.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'create_account_screen.dart';

class ManagerAccountScreen extends StatelessWidget {
  final appBloc = getIt.get<AppBloc>();

  Future _removeAccount(BuildContext context, User account) async {
    try {
      await getIt.get<AuthRemoteProvider>().removeUser(account.profile!.id!);
      Navigator.pop(context);
    } catch (e) {
      Navigator.pop(context);
      AppDialog.showNotifyDialog(
          context: context,
          mess: e.toString(),
          textBtn: 'OK',
          function: () => Navigator.pop(context),
          color: secondary);
    }
  }

  void _showRemoveAccountDialog(BuildContext context, User account) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              content: Text('Đồng ý xóa tài khoản ${account.useName}?'),
              actions: [
                RaisedButton(
                  onPressed: () async => await _removeAccount(context, account),
                  child: Text(
                    'ĐỒNG Ý',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.redAccent,
                ),
                RaisedButton(
                    onPressed: () => Navigator.pop(context), child: Text('HỦY'))
              ],
            ));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Danh sách nhân viên',
          style: titleWhite.copyWith(fontSize: 22.sp),
        ),
        centerTitle: true,
      ),
      body: StreamBuilder<Event>(
        stream: getIt.get<AuthRemoteProvider>().streamData(),
        builder: (context, snapshot) {
          List<User> result = [];
          if (snapshot.hasData) {
            final Map profilesData = snapshot.data?.snapshot.value;

            profilesData.forEach((key, value) {
              result.add(User.fromJson(Map<String, dynamic>.from(value), key));
            });
            return _buildScreen(result);
          }
          return Center(
            child: const CircularProgressIndicator(),
          );
        },
      ),
      floatingActionButton: appBloc.isAdmin
          ? FloatingActionButton(
              child: Icon(Icons.add),
              onPressed: () => Navigator.push(context,
                  MaterialPageRoute(builder: (_) => CreateAccountScreen())),
            )
          : null,
    );
  }

  Widget _buildScreen(List<User> users) {
    if (users.isEmpty)
      return Center(
        child: Text('Danh sách trống. Hãy thêm tài khoản mới'),
      );

    return LayoutHaveFloatingButton(
      child: ListView.separated(
          shrinkWrap: true,
          primary: false,
          itemBuilder: (context, index) => _item(context, users[index]),
          separatorBuilder: (_, __) => Divider(),
          itemCount: users.length),
    );
  }

  Widget _item(context, User data) {
    final isAdmin = data.useName == 'admin';

    final titleStyle = TextStyle(
        fontSize: 16.sp, fontWeight: FontWeight.normal, color: Colors.black);
    final valueStyle = TextStyle(
        fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.blue);

    return ListTile(
      leading: Icon(Icons.account_circle),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
              text: TextSpan(style: titleStyle, text: 'Họ và tên: ', children: [
            TextSpan(
                text: '${data.profile?.fullName.toString()}', style: valueStyle)
          ])),
          if (appBloc.isAdmin)
            RichText(
                text: TextSpan(
                    style: titleStyle,
                    text: 'Tên tài khoản: ',
                    children: [
                  TextSpan(text: data.useName, style: valueStyle)
                ])),
          RichText(
              text: TextSpan(
                  style: titleStyle,
                  text: 'Số điện thoại: ',
                  children: [
                TextSpan(
                    text: data.profile?.phone ?? 'Chưa cập nhật',
                    style: valueStyle)
              ])),
        ],
      ),
      trailing: isAdmin || !appBloc.isAdmin
          ? null
          : IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.red,
              ),
              onPressed: () => _showRemoveAccountDialog(context, data),
            ),
    );
  }
}
