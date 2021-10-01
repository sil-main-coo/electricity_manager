import 'package:flutter/material.dart';

class FailureDialog {
  static void show(BuildContext context, String message) {
    showDialog(
        context: context,
        builder: (_) => AlertDialog(
              title: Text('Oops'),
              content: Text(message),
              actions: [
                RaisedButton(
                    child: Text(
                      'OK',
                      style: TextStyle(color: Colors.white),
                    ),
                    color: Colors.blue,
                    onPressed: () => Navigator.pop(context))
              ],
            ));
  }
}
