import 'dart:async';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:gloopy/Utils/FadeNavRoute.dart';
import 'package:gloopy/Utils/Validator.dart';
import 'package:gloopy/const.dart';
import 'package:gloopy/main.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gloopy/register.dart';
import 'package:gloopy/test.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Chat Demo',
      theme: ThemeData(
        primaryColor: themeColor,
      ),
      //home: LoginScreen(title: 'CHAT DEMO'),
      //home: LoginScreen(title: "Connexion",),
      home: LoginScreen(title: "Connexion",),
      debugShowCheckedModeBanner: false,
    );
  }
}

class LoginScreen extends StatefulWidget {
  LoginScreen({Key key, this.title}) : super(key: key);

  final String title;

  @override
  LoginScreenState createState() => LoginScreenState();
}

class LoginScreenState extends State<LoginScreen> {
  final GoogleSignIn googleSignIn = GoogleSignIn();
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  SharedPreferences prefs;
  String _email;
  String _password;
  String _confirmPassword;
  String _nickname;
  final double _spaceBetweenFields = 20.0;
  final double _buttonHeight = 50.0;
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();

  bool isLoading = false;
  bool isLoggedIn = false;
  FirebaseUser currentUser;
  String currentFCMToken;

  @override
  void initState() {
    super.initState();
    firebaseCloudMessaging_Listeners();
    isSignedIn();

  }

  void isSignedIn() async {
    this.setState(() {
      isLoading = true;
    });

    prefs = await SharedPreferences.getInstance();

    isLoggedIn = await firebaseAuth.currentUser() == null ? false : true;
    if (isLoggedIn) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => MainScreen(currentUserId: prefs.getString('id'))),
      );
    }

    this.setState(() {
      isLoading = false;
    });
  }

  void firebaseCloudMessaging_Listeners() {
  if (Platform.isIOS) iOS_Permission();



  _firebaseMessaging.configure(
    onMessage: (Map<String, dynamic> message) async {
      print('on message $message');
    },
    onResume: (Map<String, dynamic> message) async {
      print('on resume $message');
    },
    onLaunch: (Map<String, dynamic> message) async {
      print('on launch $message');
    },
  );
  _firebaseMessaging.getToken().then((ok){
    print(ok);
    currentFCMToken = ok;
  });
}

void iOS_Permission() {
  _firebaseMessaging.requestNotificationPermissions(
      IosNotificationSettings(sound: true, badge: true, alert: true)
  );
  _firebaseMessaging.onIosSettingsRegistered
      .listen((IosNotificationSettings settings)
  {
    print("Settings registered: $settings");
  });
}


  Future<Null> handleSignIn() async {
    prefs = await SharedPreferences.getInstance();

    this.setState(() {
      isLoading = true;
    });

    // GoogleSignInAccount googleUser = await googleSignIn.signIn();
    // GoogleSignInAuthentication googleAuth = await googleUser.authentication;

    // final AuthCredential credential = GoogleAuthProvider.getCredential(
    //   accessToken: googleAuth.accessToken,
    //   idToken: googleAuth.idToken,
    // );

    _formKey.currentState.save();
    if (_formKey.currentState.validate()) {

      FirebaseUser firebaseUser = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password)
            .catchError((onError){
              print(onError);
              isLoading = false;
            });
          //.then((signedInUser) {
        //UserManagement.storeNewUser(signedInUser, _nickname, context);
      //}).catchError((e) {
        //print(e);
      //});
      

    //FirebaseUser firebaseUser = await firebaseAuth.signInWithCredential(credential);

    if (firebaseUser != null) {
      // Check is already sign up
      final QuerySnapshot result =
          await Firestore.instance.collection('users').where('id', isEqualTo: firebaseUser.uid).getDocuments();
      final List<DocumentSnapshot> documents = result.documents;
      if (documents.length == 0) {
        // Update data to server if new user

        // Write data to local
        currentUser = firebaseUser;
        await prefs.setString('id', currentUser.uid);
        await prefs.setString('nickname', currentUser.displayName);
        await prefs.setString('photoUrl', currentUser.photoUrl);
      } else {
        // Write data to local
        Firestore.instance
            .collection('users')
            .document(firebaseUser.uid)
            .updateData({'fcm_token': currentFCMToken});
        
        await prefs.setString('id', documents[0]['id']);
        await prefs.setString('nickname', documents[0]['nickname']);
        await prefs.setString('photoUrl', documents[0]['photoUrl']);
        await prefs.setString('aboutMe', documents[0]['aboutMe']);
      }
      Fluttertoast.showToast(msg: "Sign in success");
      this.setState(() {
        isLoading = false;
      });

      Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => MainScreen(
                  currentUserId: firebaseUser.uid,
                )),
      );
    } else {
      Fluttertoast.showToast(msg: "Sign in fail");
      this.setState(() {
        isLoading = false;
      });
    }

    }else{
      Fluttertoast.showToast(msg: "Non valid");
      this.setState(() {
        isLoading = false;
      });
    }
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
                            onTap: handleSignIn,
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
            // Loading
            Positioned(
              child: isLoading
                  ? Container(
                      child: Center(
                        child: CircularProgressIndicator(
                          valueColor: AlwaysStoppedAnimation<Color>(themeColor),
                        ),
                      ),
                      color: Colors.white.withOpacity(0.8),
                    )
                  : Container(),
            ),
          ],
    ));
  }
}
