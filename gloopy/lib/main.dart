
import 'package:flutter/material.dart';
import 'package:gloopy/const.dart';
import 'package:gloopy/login.dart';
import 'package:gloopy/service_locator.dart';

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
      home: LoginScreen(
        title: "Connexion",
      ),
      //home: Test(),
      debugShowCheckedModeBanner: false,
    );
  }
}


