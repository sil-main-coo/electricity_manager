import 'package:flutter/material.dart';
import 'children/bg_header.dart';
import 'children/input_box.dart';

class LoginPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Stack(
        children: <Widget>[
          bgHeaderLogin(),
          BoxInputLogin(),
        ],
      ),
    );
  }
}
