import 'package:flutter/material.dart';
import 'package:gloopy/utils/fade_nav_route.dart';
import 'package:gloopy/views/adult_login_view.dart';

class PreLoginView extends StatefulWidget {
  @override
  _PreLoginViewState createState() => _PreLoginViewState();
}

class _PreLoginViewState extends State<PreLoginView> {
  double separator, paddingColumn;

  @override
  Widget build(BuildContext context) {
    separator = MediaQuery.of(context).size.height/8;
    paddingColumn = MediaQuery.of(context).size.height/6.5;
    return Scaffold(
      body: Center(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: paddingColumn, vertical: separator ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: <Widget>[
              Expanded(
                child: Material(
                  color: Colors.blue[200],
                      child: InkWell(
                      splashColor: Colors.red,
                      onTap: ()=>Navigator.push(context,FadeNavRoute(builder: (context) => AdultLoginView()),),
                      child: Container(
                      alignment: Alignment.center,
                      child: Text('BOUTON\nACCES COMPTE\nADULTE', textAlign: TextAlign.center,style: TextStyle(fontSize: 20.0),),
                    ),
                  ),
                ),
              ),
              SizedBox(height: separator),
              Expanded(
                child: Material(
                  color: Colors.indigo[200],
                      child: InkWell(
                      splashColor: Colors.red,
                      onTap: ()=>Navigator.push(context,FadeNavRoute(builder: (context) => AdultLoginView()),),
                      child: Container(
                      alignment: Alignment.center,
                      child: Text('BOUTON\nACCES COMPTE\nENFANT', textAlign: TextAlign.center,style: TextStyle(fontSize: 20.0),),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}