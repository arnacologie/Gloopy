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
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: 50.0,),
            Container(
              color: Colors.transparent,
              child: Draggable(

                data: "Antoine",
                child: Text(
                  name,
                  style: TextStyle(fontSize: 25.0,),
                ),
                feedback: Material(child: Container(child: Text(name, style: TextStyle(fontSize: 25.0, ),))),
                childWhenDragging: Text(name, style: TextStyle(fontSize: 25.0, color: Colors.transparent),),
              ),
            ),
            SizedBox(height: 200),
            DragTarget(builder: (context, List<String> candidateData, rejectedData) {
              return Container(width: 100, height: 100, color: Colors.grey, child: Center(child: Text('TARGET')));
            }, onWillAccept: (data) {
              print('$data');
              return true;
            }, onAccept: (data) {
              print("ok");
              setState(() {
              name = 'Kenan';
              });
            },),
          ],
        ),
      ),
    );
  }
}
