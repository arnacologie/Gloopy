import 'package:flutter/material.dart';
import 'package:gloopy/managers/user_manager.dart';
import 'package:gloopy/service_locator.dart';
import 'package:gloopy/utils/validator.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationPageState createState() => _RegistrationPageState();
}

class _RegistrationPageState extends State<RegistrationPage> {
  String _email;
  String _password;
  String _confirmPassword;
  String _nickname;
  final double _spaceBetweenFields = 20.0;
  final double _buttonHeight = 50.0;
  final GlobalKey<FormState> _registerFormKey = GlobalKey<FormState>();
  SharedPreferences prefs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomPadding: false,
      appBar: AppBar(
        title: Text(
          'Inscription',
          style: TextStyle(
              color: Theme.of(context).primaryColor,
              fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Form(
        key: _registerFormKey,
        child: Container(
          padding: EdgeInsets.only(top: 90.0, left: 35.0, right: 35.0),
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          child: Column(
            children: <Widget>[
              SizedBox(
                height: 20.0,
              ),
              //EMAIL
              TextFormField(
                validator: (input) {
                  if (input.isEmpty) return 'Veuillez entrer votre email';
                  if (!Validator.checkEmail(input))
                    return 'Veuillez entrer un email valide';
                },
                onSaved: (input) => _email = input,
                decoration: InputDecoration(
                    errorStyle: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                    ),
                    labelText: 'EMAIL',
                    labelStyle: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColorDark),
                    focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Theme.of(context).accentColor))),
              ),
              SizedBox(
                height: _spaceBetweenFields,
              ),
              //NOM D'AFFICHAGE
              TextFormField(
                validator: (input) {
                  if (input.isEmpty) return 'Veuillez entrer votre pseudonyme';
                },
                onSaved: (input) => _nickname = input,
                decoration: InputDecoration(
                    errorStyle: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                    ),
                    labelText: 'NOM D\'AFFICHAGE',
                    labelStyle: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColorDark),
                    focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Theme.of(context).primaryColor))),
              ),
              SizedBox(
                height: _spaceBetweenFields,
              ),
              //MOT DE PASSE
              TextFormField(
                validator: (input) {
                  if (input.isEmpty) return 'Veuillez entrer un mot de passe';
                  if (input.length < 6) return '6 caractères au minimum';
                },
                onSaved: (input) => _password = input,
                obscureText: true,
                decoration: InputDecoration(
                    errorStyle: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                    ),
                    labelText: 'MOT DE PASSE',
                    labelStyle: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColorDark),
                    focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Theme.of(context).primaryColor))),
              ),
              SizedBox(
                height: _spaceBetweenFields,
              ),
              TextFormField(
                validator: (input) {
                  if (input.isEmpty)
                    return 'Veuillez confirmer votre mot de passe';
                  if (_password != input) {
                    //print(_password+" "+input);
                    return 'Les mots de passe de correspondent pas';
                  }
                },
                obscureText: true,
                decoration: InputDecoration(
                    errorStyle: TextStyle(
                      fontFamily: 'Montserrat',
                      fontWeight: FontWeight.bold,
                    ),
                    labelText: 'CONFIRMATION MOT DE PASSE',
                    labelStyle: TextStyle(
                        fontFamily: 'Montserrat',
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).primaryColorDark),
                    focusedBorder: UnderlineInputBorder(
                        borderSide:
                            BorderSide(color: Theme.of(context).primaryColor))),
              ),

              SizedBox(
                height: 20.0,
              ),
              //BOUTON S'INSCRIRE
              Hero(
                tag: 'CTA',
                child: Container(
                  height: _buttonHeight,
                  child: Material(
                    borderRadius: BorderRadius.circular(20.0),
                    color: Theme.of(context).primaryColor,
                    child: InkWell(
                      borderRadius: BorderRadius.circular(20.0),
                      onTap: () {
                        _registerFormKey.currentState.save();
                        if (_registerFormKey.currentState.validate()) {
                          sl.get<UserManager>().createAccount(RegisterInput(_email, _password, _nickname));
                        }
                      },
                      child: Center(
                          child: Text(
                        'S\'INSCRIRE',
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18.0,
                            fontWeight: FontWeight.bold,
                            fontFamily: 'Montserrat'),
                      )),
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: _spaceBetweenFields,
              ),
              //BOUTON RETOUR
              Hero(
                tag: 'NO CTA',
                child: Container(
                  height: _buttonHeight,
                  color: Colors.transparent,
                  child: GestureDetector(
                    onTap: () => Navigator.of(context).pop(),
                    child: Container(
                      decoration: BoxDecoration(
                          border: Border.all(
                              color: Colors.black,
                              style: BorderStyle.solid,
                              width: 1.0),
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(20.0)),
                      child: Center(
                        child: Material(
                          child: Text(
                            'Retour',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat'),
                          ),
                        ),
                      ),
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
