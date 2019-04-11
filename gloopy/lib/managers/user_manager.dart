import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gloopy/Utils/mainPage.dart';
import 'package:gloopy/main.dart';
import 'package:rx_command/rx_command.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginInput {
  final BuildContext context;
  final String email;
  final String password;
  final GlobalKey<FormState> loginForm;
  const LoginInput(this.context, this.email, this.password, this.loginForm);
}

class RegisterInput {
  final String email;
  final String password;
  final String nickname;
  const RegisterInput(this.email, this.password, this.nickname);
}

class UserManager {
  //RxCommands
  RxCommand<BuildContext, bool> isSignedIn;
  RxCommand<LoginInput, bool> signIn;
  RxCommand<RegisterInput, bool> createAccount;
  //RxCommand isSignedIn;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  SharedPreferences prefs;
  FirebaseUser currentUser;
  String currentFCMToken;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  String currentUserId;

  UserManager() {

    signIn = RxCommand.createAsync((LoginInput loginInput) async {

      prefs = await SharedPreferences.getInstance();
        FirebaseUser firebaseUser = await FirebaseAuth.instance
            .signInWithEmailAndPassword(
                email: loginInput.email, password: loginInput.password)
            .catchError((onError) {
          print(onError);
        });
        if (firebaseUser != null) {

          final QuerySnapshot result = await Firestore.instance
              .collection('users')
              .where('id', isEqualTo: firebaseUser.uid)
              .getDocuments();
          final List<DocumentSnapshot> documents = result.documents;
          if (documents.length == 0) {
            currentUser = firebaseUser;
            await prefs.setString('id', currentUser.uid);
            await prefs.setString('nickname', currentUser.displayName);
            await prefs.setString('photoUrl', currentUser.photoUrl);
          } else {

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

          currentUserId = firebaseUser.uid;
          Navigator.push(
            loginInput.context,
            MaterialPageRoute(
                builder: (context) => MainPage()),
          );
        }else Fluttertoast.showToast(msg: "Sign in fail");

      return true;
    });
    signIn.isExecuting.listen((onData){
      print(onData);
    });

    isSignedIn = RxCommand.createAsync((BuildContext context) async {
      bool isLoggedIn;
      prefs = await SharedPreferences.getInstance();
      isLoggedIn = await firebaseAuth.currentUser() == null ? false : true;
      if (isLoggedIn) {
        currentUserId = prefs.getString('id');
        Navigator.push(
          context,
          MaterialPageRoute( builder: (context) => MainPage()),
        );
      }
    });

    createAccount = RxCommand.createAsync((RegisterInput registerInput) async {
      FirebaseUser firebaseUser =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: registerInput.email,
        password: registerInput.password,
      );
      Firestore.instance.collection('users').document(firebaseUser.uid).setData(
          {'nickname': registerInput.nickname, 'photoUrl': 'https://firebasestorage.googleapis.com/v0/b/gloopy-aebbc.appspot.com/o/ic_launcher.png.png?alt=media&token=a1dfcc89-948d-452f-b849-d2cf5a38a396', 'id': firebaseUser.uid});
      prefs = await SharedPreferences.getInstance();
      await prefs.setString('id', firebaseUser.uid);
      await prefs.setString('nickname', registerInput.nickname);
      return true;
    });
  }

  void firebaseCloudMessagingListeners() {
    if (Platform.isIOS) _iOSPermission();
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
    _firebaseMessaging.getToken().then((fcmToken) {
      print(fcmToken);
      currentFCMToken = fcmToken;
    });
  }

  void _iOSPermission() {
    _firebaseMessaging.requestNotificationPermissions(
        IosNotificationSettings(sound: true, badge: true, alert: true));
    _firebaseMessaging.onIosSettingsRegistered
        .listen((IosNotificationSettings settings) {
      print("Settings registered: $settings");
    });
  }
}
