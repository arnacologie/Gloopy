import 'package:flutter/material.dart';

class NewDrawingView extends StatefulWidget {
  @override
  _NewDrawingViewState createState() => _NewDrawingViewState();
}

class _NewDrawingViewState extends State<NewDrawingView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          child: Text("New Drawing", style: TextStyle(fontSize: 20)),
        ),
      ),
    );
  }
}
