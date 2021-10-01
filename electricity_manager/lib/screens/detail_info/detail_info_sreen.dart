import 'dart:io';

import 'package:electricity_manager/commons/text_styles.dart';
import 'package:electricity_manager/di/locator.dart';
import 'package:electricity_manager/models/report_model.dart';
import 'package:electricity_manager/screens/components/detail_info_layout.dart';
import 'package:electricity_manager/screens/components/failure_dialog.dart';
import 'package:electricity_manager/screens/components/floating_button_widget.dart';
import 'package:electricity_manager/screens/components/loading_dialog.dart';
import 'package:electricity_manager/utils/helpers/firebase/firebase_db_helpers.dart';
import 'package:electricity_manager/utils/helpers/firebase/firebase_storage_helper.dart';
import 'package:electricity_manager/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class DetailInfoScreen extends StatelessWidget {
  DetailInfoScreen({Key? key, required this.reportModel}) : super(key: key);

  final ReportModel reportModel;
  final _firebaseStorage = getIt.get<FirebaseStorageHelpers>();
  final _firebaseDB = getIt.get<FirebaseDBHelpers>();

  File? _fileWord;

  Future _readWord(BuildContext context) async {
    // print(reportModel.urlWord);
    LoadingDialog.show(context);
    if (_fileWord == null) {
      _fileWord = await _firebaseStorage.downloadFile(
          reportModel.id!, reportModel.urlWord!);
    }
    LoadingDialog.hide(context);
    await Utils.openFile(_fileWord!.path);
  }

  Future _handlingRemoveReport(BuildContext context) async {
    try {
      LoadingDialog.show(context);
      await _firebaseDB.removeReport(reportModel.id!);
      await _firebaseStorage.removeReportData(reportModel.id!);
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
            'Thông tin treo tháo công tơ',
            style: titleWhite.copyWith(fontSize: 22.sp),
          ),
          centerTitle: true,
        ),
        body: DetailInfoLayout(
          reportModel: reportModel,
          type: VIEW_INFO_TYPE.DETAIL,
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
