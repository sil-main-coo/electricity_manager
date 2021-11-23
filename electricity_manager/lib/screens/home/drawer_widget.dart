import 'package:electricity_manager/app_bloc/bloc.dart';
import 'package:electricity_manager/di/locator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:electricity_manager/screens/manager_account/manager_account_screen.dart';

class DrawerWidget extends StatelessWidget {
  DrawerWidget({Key? key}) : super(key: key);

  final appBloc = getIt.get<AppBloc>();

  void _signOutDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              content: Text('Bạn sẽ đăng xuất?'),
              actions: [
                RaisedButton(
                  onPressed: () {
                    BlocProvider.of<AppBloc>(context).add(LogOuted());
                    Navigator.pop(context);
                  },
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
    return SafeArea(
      child: Drawer(
        child: Column(
          children: [
            DrawerHeader(
              child: Container(
                color: Colors.blue,
                padding: EdgeInsets.all(16.w),
                child: Row(
                  children: [
                    CircleAvatar(
                      child: Icon(
                        Icons.person,
                        size: 32.w,
                      ),
                      radius: 42.w,
                    ),
                    SizedBox(
                      width: 16.w,
                    ),
                    Expanded(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              appBloc.user?.profile?.fullName ?? '',
                              maxLines: 2,
                              style: TextStyle(
                                  fontSize: 26.sp,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              'Tài khoản: ${appBloc.user?.useName}',
                              maxLines: 2,
                              style: TextStyle(
                                  fontSize: 18.sp, color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              padding: EdgeInsets.zero,
            ),
            Expanded(
              child: Column(
                children: [
                  ListTile(
                    onTap: () => _signOutDialog(context),
                    leading: Icon(Icons.logout),
                    title: Text(
                      'Đăng xuất',
                      style: TextStyle(fontSize: 18.w),
                    ),
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}
