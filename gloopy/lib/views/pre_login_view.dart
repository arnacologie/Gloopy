import 'package:flutter/material.dart';
import 'package:gloopy/const.dart';
import 'package:gloopy/utils/fade_nav_route.dart';
import 'package:gloopy/views/adult_login_view.dart';
import 'package:gloopy/views/child_login_view.dart';
import 'package:gloopy/widgets/animator.dart';

class PreLoginView extends StatefulWidget {
  @override
  _PreLoginViewState createState() => _PreLoginViewState();
}

class _PreLoginViewState extends State<PreLoginView> {
  double separator, paddingColumn;
  TAnimator _tAnimator;

  @override
  void initState() {
    _tAnimator = TAnimator(animated: true,);
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
                      MaterialPageRoute(
                          builder: (context) => AdultLoginView()),
                    );
                  },
                  child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                          //color: Color.fromRGBO(155, 176, 219, 0.5),
                          border: Border.all(color: clearSkyColor, width: 4.0),
                          borderRadius: BorderRadius.circular(25.0)),
                      child: Center(
                        child: Text("Compte Adulte", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: clearSkyColor),),
                      ))),
              InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ChildLoginView()),
                    );
                  },
                  child: Container(
                      width: 200,
                      height: 200,
                      decoration: BoxDecoration(
                          //color: Color.fromRGBO(155, 176, 219, 0.5),
                          border: Border.all(color: clearSkyColor, width: 4.0),
                          borderRadius: BorderRadius.circular(25.0)),
                      child: Center(
                        child: Text("Compte Enfant", style: TextStyle(fontSize: 20.0, fontWeight: FontWeight.bold, color: clearSkyColor),),
                      )))
            ],
          ),
        ],
      ),
    );
  }
}
