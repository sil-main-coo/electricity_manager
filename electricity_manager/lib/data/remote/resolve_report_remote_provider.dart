import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:electricity_manager/models/resolve_report_model.dart';
import 'package:electricity_manager/utils/commons/urls.dart';
import 'package:http/http.dart' as http;
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

class ResolveReportRemoteProvider {
  static const reportNamePrefix = 'bien-ban-su-co';
  static const beforePath = 'hien-trang';
  static const finishedPath = 'hoan-thien';
  static const takeBackTemplateFile = 'mau-su-co.docx';

  static const signPath = 'chu-ky';
  static const signName = 'chu-ky.jpg';

  final refReportsDB =
      FirebaseDatabase.instance.reference().child('resolveReports');
  final _refReportStorage = FirebaseStorage.instance
      .ref()
      .child('tai-lieu')
      .child('bien-ban')
      .child('su-co');
  final _refTemplateReportStorage =
      FirebaseStorage.instance.ref().child('tai-lieu').child('mau-bien-ban');
  final _refImageStorage =
      FirebaseStorage.instance.ref().child('hinh-anh').child('su-co');

  var httpClient = new HttpClient();
  File? _templateFile;

  Stream<Event> streamData() {
    return refReportsDB.onValue;
  }

  Future<ResolveReportModel?> addNewReportToDB(ResolveReportModel model) async {
    try {
      final reportID = refReportsDB.push();
      model.id = reportID.key;
      await reportID.set(model.toJson());
      return model;
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<void> updateReportOnDB(String id, Map<String, dynamic> data) async {
    try {
      await refReportsDB.child(id).update(data);
      throw Exception('report id is null');
    } catch (e) {}
  }

  Future<void> removeReport(String id) async {
    try {
      await refReportsDB.child(id).remove();
      await _removeReportData(id);
      throw Exception('report id is null');
    } catch (e) {}
  }

  Future<File?> _getReportTemplate() async {
    if (_templateFile != null) return _templateFile;

    final urlFile = await _refTemplateReportStorage
        .child(takeBackTemplateFile)
        .getDownloadURL();

    try {
      var request = await httpClient.getUrl(Uri.parse(urlFile));
      var response = await request.close();
      if (response.statusCode == 200) {
        var bytes = await consolidateHttpClientResponseBytes(response);
        String dir = (await getApplicationDocumentsDirectory()).path;
        _templateFile = new File('$dir/$takeBackTemplateFile');
        await _templateFile?.writeAsBytes(bytes);
        return _templateFile;
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<File?> insertDataToReport(ResolveReportModel reportModel) async {
    try {
      final template = await _getReportTemplate();
      if (template != null) {
        var request =
            new http.MultipartRequest("POST", Uri.parse(URL_REPLACE_WORD));
        request.files.add(new http.MultipartFile.fromBytes(
            'docx', template.readAsBytesSync(),
            filename: 'template.docx'));

        request.fields['data'] = json.encode(reportModel.toDataWordJson());
        request.fields['table'] = json.encode(reportModel.toTableWordJson());
        request.fields['table_position'] = '0';

        final streamedResponse = await request.send();

        var response = await http.Response.fromStream(streamedResponse);
        var bytes = response.bodyBytes;
        String dir = (await getExternalStorageDirectories())![0].path;

        File resultFile = new File(
            '$dir/$reportNamePrefix-${reportModel.id ?? 'preview'}.docx');
        await resultFile.writeAsBytes(bytes);
        return resultFile;
      } else {
        print('templateFile is empty');
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  /// download file from file URL
  Future<File?> downloadFile(String reportID, String url) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var bytes = response.bodyBytes;
        String dir = (await getExternalStorageDirectories())![0].path;
        print(dir);
        File resultFile = new File('$dir/$reportNamePrefix-$reportID.docx');
        await resultFile.writeAsBytes(bytes);
        return resultFile;
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  /// upload *.docx file to storage
  Future<String?> uploadDocToStorage(
      String reportID, Uint8List file) async {
    final parentRef = _refReportStorage
        .child(reportID)
        .child('$reportNamePrefix-$reportID.docx');
    try {
      final uploadTask = await parentRef.putData(file);

      return uploadTask.ref.getDownloadURL();
    } catch (e) {
      print(e);
    }
    return null;
  }

  /// upload image to report storage
  Future<String?> uploadImageToStorage(
      String reportID, String path, String imgName, Uint8List file) async {
    final parentRef =
        _refImageStorage.child(reportID).child(path).child(imgName);
    try {
      final uploadTask = await parentRef.putData(file);
      return uploadTask.ref.getDownloadURL();
    } catch (e) {
      print(e);
    }
    return null;
  }

  /// remove report storage data
  Future<void> _removeReportData(String id) async {
    final imagesRef = _refImageStorage.child(id);

    final imgSign = await imagesRef.child(signPath).listAll();
    final imgBefore = await imagesRef.child(beforePath).listAll();
    final imgFinished = await imagesRef.child(finishedPath).listAll();

    imgSign.items.forEach((element) {
      element.delete();
    });
    imgBefore.items.forEach((element) {
      element.delete();
    });
    imgFinished.items.forEach((element) {
      element.delete();
    });

    final word = await _refReportStorage.child(id).listAll();
    word.items.forEach((element) {
      element.delete();
    });
  }
}
