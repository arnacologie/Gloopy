import 'package:flutter/material.dart';
import 'package:gloopy/const.dart';
import 'package:gloopy/views/gallery_view.dart';
import 'package:gloopy/views/new_drawing_view.dart';
import 'package:gloopy/widgets/animator.dart';

class DrawingView extends StatefulWidget {
  @override
  _DrawingViewState createState() => _DrawingViewState();
}

class _DrawingViewState extends State<DrawingView> {
  double separator, paddingColumn;
  TAnimator _tAnimator;

  @override
  void initState() {
    _tAnimator = TAnimator(
      animated: false,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    separator = MediaQuery.of(context).size.height / 8;
    paddingColumn = MediaQuery.of(context).size.height / 6.5;
    return Scaffold(
      body: Stack(
        alignment: Alignment.center,
        children: <Widget>[
          _tAnimator,
          Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => NewDrawingView()),
                    );
                  },
                  child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                          //color: Color.fromRGBO(155, 176, 219, 0.5),
                          border: Border.all(color: clearSkyColor, width: 4.0),
                          borderRadius: BorderRadius.circular(25.0)),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 33.0,
                          ),
                          Icon(
                            Icons.add,
                            size: 70,
                            color: clearSkyColor,
                          ),
                          SizedBox(
                            height: 10,
                          ),
                          Text(
                            "Nouveau Dessin",
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: clearSkyColor),
                          ),
                        ],
                      ))),
              InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => GalleryView()),
                    );
                  },
                  child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                          //color: Color.fromRGBO(155, 176, 219, 0.5),
                          border: Border.all(color: clearSkyColor, width: 4.0),
                          borderRadius: BorderRadius.circular(25.0)),
                      child: Column(
                        children: <Widget>[
                          SizedBox(
                            height: 33.0,
                          ),
                          Icon(
                            Icons.image,
                            size: 70,
                            color: clearSkyColor,
                          ),
                          SizedBox(
                            height: 10.0,
                          ),
                          Text(
                            "Galerie Dessin",
                            style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                                color: clearSkyColor),
                          ),
                        ],
                      )))
            ],
          ),
        ],
      ),
    );
  }
}
