import 'package:flutter/material.dart';

class LoadingDialog {
  static void show(BuildContext context) {
    showDialog(
        barrierDismissible: false,
        context: context,
        builder: (_) => WillPopScope(
              onWillPop: () async {
                return false;
              },
              child: AlertDialog(
                backgroundColor: Colors.transparent,
                elevation: 0,
                content: Center(
                  child: const CircularProgressIndicator(),
                ),
              ),
            ));
  }

  static void hide(BuildContext context) {
    Navigator.pop(context);
  }
}
