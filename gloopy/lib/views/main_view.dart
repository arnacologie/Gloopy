import 'package:flutter/material.dart';
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
                Container(),
                Container(),
                Container(),
                Container(),
                SettingsView()
              ],
            ),
        bottomNavigationBar: TabBar(
          tabs: <Widget>[
            //Contacts
            Tab(icon: Icon(Icons.person_pin)),
            //Discussion
            Tab(icon: Icon(Icons.message)),
            //Trophees
            Tab(icon: Icon(Icons.star)),
            //Dessins
            Tab(icon: Icon(Icons.edit)),
            //Jeux
            Tab(icon: Icon(Icons.gamepad)),
            //Reglages
            Tab(icon: Icon(Icons.settings)),
          ],
        ),
      ),
    );
  }
}