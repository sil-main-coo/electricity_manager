import 'dart:io';
import 'package:electricity_manager/data/remote/take_back_report_remote_provider.dart';
import 'package:electricity_manager/models/take_back_report_model.dart';
import 'package:electricity_manager/screens/components/failure_dialog.dart';
import 'package:electricity_manager/screens/create_reports/take_back_electricity/widgets/take_back_detail_layout.dart';
import 'package:electricity_manager/utils/commons/text_styles.dart';
import 'package:electricity_manager/di/locator.dart';
import 'package:electricity_manager/screens/components/floating_button_widget.dart';
import 'package:electricity_manager/screens/components/loading_dialog.dart';
import 'package:electricity_manager/utils/enums/detail_view_enum.dart';
import 'package:electricity_manager/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class ConfirmTakeBackScreen extends StatefulWidget {
  const ConfirmTakeBackScreen({Key? key, required this.reportModel})
      : super(key: key);

  final TakeBackReportModel reportModel;

  @override
  _ConfirmTakeBackScreenState createState() => _ConfirmTakeBackScreenState();
}

class _ConfirmTakeBackScreenState extends State<ConfirmTakeBackScreen> {
  final _reportProvider = getIt.get<TakeBackReportRemoteProvider>();

  File? _fileWord;

  Future _reviewWord() async {
    LoadingDialog.show(context);
    await _createWordFile();
    LoadingDialog.hide(context);
    if (_fileWord != null) {
      print(_fileWord?.path);
      await Utils.openFile(_fileWord!.path);
    }
  }

  Future _createWordFile() async {
    if (_fileWord == null)
      _fileWord = await _reportProvider.insertDataToReport(widget.reportModel);
  }

  Future _addNewReport() async {
    try {
      LoadingDialog.show(context);
      await _createWordFile();
      final newModel =
          await _reportProvider.addNewReportToDB(widget.reportModel);
      if (newModel != null) {
        final staffSignImageURL = await _reportProvider.uploadImageToStorage(
            newModel.id!,
            TakeBackReportRemoteProvider.signPath,
            TakeBackReportRemoteProvider.staffSignFileName,
            newModel.staffSignImage!);
        final managerSignImageURL = await _reportProvider.uploadImageToStorage(
            newModel.id!,
            TakeBackReportRemoteProvider.signPath,
            TakeBackReportRemoteProvider.managerSignFileName,
            newModel.managerSignImage!);
        final presidentSignImageURL =
            await _reportProvider.uploadImageToStorage(
                newModel.id!,
                TakeBackReportRemoteProvider.signPath,
                TakeBackReportRemoteProvider.presidentSignFileName,
                newModel.presidentSignImage!);

        if (managerSignImageURL != null &&
            staffSignImageURL != null &&
            presidentSignImageURL != null) {
          newModel.urlStaffSignImage = staffSignImageURL;
          newModel.urlManagerSignImage = managerSignImageURL;
          newModel.urlPresidentSignImage = presidentSignImageURL;

          for (int i = 0; i < newModel.beforeImages!.length; i++) {
            final beforeImageURLs = await _reportProvider.uploadImageToStorage(
                newModel.id!,
                TakeBackReportRemoteProvider.beforePath,
                '${TakeBackReportRemoteProvider.beforePath}-$i.jpg',
                newModel.beforeImages![i]);

            if (beforeImageURLs != null) {
              newModel.addURLBeforeImages(beforeImageURLs);
            }
          }

          for (int i = 0; i < newModel.finishedImages!.length; i++) {
            final finishedImageURLs =
                await _reportProvider.uploadImageToStorage(
                    newModel.id!,
                    TakeBackReportRemoteProvider.finishedPath,
                    '${TakeBackReportRemoteProvider.finishedPath}-$i.jpg',
                    newModel.finishedImages![i]);
            if (finishedImageURLs != null) {
              newModel.addURLFinishedImages(finishedImageURLs);
            }
          }

          /// update image urls
          await _reportProvider.updateReportOnDB(
              newModel.id!, newModel.toImagesJson());

          /// upload and update word
          final urlWord = await _reportProvider.uploadDocToStorage(
              newModel.id!, _fileWord!.readAsBytesSync());
          if (urlWord != null) {
            newModel.urlWord = urlWord;

            await _reportProvider.updateReportOnDB(
                newModel.id!, newModel.toWordJson());

            LoadingDialog.hide(context);
            Navigator.pop(context);
            Navigator.pop(context);
          }
        }
      } else {
        LoadingDialog.hide(context);
        FailureDialog.show(context, 'Đã xảy ra lỗi. Vui lòng thử lại');
      }
    } catch (e) {
      print(e);
      LoadingDialog.hide(context);
      FailureDialog.show(context, 'Đã xảy ra lỗi');
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
        body: TakeBackDetailLayout(
          reportModel: widget.reportModel,
          type: DETAIL_VIEW.PREVIEW,
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
