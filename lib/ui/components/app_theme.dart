import 'package:flutter/material.dart';

import 'custom_colors.dart';

ThemeData makeAppTheme() {
  return ThemeData(
      primaryColor: CustomColors.primaryColor,
      primaryColorDark: CustomColors.primaryColorDark,
      primaryColorLight: CustomColors.primaryColorLight,
      backgroundColor: Colors.white,
      textTheme: const TextTheme(
        headline1: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: CustomColors.primaryColorDark),
      ),
      inputDecorationTheme: const InputDecorationTheme(
        iconColor: CustomColors.primaryColorDark,
        enabledBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: CustomColors.primaryColorLight,
          ),
        ),
        prefixStyle: TextStyle(
          color: CustomColors.primaryColorDark,
        ),
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(
            color: CustomColors.primaryColorDark,
          ),
        ),
        focusColor: CustomColors.primaryColorDark,
        alignLabelWithHint: true,
      ),
      buttonTheme: const ButtonThemeData(
        colorScheme: ColorScheme.light(primary: CustomColors.primaryColor),
        buttonColor: CustomColors.primaryColor,
        splashColor: CustomColors.primaryColor,
        padding: EdgeInsets.symmetric(vertical: 10, horizontal: 20),
        textTheme: ButtonTextTheme.primary,
      ));
}
