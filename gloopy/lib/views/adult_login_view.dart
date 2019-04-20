import 'dart:math';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gloopy/const.dart';
import 'package:gloopy/managers/user_manager.dart';
import 'package:gloopy/service_locator.dart';
import 'package:gloopy/utils/fade_nav_route.dart';
import 'package:gloopy/utils/validator.dart';
import 'package:gloopy/views/adult_register_view.dart';
import 'package:animator/animator.dart';
import 'package:gloopy/widgets/animator.dart';
import 'package:rx_widgets/rx_widgets.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdultLoginView extends StatefulWidget {
  @override
  _AdultLoginViewState createState() => _AdultLoginViewState();
}

class _AdultLoginViewState extends State<AdultLoginView> {
  TAnimator _tAnimator;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  SharedPreferences prefs;
  String _email;
  String _password;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isLoggedIn = false;

  @override
  void initState() {
    sl.get<UserManager>().firebaseCloudMessagingListeners();
    sl.get<UserManager>().isSignedIn(context);
    _tAnimator = TAnimator(animated: true,);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        body: Container(
            child: Form(
                key: _formKey,
                child: Stack(
                  children: <Widget>[
                    _tAnimator,
                    Column(children: <Widget>[
                      SizedBox(
                        height: 75.0,
                      ),
                      Image.asset(
                        'images/backgrounds/LOGO-SANS-FOND.png',
                        width: size.width,
                        fit: BoxFit.fitWidth,
                      ),
                      Container(
                          padding: EdgeInsets.all(25.0),
                          child: Column(children: <Widget>[
                            Container(
                              padding: EdgeInsets.all(10.0),
                              child: Column(
                                children: <Widget>[
                                  Container(
                                    // decoration: BoxDecoration(
                                    //     borderRadius:
                                    //         BorderRadius.circular(4.0),
                                    //     color: Colors.white),
                                    //EMAIL
                                    child: TextFormField(
                                      validator: (input) {
                                        if (input.isEmpty)
                                          return 'Veuillez entrer votre email';
                                        if (!Validator.checkEmail(input))
                                          return 'Veuillez entrer un email valide';
                                      },
                                      onSaved: (input) => _email = input,
                                      style: TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          fillColor: Colors.white,
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.white,
                                                  width: 2.0),
                                              borderRadius:
                                                  BorderRadius.circular(25.0)),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.white,
                                                  width: 2.0),
                                              borderRadius:
                                                  BorderRadius.circular(25.0)),
                                          labelText: "Email/Pseudo",
                                          labelStyle:
                                              TextStyle(color: Colors.white)),
                                      cursorColor: darkSkyColor,
                                    ),
                                  ),
                                  Container(
                                    padding: EdgeInsets.only(top: 12.5),
                                    //MOT DE PASSE
                                    child: TextFormField(
                                      validator: (input) {
                                        if (input.isEmpty)
                                          return 'Veuillez entrer votre mot de passe';
                                      },
                                      onSaved: (input) => _password = input,
                                      obscureText: true,
                                      onEditingComplete: () {
                                        _formKey.currentState.save();
                                        if (_formKey.currentState.validate()) {
                                          sl.get<UserManager>().signIn(
                                              LoginInput(context, _email,
                                                  _password, _formKey));
                                        }
                                      },
                                      style: TextStyle(color: Colors.white),
                                      decoration: InputDecoration(
                                          border: OutlineInputBorder(),
                                          focusedBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.white,
                                                  width: 2.0),
                                              borderRadius:
                                                  BorderRadius.circular(25.0)),
                                          enabledBorder: OutlineInputBorder(
                                              borderSide: const BorderSide(
                                                  color: Colors.white,
                                                  width: 2.0),
                                              borderRadius:
                                                  BorderRadius.circular(25.0)),
                                          labelText: "Mot de passe",
                                          labelStyle:
                                              TextStyle(color: Colors.white)),
                                      cursorColor: darkSkyColor,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(
                              height: 25.0,
                            ),
                            Wrap(
                              spacing: 20.0,
                              children: <Widget>[
                                InkWell(
                                    onTap: () {
                                      _formKey.currentState.save();
                                      if (_formKey.currentState.validate()) {
                                        sl.get<UserManager>().signIn(LoginInput(
                                            context,
                                            _email,
                                            _password,
                                            _formKey));
                                      }
                                    },
                                    child: Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Container(
                                          padding: EdgeInsets.symmetric(
                                              vertical: 10.0, horizontal: 20.0),
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(25.0),
                                            color: clearSkyColor,
                                          ),
                                          child: Center(
                                            child: Text(
                                              "Se connecter",
                                              style: TextStyle(fontSize: 17.0),
                                            ),
                                          )),
                                    )),

                                //Mot de passe oublié
                                Text(
                                  "J'ai oublié mon mot de passe.",
                                  style: TextStyle(
                                    color: Colors.white,
                                    decoration: TextDecoration.underline,
                                  ),
                                ),
                              ],
                            )
                          ])),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Text(
                            'Nouveau chez Gloopy?',
                            style: TextStyle(
                                fontFamily: 'Montserrat',
                                fontWeight: FontWeight.bold,
                                color: clearSkyColor,
                                fontSize: 19.0),
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
                              width: 90,
                              height: 50,
                              child: Center(
                                child: Text('S\'inscrire',
                                    style: TextStyle(
                                        color: clearSkyColor,
                                        fontSize: 19,
                                        fontFamily: 'Montserrat',
                                        fontWeight: FontWeight.bold,
                                        decoration: TextDecoration.underline)),
                              ),
                            ),
                          )
                        ],
                      )
                    ]),
                    WidgetSelector(
                      buildEvents: sl.get<UserManager>().signIn.isExecuting,
                      onTrue: Positioned(
                          child: Container(
                        child: Center(
                          child: CircularProgressIndicator(
                            valueColor:
                                AlwaysStoppedAnimation<Color>(themeColor),
                          ),
                        ),
                        color: Colors.white.withOpacity(0.8),
                      )),
                      onFalse: Container(),
                    ),
                  ],
                ))));
  }
}
