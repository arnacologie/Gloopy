import 'package:flutter/material.dart';
import 'package:gloopy/utils/fade_nav_route.dart';
import 'package:gloopy/views/adult_register_view.dart';

class AdultLoginView extends StatefulWidget {
  @override
  _AdultLoginViewState createState() => _AdultLoginViewState();
}

class _AdultLoginViewState extends State<AdultLoginView> {
GlobalKey<FormState> _connexionFormKey;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Container(
            child: Form(
                key: _connexionFormKey,
                child: Column(children: <Widget>[
                  Container(
                      padding: EdgeInsets.only(top: 100, left: 65, right: 65),
                      child: Column(children: <Widget>[
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 12.5),
                          child: TextFormField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Pseudo"),
                          ),
                        ),
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 12.5),
                          child: TextFormField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Confirmer votre mot de passe"),
                          ),
                        ),
                        Container(
                          alignment: Alignment.centerLeft,
                          child: Text("J'ai oublié mon mot de passe.", 
                            style: TextStyle(
                              color: Colors.blue, 
                              decoration: TextDecoration.underline,
                            ),
                          )
                        )
                      ])),
                  Container(
                    padding: EdgeInsets.only(top: 22.5),
                    child: RaisedButton(
                      child: Text('Valider'),
                      onPressed: (){}
                    )
                  ),
                  Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              'Nouveau chez Innovr?',
                              style: TextStyle(fontFamily: 'Montserrat'),
                            ),
                            SizedBox(
                              width: 5.0,
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    FadeNavRoute(
                                        builder: (context) =>
                                            AdultRegisterView()));
                              },
                              child: Container(
                                width: 70,
                                height: 50,
                                child: Center(
                                  child: Text('S\'inscrire',
                                      style: TextStyle(
                                          color: Theme.of(context).primaryColor,
                                          fontFamily: 'Montserrat',
                                          fontWeight: FontWeight.bold,
                                          decoration:
                                              TextDecoration.underline)),
                                ),
                              ),
                            )
                          ],
                        )
                ]
            )
          )
        )
      );
  }
}