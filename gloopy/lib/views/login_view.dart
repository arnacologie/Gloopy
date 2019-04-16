import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gloopy/const.dart';
import 'package:gloopy/managers/user_manager.dart';
import 'package:gloopy/service_locator.dart';
import 'package:gloopy/utils/fade_nav_route.dart';
import 'package:gloopy/utils/validator.dart';
import 'package:gloopy/views/register_view.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:rx_widgets/rx_widgets.dart';

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key, this.title}) : super(key: key);
  final String title;

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  SharedPreferences prefs;
  String _email;
  String _password;
  final double _spaceBetweenFields = 20.0;
  final double _buttonHeight = 50.0;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  bool isLoading = false;
  bool isLoggedIn = false;

  @override
  void initState() {
    super.initState();
    sl.get<UserManager>().firebaseCloudMessagingListeners();
    sl.get<UserManager>().isSignedIn(context);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomPadding: false,
        appBar: AppBar(
          title: Text(
            widget.title,
            style: TextStyle(color: primaryColor, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        body: Stack(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Container(
                  padding: EdgeInsets.only(left: 35.0, right: 35.0),
                  color: Colors.transparent,
                  child: Form(
                    key: _formKey,
                    child: Column(
                      children: <Widget>[
                        //EMAIL
                        TextFormField(
                          validator: (input) {
                            if (input.isEmpty)
                              return 'Veuillez entrer votre email';
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
                                  borderSide: BorderSide(
                                      color: Theme.of(context).accentColor))),
                        ),
                        SizedBox(
                          height: _spaceBetweenFields,
                        ),
                        //MOT DE PASSE
                        TextFormField(
                          validator: (input) {
                            if (input.isEmpty)
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
                                  color: Theme.of(context).primaryColorDark),
                              focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(
                                      color: Theme.of(context).primaryColor))),
                        ),
                        SizedBox(
                          height: 5.0,
                        ),
                        //Mot de passe oublie
                        Container(
                          alignment: Alignment(1.0, 0.0),
                          padding: EdgeInsets.only(top: 15.0, left: 20.0),
                          child: InkWell(
                            child: Text('Mot de passe oublié ?',
                                style: TextStyle(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Montserrat',
                                    decoration: TextDecoration.underline)),
                          ),
                        ),
                        SizedBox(
                          height: 40.0,
                        ),
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
                                onTap: (){
                                  _formKey.currentState.save();
                                  if (_formKey.currentState.validate()) {
                                    sl.get<UserManager>().signIn(LoginInput(context, _email, _password, _formKey));
                                  }
                                },
                                child: Center(
                                    child: Text(
                                  'SE CONNECTER',
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
                        SizedBox(
                          height: 15.0,
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
                                            RegistrationPage()));
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
                      ],
                    ),
                  ),
                )
              ],
            ),
            // Loading
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
                      )
              ),
              onFalse: Container(),
            ),
          ],
        )
      );
  }
}
