import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/services.dart';
import 'package:open_file/open_file.dart' as open_file;
import 'package:path_provider/path_provider.dart' as path_provider;
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:path_provider_platform_interface/path_provider_platform_interface.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils {
  static Future openFile(String path) async {
    OpenFile.open(path);
  }

  static Future<void> launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }

  static String dateToDefaultString(DateTime date) {
    return '${date.day < 10 ? '0${date.day}' : date.day}/${date.month < 10 ? '0${date.month}' : date.month}/${date.year}';
  }

  static String dateToMonthAndYearString(DateTime date) {
    return '${date.month < 10 ? '0${date.month}' : date.month}/${date.year}';
  }

  ///To save the Excel file in the device
  ///To save the Excel file in the device
  static Future<void> saveAndLaunchFile(
      List<int> bytes, String fileName) async {
    //Get the storage folder location using path_provider package.
    String? path;
    if (Platform.isAndroid) {
      path = await Utils.getDownloadPath();
    } else if (Platform.isIOS || Platform.isLinux || Platform.isWindows) {
      final Directory directory =
          await path_provider.getApplicationSupportDirectory();
      path = directory.path;
    } else {
      path = await PathProviderPlatform.instance.getApplicationSupportPath();
    }
    final File file =
        File(Platform.isWindows ? '$path\\$fileName' : '$path/$fileName');
    await file.writeAsBytes(bytes, flush: true);
    if (Platform.isAndroid || Platform.isIOS) {
      //Launch the file (used open_file package)
      await open_file.OpenFile.open('$path/$fileName');
    } else if (Platform.isWindows) {
      await Process.run('start', <String>['$path\\$fileName'],
          runInShell: true);
    } else if (Platform.isMacOS) {
      await Process.run('open', <String>['$path/$fileName'], runInShell: true);
    } else if (Platform.isLinux) {
      await Process.run('xdg-open', <String>['$path/$fileName'],
          runInShell: true);
    }
  }

  static Future<Uint8List?> imageFromURL(String? url) async {
    if (url == null) return null;

    return (await NetworkAssetBundle(Uri.parse(url)).load(url))
        .buffer
        .asUint8List();
  }

  static Future<String> getDownloadPath() async {
    if (Platform.isAndroid) {
      return "/storage/emulated/0/Download";
    }
    return (await getApplicationDocumentsDirectory()).path;
  }
}
