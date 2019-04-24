import 'package:flutter/material.dart';
import 'package:gloopy/const.dart';
import 'package:gloopy/managers/user_manager.dart';
import 'package:gloopy/service_locator.dart';
import 'package:gloopy/test.dart';
import 'package:gloopy/views/chat_view.dart';
import 'package:gloopy/views/drawings_view.dart';
import 'package:gloopy/views/settings_view.dart';
import 'package:gloopy/views/trophies.dart';

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
            ContactTestView(),
            ChatView(
              peerId: sl.get<UserManager>().lastContactID,
              peerAvatar: sl.get<UserManager>().lastContactAvatar,
            ),
            TrophiesView(),
            DrawingView(),
            Container(),
            SettingsView()
          ],
        ),
        bottomNavigationBar: TabBar(
          tabs: <Widget>[
            //Contacts
            Tab(
                icon: Icon(
              Icons.person_pin,
              color: darkSkyColor,
            )),
            //Discussion
            Tab(
                icon: Icon(
              Icons.message,
              color: darkSkyColor,
            )),
            //Trophees
            Tab(
                icon: Icon(
              Icons.image,
              color: darkSkyColor,
            )),
            //Dessins
            Tab(
                icon: Icon(
              Icons.edit,
              color: darkSkyColor,
            )),
            //Jeux
            Tab(
                icon: Icon(
              Icons.gamepad,
              color: darkSkyColor,
            )),
            //Reglages
            Tab(
                icon: Icon(
              Icons.settings,
              color: darkSkyColor,
            )),
          ],
        ),
      ),
    );
  }
}
