import 'dart:io';
import 'dart:typed_data';

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

class ConfirmInfoScreen extends StatefulWidget {
  const ConfirmInfoScreen({Key? key, required this.reportModel})
      : super(key: key);

  final ReportModel reportModel;

  @override
  _ConfirmInfoScreenState createState() => _ConfirmInfoScreenState();
}

class _ConfirmInfoScreenState extends State<ConfirmInfoScreen> {
  final _firebaseStorage = getIt.get<FirebaseStorageHelpers>();
  final _firebaseDB = getIt.get<FirebaseDBHelpers>();

  File? _fileWord;

  Future _reviewWord() async {
    LoadingDialog.show(context);
    await _createWordFile();
    LoadingDialog.hide(context);
    if (_fileWord != null) {
      // print(resultFile.path);
      await Utils.openFile(_fileWord!.path);
    }
  }

  Future _createWordFile() async {
    if (_fileWord == null)
      _fileWord = await _firebaseStorage.insertDataToReport(widget.reportModel);
  }

  Future _addNewReport() async {
    LoadingDialog.show(context);
    try {
      await _createWordFile();
      final newModel = await _firebaseDB.addNewReportToDB(widget.reportModel);
      if (newModel != null) {
        // print(newModel.anhChuKy);
        final signImageURL = await _firebaseStorage.uploadImageToStorage(
            newModel.id!, 'sign', 'sign.jpg', newModel.anhChuKy!);
        if (signImageURL != null) {
          newModel.urlAnhChuKy = signImageURL;
          for (int i = 0; i < newModel.anhCTThao!.length; i++) {
            final ctThaoImageURL = await _firebaseStorage.uploadImageToStorage(
                newModel.id!,
                'CTThao',
                'ctthao_$i.jpg',
                newModel.anhCTThao![i]);
            if (ctThaoImageURL != null) {
              newModel.addAnhThao(ctThaoImageURL);
            }
          }

          for (int i = 0; i < newModel.anhCTTreo!.length; i++) {
            final ctTreoImageURL = await _firebaseStorage.uploadImageToStorage(
                newModel.id!, 'CTTreo', 'ctreo_$i.jpg', newModel.anhCTTreo![i]);
            if (ctTreoImageURL != null) {
              newModel.addAnhTreo(ctTreoImageURL);
            }
          }

          await _firebaseDB.updateReportOnDB(
              newModel.id!, newModel.toImagesJson());

          final urlWord = await _firebaseStorage.uploadFileToStorage(
              newModel.id!, 'bienban.docx', _fileWord!.readAsBytesSync());
          if (urlWord != null) {
            newModel.urlWord = urlWord;

            await _firebaseDB.updateReportOnDB(
                newModel.id!, newModel.toWordJson());
            LoadingDialog.hide(context);
            Navigator.popUntil(context, ModalRoute.withName('/'));
          }
        }
      } else {
        LoadingDialog.hide(context);
        FailureDialog.show(context, 'Đã xảy ra lỗi');
      }
    } catch (e) {
      LoadingDialog.hide(context);
      FailureDialog.show(context, 'Đã xảy ra lỗi');
      print(e);
    }
  }

  @override
  Widget build(BuildContext context) {
    // LoadingDialog.hide(context);
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Xác nhận thông tin',
            style: titleWhite.copyWith(fontSize: 22.sp),
          ),
          centerTitle: true,
        ),
        body: DetailInfoLayout(
          reportModel: widget.reportModel,
          type: VIEW_INFO_TYPE.PREVIEW,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
        floatingActionButton: Row(
          children: [
            Expanded(
              flex: 1,
              child: FloatingButtonWidget(
                onPressed: () async => await _reviewWord(),
                label: 'Xem trước word',
                color: Colors.yellow[800],
              ),
            ),
            Expanded(
              flex: 1,
              child: FloatingButtonWidget(
                onPressed: () async => await _addNewReport(),
                label: 'Xác nhận',
                color: Colors.blue,
              ),
            ),
          ],
        ));
  }
}
