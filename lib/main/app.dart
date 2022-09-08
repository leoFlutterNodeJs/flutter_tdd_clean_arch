import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../ui/components/components.dart';

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    return MaterialApp(
      title: 'Flutter 4Dev',
      debugShowCheckedModeBanner: false,
      theme: makeAppTheme(),
      home: Container(),
    );
  }
}