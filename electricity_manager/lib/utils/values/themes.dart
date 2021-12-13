import 'package:flutter/material.dart';
import 'colors.dart';

class AppTheme {
  static final themeDefault = ThemeData(
      appBarTheme: AppBarTheme(
          color: primary, iconTheme: IconThemeData(color: colorIconBlack)),
      fontFamily: 'Montserrat',
      primaryColor: primary,
      primaryColorDark: primary,
      primaryColorLight: primaryLight,
      accentColor: secondary,
      // indicatorColor: secondaryLight,
      focusColor: primary,
      disabledColor: primaryLight,
      hintColor: primaryLight,
      cursorColor: secondary,
      primaryTextTheme: TextTheme(
        subtitle1: TextStyle(color: colorTextWhite, fontWeight: FontWeight.bold),
        headline1: TextStyle(color: colorTextWhite, fontWeight: FontWeight.bold),
        subtitle2: TextStyle(
          color: colorTextBlack,
        ),
        bodyText2: TextStyle(
          color: colorTextWhite,
        ),
        bodyText1: TextStyle(
          color: colorTextWhite,
        ),
        caption: TextStyle(
          color: colorTextWhite,
        ),
        button: TextStyle(
          color: colorTextWhite, fontWeight: FontWeight.bold
        ),
        overline:TextStyle(color: colorTextWhite, fontWeight: FontWeight.bold),
      ),
      primaryIconTheme: IconThemeData(color: colorIconWhite),
      accentIconTheme: IconThemeData(color: colorIconWhite));
}
