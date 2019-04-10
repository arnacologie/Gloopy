import 'dart:math';

import 'package:flutter/material.dart';

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
        DragBox(Offset(0.0, 0.0), 'Rotate Me', Colors.lime),
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

  @override
  void initState() {
    super.initState();
    position = widget.initPos;
  }

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 0,
      left: -MediaQuery.of(context).size.height / 1.39,
      child: GestureDetector(
        onPanStart: _onPanStart,
        onPanUpdate: _onPanUpdate,
        child: Container(
            color: widget.itemColor,
            child: Transform.rotate(
              angle: finalAngle,
              child: Center(
                child: ClipOval(
                  child: Container(
                    width: MediaQuery.of(context).size.height * 2,
                    height: MediaQuery.of(context).size.height * 2,
                    color: Colors.yellow,
                    child: Stack(
                      children: <Widget>[
                        
                        Positioned.fill(
                          child: InkWell(
                            onTap: () {},
                            child: Text(
                              'APPUIE',
                              style: TextStyle(color: Colors.white,fontSize: 90.0),
                            ),
                          ),
                        ),
                        
                        Positioned.fill(
                          child: Icon(
                            Icons.ac_unit,
                            size: 1200,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            )),
        onPanEnd: _onPanEnd,
      ),
    );
  }

  Offset vector;
  double startingAngle;
  double deltaAngle = 0.0;
  double finalAngle = 0.0;
  // store the final angle of the object
  double finalObjectAngle = 0.0;

  void _onPanStart(DragStartDetails details) {
    _polarCoordFromGlobalOffset(details.globalPosition);
    startingAngle = vector.direction;
    print('START = $startingAngle ===================================');
  }

  void _onPanUpdate(DragUpdateDetails details) {
    _polarCoordFromGlobalOffset(details.globalPosition);

    setState(() {
      // HERE you should use the finalObjectAngle
      deltaAngle = vector.direction - startingAngle + finalObjectAngle;
      finalAngle = deltaAngle;
    });
  }

  void _onPanEnd(DragEndDetails details) {
    finalAngle = deltaAngle;
    // Save the finalAngle of the object
    finalObjectAngle = finalAngle;
    print('End = $finalAngle ===================================');
  }

  void _polarCoordFromGlobalOffset(Offset globalOffset) {
    var localTouchOffset =
        (context.findRenderObject() as RenderBox).globalToLocal(globalOffset);
    var localTouchPoint = new Point(localTouchOffset.dx, localTouchOffset.dy);
    var originPoint =
        new Point(context.size.width / 2, context.size.height / 2);
    _polarCoord(originPoint, localTouchPoint);
  }

  void _polarCoord(Point origin, Point point) {
    var vectorPoint = point - origin;
    vector = new Offset(vectorPoint.x, vectorPoint.y);
  }
}
