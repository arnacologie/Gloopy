import 'package:flutter/material.dart';
import 'package:gloopy/utils/fade_nav_route.dart';
import 'package:gloopy/views/adult_login_view.dart';
import 'package:gloopy/views/child_login_view.dart';

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

        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            InkWell(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => AdultLoginView()),
                  );
                },
                child: Container(
                    width: 200,
                    height: 200,
                    color:  Color.fromRGBO(155, 176, 219, 1),

                    child: Center(
                      child: Text("Compte Adulte"),
                    )
                )
            ),
            InkWell(
                onTap: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => ChildLoginView()),
                  );
                },
                child: Container(
                    width: 200,
                    height: 200,
                    color:  Color.fromRGBO(155, 176, 219, 0.5),

                    child: Center(
                      child: Text("Compte Enfant"),
                    )
                )
            )

          ],
        )

      ),
    );
  }
}