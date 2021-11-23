import 'package:electricity_manager/data/remote/take_back_report_remote_provider.dart';
import 'package:electricity_manager/di/locator.dart';
import 'package:electricity_manager/models/take_back_report_model.dart';
import 'package:electricity_manager/screens/components/floating_button_widget.dart';
import 'package:electricity_manager/screens/components/layout_have_floating_button.dart';
import 'package:electricity_manager/screens/create_reports/take_back_electricity/take_back_electricity_screen.dart';
import 'package:electricity_manager/utils/commons/text_styles.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'detail_take_back_report_screen.dart';

class ListTakeBackReportScreen extends StatefulWidget {
  const ListTakeBackReportScreen({Key? key}) : super(key: key);

  @override
  _ListTakeBackReportScreenState createState() =>
      _ListTakeBackReportScreenState();
}

class _ListTakeBackReportScreenState extends State<ListTakeBackReportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<Event>(
        stream: getIt.get<TakeBackReportRemoteProvider>().streamData(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Text('Đã xảy ra lỗi');
          }
          if (snapshot.hasData) {
            return _buildScreen(snapshot.data);
          }
          return Scaffold(
            body: Center(
              child: const CircularProgressIndicator(),
            ),
          );
        },
      ),
    );
  }

  Widget _buildScreen(Event? data) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Quản lý biên bản thu hồi',
          style: titleWhite.copyWith(fontSize: 22.sp),
        ),
        centerTitle: true,
      ),
      body: data?.snapshot.value != null
          ? _buildBody(data?.snapshot.value)
          : Center(
              child: Text('Danh sách trống. Hãy tạo biên bản mới'),
            ),
      floatingActionButton: FloatingButtonWidget(
        onPressed: () => Navigator.push(context,
            MaterialPageRoute(builder: (_) => TakeBackElectricityScreen())),
        label: 'Tạo mới',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildBody(value) {
    List<TakeBackReportModel> result = [];
    final Map reportData = value;

    reportData.forEach((key, value) {
      result.insert(
          0, TakeBackReportModel.fromJson(key.toString(), Map.from(value)));
    });

    return LayoutHaveFloatingButton(
      child: ListView.separated(
          shrinkWrap: true,
          primary: false,
          itemBuilder: (context, index) => _item(result[index]),
          separatorBuilder: (_, __) => Divider(),
          itemCount: result.length),
    );
  }

  Widget _item(TakeBackReportModel data) {
    final titleStyle = TextStyle(
        fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.black);

    return ListTile(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => DetailTakeBackReportScreen(
                    reportModel: data,
                  ))),
      leading: Icon(Icons.event_note),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
              text: TextSpan(style: titleStyle, text: 'Mã KH: ', children: [
            TextSpan(text: '${data.clientCode.toString()}', style: titleStyle)
          ])),
          RichText(
              text: TextSpan(style: titleStyle, text: 'Tên KH: ', children: [
            TextSpan(
                text: data.clientName,
                style: titleStyle.copyWith(color: Colors.blue))
          ])),
        ],
      ),
      subtitle: Text('Địa chỉ KH: ${data.clientAddress}'),
    );
  }
}
