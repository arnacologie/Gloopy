import 'package:flutter/material.dart';
import 'package:gloopy/views/adult_login_view.dart';

class ConfirmationView extends StatefulWidget {
  @override
  _ConfirmationViewState createState() => _ConfirmationViewState();
}

class _ConfirmationViewState extends State<ConfirmationView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text("page 2"),
        ),
        body: Container(
            child: Center(
          child: Column(
            children: <Widget>[
              Container(
                padding: EdgeInsets.only(top: 200),
                child: Text("INSCRIPTION REUSSI !"),
              ),
              Container(
                padding: EdgeInsets.only(top: 25),
                child: Text("VOUS ALLEZ RECEVOIR UN MAIL DE CONFIRMATION"),
              ),
              Container(
                  margin: EdgeInsets.only(top: 50),
                  width: 200,
                  height: 150,
                  decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(color: Colors.blueAccent))),
              Container(
                  padding: EdgeInsets.only(top: 22.5),
                  child: RaisedButton(
                      child: Text('NAVIGATION TEMP'),
                      onPressed: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => AdultLoginView(),
                            ));
                      }))
            ],
          ),
        )));
  }
}
