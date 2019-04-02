import 'dart:async';

import 'package:flutter/material.dart';
import 'package:innovr_app/Database/UserManagement.dart';
import 'package:innovr_app/Pages/FirstTimePage.dart';
import 'package:innovr_app/Pages/MainPage.dart';
import 'package:innovr_app/Pages/RegistrationPage.dart';
import 'package:innovr_app/Utils/FadeNavRoute.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:innovr_app/Utils/Validator.dart';

class SignInPage extends StatefulWidget {
  @override
  _SignInPageState createState() => _SignInPageState();
}

class _SignInPageState extends State<SignInPage> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String _email;
  String _password;
  final double _spaceBetweenFields = 20.0;
  final double _buttonHeight = 50.0;

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: <Widget>[
            SizedBox(),
            // Container(
            //     width: 325,
            //     child: Image.asset(
            //       'assets/logos/logo.png',
            //     )
            // ),
            Container(
              padding: EdgeInsets.only(left: 35.0, right: 35.0),
              color: Colors.transparent,
              child: Form(
                key: _formKey,
                child: Column(
                  children: <Widget>[
                    //EMAIL
                    TextFormField(
                      validator: (input){
                        if(input.isEmpty)
                          return 'Veuillez entrer votre email';
                        if(!Validator.checkEmail(input))
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
                          color: Theme.of(context).primaryColorDark
                        ),
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: Theme.of(context).accentColor)
                        )
                      ),
                    ),
                    SizedBox(height: _spaceBetweenFields,),
                    //MOT DE PASSE
                    TextFormField(
                      validator: (input){
                        if(input.isEmpty)
                          return 'Veuillez entrer votre mot de passe';
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
                              color: Theme.of(context).primaryColorDark
                          ),
                          focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(color: Theme.of(context).primaryColor)
                          )
                      ),
                    ),
                    SizedBox(height: 5.0,),
                    //Mot de passe oublie
                    Container(
                      alignment: Alignment(1.0, 0.0),
                      padding: EdgeInsets.only(top:15.0,left:20.0),
                      child: InkWell(
                        child: Text('Mot de passe oublié ?',
                            style: TextStyle(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Montserrat',
                                decoration: TextDecoration.underline)
                        ),
                      ),
                    ),
                    SizedBox(height: 40.0,),
                    //BOUTON SE CONNECTER
                    Hero(
                      tag: 'CTA',
                      child: Container(
                        height: _buttonHeight,
                        child: Material(
                          borderRadius: BorderRadius.circular(20.0),
                          color: Theme.of(context).primaryColor,
                          child: InkWell(
                            borderRadius: BorderRadius.circular(20.0),
                            onTap: signIn,
                            child: Center(
                              child: Text(
                                'SE CONNECTER',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18.0,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: 'Montserrat'
                                ),
                              )
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: _spaceBetweenFields,),
                    //BOUTON SE CONNECTER AVEC FACEBOOK
                    Hero(
                      tag: 'NO CTA',
                      child: Container(
                        height: _buttonHeight,
                        color: Colors.transparent,
                        child: Container(
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.black,
                              style: BorderStyle.solid,
                              width: 1.0
                            ),
                            color: Colors.transparent,
                            borderRadius: BorderRadius.circular(20.0)
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              // Center(
                              //   child: ImageIcon(AssetImage('assets/logos/facebook-logo.png')),
                              // ),
                              SizedBox(width: 15.0,),
                              Center(
                                child: Material(
                                  child: Text(
                                    'Se connecter avec Facebook',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'Montserrat'
                                    ),
                                  ),
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 15.0,),
                    //LIGNE NOUVEAU CHEZ INNOVR
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Text(
                          'Nouveau chez Innovr?',
                          style: TextStyle(
                            fontFamily: 'Montserrat'
                          ),
                        ),
                        SizedBox(width: 5.0,),
                        InkWell(
                          onTap: (){
                            Navigator.push(context, FadeNavRoute(
                              builder: (context) => RegistrationPage()
                            ));
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
                                decoration: TextDecoration.underline
                              )),
                            ),
                          ),
                        )
                      ],
                    )
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Future<void> signIn() async {
    //UserManagement.findNickName();
    final formState = _formKey.currentState;
    if (formState.validate()) {
      formState.save();
      try {
        FirebaseUser user = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password);
        if(await UserManagement.isUserFirstTime()) {
          Navigator.pushReplacement(
              context, FadeNavRoute(builder: (context) => FirstTimePage()));
        }
        else
          Navigator.pushReplacement(context, FadeNavRoute(builder: (context) => MainPage()));
      } catch (e) {
        print(e.toString());
      }
    }
  }
}
