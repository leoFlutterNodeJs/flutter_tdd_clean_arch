import 'package:flutter/material.dart';

import '../../ui/components/components.dart';
import '../pages/login_page.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter 4Dev',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: CustomColors.primaryColor,
        primaryColorDark: CustomColors.primaryColorDark,
        primaryColorLight: CustomColors.primaryColorLight,
        backgroundColor: Colors.white,
        textTheme: const TextTheme(
          headline1: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
            color: CustomColors.primaryColorDark
          ),
        ),
        inputDecorationTheme: const InputDecorationTheme(
          iconColor: CustomColors.primaryColorDark,
          enabledBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: CustomColors.primaryColorLight,),
          ),
          prefixStyle: TextStyle(
            color: CustomColors.primaryColorDark,
          ),
          focusedBorder: UnderlineInputBorder(
            borderSide: BorderSide(color: CustomColors.primaryColorDark,),
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
        )
      ),
      home: const LoginPage(),
    );
  }
}