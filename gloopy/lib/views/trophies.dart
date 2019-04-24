import 'package:flutter/material.dart';
import 'package:gloopy/const.dart';

import 'package:transparent_image/transparent_image.dart';

class TrophiesView extends StatefulWidget {
  @override
  _TrophiesViewState createState() => _TrophiesViewState();
}

class _TrophiesViewState extends State<TrophiesView> {
  List<String> listBadges = [
    'images/badges/BADGE_IMAGE_GAGNE_1.png',
    'images/badges/BADGE_IMAGE_GAGNE_2.png',
    'images/badges/BADGE_IMAGE_GAGNE_3.png',
    'images/badges/BADGE_IMAGE_GAGNE_4.png',
    'images/badges/BADGE_IMAGE_GAGNE_5.png',
    'images/badges/BADGE_IMAGE_GAGNE_6.png',
  ];

  List<String> listGloopy = [
    'images/characters/gloopy_character.png',
  ];

  List<String> listRobot = [
    'images/characters/ROBOT.png',
  ];

  List<Widget> getTrophiesOne() {
    return List.generate(6, (int index) {
      return FadeInImage(
        placeholder: MemoryImage(kTransparentImage),
        fit: BoxFit.fitWidth,
        width: 100.0,
        height: 100.0,
        image: AssetImage(listBadges[index]),
      );
    });
  }

  List<Widget> getTrophiesGloopy() {
    return List.generate(1, (int index) {
      return FadeInImage(
        placeholder: MemoryImage(kTransparentImage),
        fit: BoxFit.fitWidth,
        width: 100.0,
        height: 100.0,
        image: AssetImage(listGloopy[index]),
      );
    });
  }

  List<Widget> getTrophiesRobot() {
    return List.generate(1, (int index) {
      return FadeInImage(
        placeholder: MemoryImage(kTransparentImage),
        fit: BoxFit.fitWidth,
        width: 100.0,
        height: 100.0,
        image: AssetImage(listRobot[index]),
      );
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Container(
          color: blueSkyColor.withOpacity(0.35),
          child: ListView(
            
            padding: EdgeInsets.only(top: 70, left: 20, right: 20),
            children: <Widget>[
              Text("Badges", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black),),
              SizedBox(
                height: 20.0,
              ),
              Wrap(
                  direction: Axis.horizontal,
                  runSpacing: 20.0,
                  spacing: 20.0,
                  children: getTrophiesOne()),
              SizedBox(
                height: 45.0,
              ),
              Text("Gloopy", style:TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black)),
              SizedBox(
                height: 20.0,
              ),
              Wrap(
                  direction: Axis.horizontal,
                  spacing: 20.0,
                  runSpacing: 20.0,
                  children: getTrophiesGloopy()),
                  SizedBox(
                height: 20.0,
              ),
              Text("Robot", style:TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: Colors.black)),
              SizedBox(
                height: 20.0,
              ),
              Wrap(
                  direction: Axis.horizontal,
                  spacing: 20.0,
                  runSpacing: 20.0,
                  children: getTrophiesRobot()),
                  SizedBox(
                height: 20.0,
              ),
            ],
          ),
        ));
  }
}
