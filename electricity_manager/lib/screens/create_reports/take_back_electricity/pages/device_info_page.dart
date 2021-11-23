import 'package:electricity_manager/models/device.dart';
import 'package:electricity_manager/screens/components/fields/dropdown_field.dart';
import 'package:electricity_manager/screens/components/floating_button_widget.dart';
import 'package:electricity_manager/screens/components/layout_have_floating_button.dart';
import 'package:electricity_manager/screens/create_reports/take_back_electricity/widget_models/device_widget_model.dart';
import 'package:electricity_manager/utils/values/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DeviceInfoPage extends StatefulWidget {
  const DeviceInfoPage(
      {Key? key,
      required this.nextCallback,
      required this.backCallback,
      required this.devices})
      : super(key: key);

  final Function(List<Device> devices) nextCallback;
  final Function backCallback;
  final List<Device> devices;

  @override
  _DeviceInfoPageState createState() => _DeviceInfoPageState();
}

class _DeviceInfoPageState extends State<DeviceInfoPage> {
  final _formKey = GlobalKey<FormState>();

  List<DeviceWidgetModel> _deviceWidgets = [];

  void _removeDevice(DeviceWidgetModel element) {
    setState(() {
      _deviceWidgets.remove(element);
    });
  }

  void _addDevice() {
    setState(() {
      _deviceWidgets.add(DeviceWidgetModel());
    });
  }

  void _next() {
    if (_formKey.currentState != null && _formKey.currentState!.validate()) {
      FocusScope.of(context).unfocus();
      final devices = _deviceWidgets.map((e) {
        e.device?.count = e.count;
        return e.device!;
      }).toList();
      widget.nextCallback(devices);
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
              'Danh sách vật tư thu hồi',
              style: caption.copyWith(fontSize: 14.sp),
            ),
          ],
        ),
        centerTitle: true,
      ),
      body: LayoutHaveFloatingButton(
        child: _buildBody(),
      ),
      floatingActionButton: FloatingButtonWidget(
        onPressed: _next,
        label: 'Tiếp tục',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildBody() {
    return _deviceWidgets.isEmpty ? _devicesEmpty() : _buildDeviceList();
  }

  Widget _devicesEmpty() {
    return GestureDetector(
      onTap: () => _addDevice(),
      behavior: HitTestBehavior.translucent,
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text('Chưa có vật tư. Hãy ấn nút để thêm'),
            SizedBox(
              height: 16.w,
            ),
            _addDeviceButton()
          ],
        ),
      ),
    );
  }

  Widget _addDeviceButton() {
    return SizedBox(
        width: double.infinity,
        height: 52.h,
        child: OutlinedButton.icon(
          onPressed: () => _addDevice(),
          style: OutlinedButton.styleFrom(
            side: BorderSide(color: Colors.blueAccent),
          ),
          icon: Icon(Icons.add),
          label: Text(
            'Thêm vật tư'.toUpperCase(),
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
        ));
  }

  Widget _buildDeviceList() {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          ListView.separated(
              primary: false,
              shrinkWrap: true,
              itemBuilder: (_, index) =>
                  _buildDeviceItem(index, _deviceWidgets[index]),
              separatorBuilder: (_, __) => Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.w),
                    child: Divider(),
                  ),
              itemCount: _deviceWidgets.length),
          SizedBox(
            height: 24.w,
          ),
          _addDeviceButton()
        ],
      ),
    );
  }

  Widget _buildDeviceItem(int index, DeviceWidgetModel deviceModel) {
    final titleStyle = TextStyle(
        fontWeight: FontWeight.w600, fontSize: 16.sp, color: Colors.blue[600]);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Thiết bị ${index + 1}',
              style: titleStyle,
            ),
            TextButton(
                onPressed: () => _removeDevice(deviceModel),
                child: Text(
                  'Xóa',
                  style: TextStyle(color: Colors.red),
                ))
          ],
        ),
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: DropDownField<Device>(
                controller: deviceModel.deviceCtrl,
                titleSelection: 'Chọn vật tư',
                data: widget.devices,
                initial: deviceModel.device,
                selected: (item) {
                  setState(() {
                    _deviceWidgets[index].device = item;
                  });
                },
              ),
            ),
            SizedBox(
              width: 8.w,
            ),
            Row(
              children: [
                IconButton(
                    onPressed: () {
                      if (_deviceWidgets[index].count > 1) {
                        setState(() {
                          _deviceWidgets[index].count--;
                        });
                      }
                    },
                    icon: Icon(Icons.remove)),
                SizedBox(
                  width: 4.w,
                ),
                Text(
                  deviceModel.count.toString(),
                  style: Theme.of(context).textTheme.bodyText1?.copyWith(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                SizedBox(
                  width: 4.w,
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        _deviceWidgets[index].count++;
                      });
                    },
                    icon: Icon(Icons.add)),
              ],
            ),
          ],
        ),
      ],
    );
  }
}
