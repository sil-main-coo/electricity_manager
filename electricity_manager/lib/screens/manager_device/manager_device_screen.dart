import 'package:electricity_manager/app_bloc/app_bloc.dart';
import 'package:electricity_manager/data/remote/device_remote_provider.dart';
import 'package:electricity_manager/di/locator.dart';
import 'package:electricity_manager/models/device.dart';
import 'package:electricity_manager/screens/components/app_button.dart';
import 'package:electricity_manager/screens/components/app_field.dart';
import 'package:electricity_manager/screens/components/dialogs/dialogs.dart';
import 'package:electricity_manager/screens/components/dialogs/loading_dialog.dart';
import 'package:electricity_manager/screens/components/layout_have_floating_button.dart';
import 'package:electricity_manager/utils/values/colors.dart';
import 'package:electricity_manager/utils/values/text_styles.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ManagerDeviceScreen extends StatefulWidget {
  @override
  _ManagerDeviceScreenState createState() => _ManagerDeviceScreenState();
}

class _ManagerDeviceScreenState extends State<ManagerDeviceScreen> {
  final appBloc = getIt.get<AppBloc>();

  final _deviceProvider = getIt.get<DeviceRemoteProvider>();

  final _deviceNameCtrl = TextEditingController();

  final _formKey = GlobalKey<FormState>(debugLabel: 'create-device');

  Future _removeDevice(BuildContext context, Device device) async {
    try {
      Navigator.pop(context);
      LoadingDialog.show(context);
      await _deviceProvider.removeDevice(device.id!);
      LoadingDialog.hide(context);
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

  void _showRemoveDeviceDialog(BuildContext context, Device device) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              content: Text('Đồng ý xóa vật tư ${device.name}?'),
              actions: [
                RaisedButton(
                  onPressed: () async => await _removeDevice(context, device),
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

  Future _saveDevice(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      LoadingDialog.show(context);
      FocusScope.of(context).unfocus();

      final device = Device(
        name: _deviceNameCtrl.text.trim(),
      );

      try {
        final newDevice = await _deviceProvider.addNewDeviceToDB(device);
        LoadingDialog.hide(context);
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
            'Danh sách thiết bị vật tư',
            style: titleWhite.copyWith(fontSize: 22.sp),
          ),
          centerTitle: true,
        ),
        body: Padding(
          padding: EdgeInsets.all(16.w),
          child: Column(
            children: [
              _createDeviceForm(),
              SizedBox(
                height: 16.w,
              ),
              Divider(),
              SizedBox(
                height: 16.w,
              ),
              _buildDeviceList()
            ],
          ),
        ));
  }

  Widget _createDeviceForm() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AppField(
            controller: _deviceNameCtrl,
            autoFocus: true,
            isName: true,
            textInputAction: TextInputAction.next,
            label: 'Tên vật tư:',
            hintText: 'Nhập tên vật tư',
          ),
          SizedBox(
            height: 16.w,
          ),
          AppButton(onPressed: () => _saveDevice(context), label: 'Lưu')
        ],
      ),
    );
  }

  Widget _buildDeviceList() {
    return StreamBuilder<Event>(
      stream: _deviceProvider.streamData(),
      builder: (context, snapshot) {
        List<Device> result = [];
        if (snapshot.hasData) {
          final Map devicesData = snapshot.data?.snapshot.value;

          devicesData.forEach((key, value) {
            final deviceJson = Map<String, dynamic>.from(value);
            final device = Device.fromJson(deviceJson);

            result.add(device);
          });

          if (result.isEmpty)
            return Center(
              child: Text('Danh sách trống. Hãy thêm thiết bị vật tư mới'),
            );

          return Expanded(
            child: ListView.separated(
                shrinkWrap: true,
                primary: false,
                physics: const BouncingScrollPhysics(),
                itemBuilder: (context, index) => _item(index+1, context, result[index]),
                separatorBuilder: (_, __) => Divider(),
                itemCount: result.length),
          );
        }
        return Center(
          child: const CircularProgressIndicator(),
        );
      },
    );
  }

  Widget _item(int stt, context, Device data) {
    final titleStyle = TextStyle(
        fontSize: 16.sp, fontWeight: FontWeight.normal, color: Colors.black);
    final valueStyle = TextStyle(
        fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.blue);

    return ListTile(
      leading: Text('$stt.', style: titleStyle,),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
              text: TextSpan(
                  style: titleStyle,
                  text: 'Tên vật tư: ',
                  children: [
                TextSpan(text: '${data.name}', style: valueStyle)
              ])),
        ],
      ),
      trailing: !appBloc.isAdmin
          ? null
          : IconButton(
              icon: Icon(
                Icons.close,
                color: Colors.red,
              ),
              onPressed: () => _showRemoveDeviceDialog(context, data),
            ),
    );
  }
}
