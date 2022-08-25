import 'package:flutter/material.dart';

import '../pages/login_page.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return const MaterialApp(
      title: 'Flutter 4Dev',
      debugShowCheckedModeBanner: false,
      home: LoginPage(),
    );
  }
}