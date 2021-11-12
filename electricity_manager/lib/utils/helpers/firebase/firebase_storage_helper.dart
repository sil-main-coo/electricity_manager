import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:electricity_manager/models/report_model.dart';
import 'package:electricity_manager/utils/commons/urls.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:http/http.dart' as http;
import 'package:path_provider/path_provider.dart';

class FirebaseStorageHelpers {
  var httpClient = new HttpClient();
  final _refDocumentStorage = FirebaseStorage.instance.ref().child('documents');
  final _refImageStorage = FirebaseStorage.instance.ref().child('images');

  File? templateFile;

  /// call when init app
  Future<File?> getReportTemplate() async {
    final urlFile = await _refDocumentStorage
        .child('template/template.docx')
        .getDownloadURL();
    // print(urlFile);
    try {
      var request = await httpClient.getUrl(Uri.parse(urlFile));
      var response = await request.close();
      if (response.statusCode == 200) {
        var bytes = await consolidateHttpClientResponseBytes(response);
        String dir = (await getApplicationDocumentsDirectory()).path;
        templateFile = new File('$dir/template.docx');
        await templateFile?.writeAsBytes(bytes);
        return templateFile;
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<File?> insertDataToReport(ReportModel reportModel) async {
    print(reportModel.toJsonInsertWord());
    try {
      if (templateFile != null) {
        var request =
            new http.MultipartRequest("POST", Uri.parse(URL_REPLACE_WORD));
        request.files.add(new http.MultipartFile.fromBytes(
            'docx', templateFile!.readAsBytesSync(),
            filename: 'template.docx'));
        request.fields['data'] = json.encode(reportModel.toJsonInsertWord());

        // print('>>: ${request.url}');
        // print('>>: ${request.files[0].filename}');
        // print('>>: ${request.fields.toString()}');
        final streamedResponse = await request.send();
        print(streamedResponse.statusCode);

        var response = await http.Response.fromStream(streamedResponse);
        var bytes = response.bodyBytes;
        String dir = (await getExternalStorageDirectories())![0].path;
        print(dir);
        File resultFile = new File('$dir/result.docx');
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

  Future<File?> downloadFile(String id, String url) async {
    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        var bytes = response.bodyBytes;
        String dir = (await getExternalStorageDirectories())![0].path;
        print(dir);
        File resultFile = new File('$dir/bienban_$id.docx');
        await resultFile.writeAsBytes(bytes);
        return resultFile;
      }
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<String?> uploadFileToStorage(
      String reportID, String name, Uint8List file) async {
    final parentRef = _refDocumentStorage
        .child('reports')
        .child(reportID)
        .child('${reportID}_$name');
    try {
      final uploadTask = await parentRef.putData(file);

      return uploadTask.ref.getDownloadURL();
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<String?> uploadImageToStorage(
      String id, String parent, String name, Uint8List file) async {
    final parentRef = _refImageStorage.child(id).child(parent).child(name);
    try {
      final uploadTask = await parentRef.putData(file);

      return uploadTask.ref.getDownloadURL();
    } catch (e) {
      print(e);
    }
    return null;
  }

  Future<void> removeReportData(String id) async {
    final imagesRef = await _refImageStorage.child(id);

    final imageCTThaos = await imagesRef.child('CTThao').listAll();
    final imageCTTreos = await imagesRef.child('CTTreo').listAll();
    final imageSigns = await imagesRef.child('sign').listAll();

    imageCTThaos.items.forEach((element) {
      element.delete();
    });
    imageCTTreos.items.forEach((element) {
      element.delete();
    });
    imageSigns.items.forEach((element) {
      element.delete();
    });

    final word = await _refDocumentStorage.child('reports').child(id).listAll();
    word.items.forEach((element) {
      element.delete();
    });
  }
}
