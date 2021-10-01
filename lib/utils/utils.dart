import 'package:open_file/open_file.dart';
import 'package:url_launcher/url_launcher.dart';

class Utils{
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
}