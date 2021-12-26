import 'dart:io';
import 'package:electricity_manager/data/remote/take_back_report_remote_provider.dart';
import 'package:electricity_manager/models/take_back_report_model.dart';
import 'package:electricity_manager/screens/create_reports/take_back_electricity/widgets/take_back_detail_layout.dart';
import 'package:electricity_manager/utils/commons/text_styles.dart';
import 'package:electricity_manager/di/locator.dart';
import 'package:electricity_manager/screens/components/failure_dialog.dart';
import 'package:electricity_manager/screens/components/floating_button_widget.dart';
import 'package:electricity_manager/screens/components/loading_dialog.dart';
import 'package:electricity_manager/utils/enums/detail_view_enum.dart';
import 'package:electricity_manager/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DetailTakeBackReportScreen extends StatelessWidget {
  DetailTakeBackReportScreen({Key? key, required this.reportModel})
      : super(key: key);

  final TakeBackReportModel reportModel;
  final _reportsDB = getIt.get<TakeBackReportRemoteProvider>();

  File? _fileWord;

  Future _readWord(BuildContext context) async {
    try {
      LoadingDialog.show(context);
      if (_fileWord == null) {
        _fileWord =
        await _reportsDB.downloadFile(reportModel.id!, reportModel.urlWord!);
      }
      LoadingDialog.hide(context);
      await Utils.openFile(_fileWord!.path);
    }catch(e){
      LoadingDialog.hide(context);
      FailureDialog.show(context, 'Đã xảy ra lỗi: $e');
    }
  }

  Future _handlingRemoveReport(BuildContext context) async {
    try {
      LoadingDialog.show(context);
      await _reportsDB.removeReport(reportModel.id!);
      LoadingDialog.hide(context);
      Navigator.pop(context);
      Navigator.pop(context);
    } catch (e) {
      LoadingDialog.hide(context);
      FailureDialog.show(context, 'Đã xảy ra lỗi');
    }
  }

  void _removeReportDialog(BuildContext context) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              content: Text('Đồng ý xóa biên bản này?'),
              actions: [
                RaisedButton(
                  onPressed: () async => await _handlingRemoveReport(context),
                  child: Text(
                    'ĐỒNG Ý',
                    style: TextStyle(color: Colors.white),
                  ),
                  color: Colors.blue,
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
            'Chi tiết biên bản thu hồi',
            style: titleWhite.copyWith(fontSize: 22.sp),
          ),
          centerTitle: true,
        ),
        body: TakeBackDetailLayout(
          reportModel: reportModel,
          type: DETAIL_VIEW.DETAIL,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Row(
          children: [
            Expanded(
              flex: 1,
              child: FloatingButtonWidget(
                onPressed: () => _removeReportDialog(context),
                label: 'Xóa biên bản',
                color: Colors.red,
              ),
            ),
            Expanded(
              flex: 1,
              child: FloatingButtonWidget(
                onPressed: () => _readWord(context),
                label: 'Xem bản word',
                color: Colors.blue,
              ),
            )
          ],
        ));
  }
}
