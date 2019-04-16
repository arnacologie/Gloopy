
import 'package:flutter/material.dart';
import 'package:gloopy/const.dart';
import 'package:gloopy/service_locator.dart';
import 'package:gloopy/views/pre_login_view.dart';
import 'package:gloopy/views/test_view.dart';

void main() {
  setUpServiceLocator();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Demo',
      theme: ThemeData(
        primaryColor: themeColor,
      ),
      // home: LoginScreen(
      //   title: "Connexion",
      // ),
      //home: PreLoginView(),
      home: TestView(),
      debugShowCheckedModeBanner: false,
    );
  }
}


