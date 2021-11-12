import 'package:flutter/material.dart';

class AvatarDefault extends StatelessWidget {
  final double? radius;

  AvatarDefault({this.radius});

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: radius ?? 20,
      backgroundImage:  ExactAssetImage('assets/images/avatar.png') ,
    );
  }
}
