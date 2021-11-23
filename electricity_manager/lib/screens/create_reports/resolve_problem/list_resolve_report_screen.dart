import 'package:electricity_manager/data/remote/resolve_report_remote_provider.dart';
import 'package:electricity_manager/di/locator.dart';
import 'package:electricity_manager/models/resolve_report_model.dart';
import 'package:electricity_manager/screens/components/floating_button_widget.dart';
import 'package:electricity_manager/screens/components/layout_have_floating_button.dart';
import 'package:electricity_manager/screens/create_reports/resolve_problem/detail_resolve_detail_screen.dart';
import 'package:electricity_manager/screens/create_reports/resolve_problem/widgets/resolve_report_detail_layout.dart';
import 'package:electricity_manager/utils/commons/text_styles.dart';
import 'package:electricity_manager/utils/enums/detail_view_enum.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import 'create_resolve_report_screen.dart';

class ListResolveReportScreen extends StatefulWidget {
  const ListResolveReportScreen({Key? key}) : super(key: key);

  @override
  _ListResolveReportScreenState createState() =>
      _ListResolveReportScreenState();
}

class _ListResolveReportScreenState extends State<ListResolveReportScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<Event>(
        stream: getIt.get<ResolveReportRemoteProvider>().streamData(),
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
          'Quản lý biên bản sự cố',
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
            MaterialPageRoute(builder: (_) => CreateResolveReportScreen())),
        label: 'Tạo mới',
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
    );
  }

  Widget _buildBody(value) {
    List<ResolveReportModel> result = [];
    final Map reportData = value;

    reportData.forEach((key, value) {
      result.insert(
          0, ResolveReportModel.fromJson(key.toString(), Map.from(value)));
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

  Widget _item(ResolveReportModel data) {
    final titleStyle = TextStyle(
        fontSize: 16.sp, fontWeight: FontWeight.w600, color: Colors.black);

    return ListTile(
      onTap: () => Navigator.push(
          context,
          MaterialPageRoute(
              builder: (_) => DetailResolveReportScreen(
                    reportModel: data,
                  ))),
      leading: Icon(Icons.event_note),
      title: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
              text: TextSpan(style: titleStyle, text: 'Tên sự cố: ', children: [
            TextSpan(text: '${data.resolveName.toString()}', style: titleStyle)
          ])),
          RichText(
              text: TextSpan(style: titleStyle, text: 'Địa chỉ: ', children: [
            TextSpan(
                text: data.resolveAddress,
                style: titleStyle.copyWith(color: Colors.blue))
          ])),
        ],
      ),
      subtitle: Text('Ngày: ${data.createAtString()}'),
    );
  }
}
