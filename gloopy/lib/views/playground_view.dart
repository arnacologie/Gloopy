import 'dart:math';
import 'package:flutter/material.dart';
import 'package:gloopy/numbers_list.dart';
import 'package:gloopy/radial_list.dart';
import 'package:matrix_gesture_detector/matrix_gesture_detector.dart';

class Test extends StatefulWidget {
  @override
  _TestState createState() => _TestState();
}

class _TestState extends State<Test> {
  bool accepted = false;
  String name = 'Antoine';
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: App(),
    );
  }
}

class App extends StatefulWidget {
  @override
  AppState createState() => AppState();
}

class AppState extends State<App> {
  Color caughtColor = Colors.grey;

  @override
  Widget build(BuildContext context) {
    return Stack(
        children: <Widget>[
          RadialList(
            radialList: null,
            radius: 150.00,
          ),

        ],
      );
  }
}

class DragBox extends StatefulWidget {
  final Offset initPos;
  final String label;
  final Color itemColor;

  DragBox(this.initPos, this.label, this.itemColor);
  DragBoxState createState() => DragBoxState();
}

class DragBoxState extends State<DragBox> {
  Offset position = Offset(0.0, 0.0);
  bool isDragging = false;
  double rotationValue = 1.0;
  DragUpdateDetails lastDragCoord;

  _onHDragStart(coord) {
    print('The user has started dragging horizontally at: $coord');
    setState(() {
      isDragging = true;
      lastDragCoord = coord;
    });
  }

  _onHDragUpdate(coord) {
    print('The user has dragged horizontally to: $coord');
    setState((){
      lastDragCoord = coord;
      rotationValue = ((rotationValue+(lastDragCoord.primaryDelta)*0.01)%360);
    });
  }

  _onHDragEnd(coord) {
    print('The user has stopped dragging horizontally. $coord');
    setState(() => isDragging = false);
  }

  _dragStatus() {
    if (isDragging) {
      return '$lastDragCoord';
    } else {
      return '';
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Column(
      children: [
        new Container(
          width: double.infinity,
          padding: const EdgeInsets.all(15.0),
          color: Colors.grey,
          child: new Text(
            'Drag in the space below to see the horizontal drag status.',
            textAlign: TextAlign.center,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 20.0,
            ),
          ),
        ),
        new Expanded(
          child: new GestureDetector(
            onHorizontalDragStart: _onHDragStart,
            onHorizontalDragUpdate: _onHDragUpdate,
            onHorizontalDragEnd: _onHDragEnd,
            child: new Center(
              child: new Container(
                color: Colors
                    .white, // without a color the Container seems to collapse
                child: new Align(
                  alignment: Alignment.center,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      new Text(
                        _dragStatus(),
                      ),
                      Transform.rotate(
                          angle: rotationValue,
                          alignment: Alignment.center,
                          origin: Offset(0, 200.0),
                          child: Container(
                            width: 50,
                            height: 50,
                            color: Colors.yellow,
                          )),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
