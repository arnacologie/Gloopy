import 'package:flutter/material.dart';
import 'package:gloopy/const.dart';
import 'package:gloopy/test.dart';
import 'package:gloopy/views/chat_view.dart';
import 'package:gloopy/views/contact_view.dart';
import 'package:gloopy/views/settings_view.dart';

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      initialIndex: 0,
      length: 6,
          child: Scaffold(
            body: TabBarView(
              physics: NeverScrollableScrollPhysics(),
              children: <Widget>[
                ContactView(),
                //ChatView(),
                Container(),
                ContactTestView(),
                Container(),
                Container(),
                SettingsView()
              ],
            ),
        bottomNavigationBar: TabBar(
          tabs: <Widget>[
            //Contacts
            Tab(icon: Icon(Icons.person_pin, color: darkSkyColor,)),
            //Discussion
            Tab(icon: Icon(Icons.message, color: darkSkyColor,)),
            //Trophees
            Tab(icon: Icon(Icons.star, color: darkSkyColor,)),
            //Dessins
            Tab(icon: Icon(Icons.edit, color: darkSkyColor,)),
            //Jeux
            Tab(icon: Icon(Icons.gamepad, color: darkSkyColor,)),
            //Reglages
            Tab(icon: Icon(Icons.settings, color: darkSkyColor,)),
          ],
        ),
      ),
    );
  }
}