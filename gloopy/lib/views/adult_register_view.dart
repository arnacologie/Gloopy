import 'package:flutter/material.dart';
import 'package:gloopy/views/confirmation_view.dart';

class AdultRegisterView extends StatefulWidget {
  @override
  _AdultRegisterViewState createState() => _AdultRegisterViewState();
}

class _AdultRegisterViewState extends State<AdultRegisterView> {
  @override
  Widget build(BuildContext context) {
    var inscription_form;

    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Container(
            child: Form(
                key: inscription_form,
                child: Column(children: <Widget>[
                  Container(
                      padding: EdgeInsets.only(top: 100, left: 65, right: 65),
                      child: Column(children: <Widget>[
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 12.5),
                          child: TextFormField(
                            decoration: InputDecoration(
                                border: OutlineInputBorder(),
                                labelText: "Email"),
                          ),
                        ),
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
                                labelText: "Mot de passe"),
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
                      ])),
                  Container(
                    padding: EdgeInsets.only(top: 22.5),
                    child: RaisedButton(
                      child: Text('Valider'),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => ConfirmationView(),
                          )
                        );
                      }
                    )
                  ),
                ]
            ),
          )
        )
      );
  }
}