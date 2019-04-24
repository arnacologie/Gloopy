import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gloopy/utils/fade_nav_route.dart';
import 'package:gloopy/views/main_view.dart';
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
  RxCommand<void, Stream<QuerySnapshot>> getContacts;
  //RxCommand isSignedIn;
  final FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  SharedPreferences prefs;
  FirebaseUser currentUser;
  String currentFCMToken;
  final FirebaseAuth firebaseAuth = FirebaseAuth.instance;
  String lastContactID;
  String lastContactAvatar;

  UserManager() {
    signIn = RxCommand.createAsync((LoginInput loginInput) async {
      prefs = await SharedPreferences.getInstance();
      currentUser = await FirebaseAuth.instance
          .signInWithEmailAndPassword(
              email: loginInput.email, password: loginInput.password)
          .catchError((onError) {
        print("onError: " + onError.toString());
      });
      print("currentUser" + currentUser.toString());
      if (currentUser != null) {
        final QuerySnapshot result = await Firestore.instance
            .collection('users')
            .where('id', isEqualTo: currentUser.uid)
            .getDocuments();
        final List<DocumentSnapshot> documents = result.documents;
        if (documents.length == 0) {
          await prefs.setString('id', currentUser.uid);
          await prefs.setString('nickname', currentUser.displayName);
          await prefs.setString('photoUrl', currentUser.photoUrl);
        } else {
          Firestore.instance
              .collection('users')
              .document(currentUser.uid)
              .updateData({'fcm_token': currentFCMToken});

          await prefs.setString('id', documents[0]['id']);
          await prefs.setString('nickname', documents[0]['nickname']);
          await prefs.setString('photoUrl', documents[0]['photo_url']);
          await prefs.setString('aboutMe', documents[0]['about_me']);
        }
        Fluttertoast.showToast(msg: "Sign in success");
        Navigator.push(
          loginInput.context,
          FadeNavRoute(builder: (context) => MainPage()),
        );
      } else
        Fluttertoast.showToast(msg: "Sign in fail");
      lastContactID = prefs.getString('lastContactID');
      lastContactAvatar = prefs.getString('lastContactAvatar');
      return true;
    });
    signIn.isExecuting.listen((onData) {
      print("signIn Exec " + onData.toString());
    });

    isSignedIn = RxCommand.createAsync((BuildContext context) async {
      bool isLoggedIn;
      prefs = await SharedPreferences.getInstance();
      currentUser = await firebaseAuth.currentUser();
      isLoggedIn = currentUser == null ? false : true;
      if (isLoggedIn) {
        Navigator.push(
          context,
          FadeNavRoute(builder: (context) => MainPage()),
        );
      }
    });

    createAccount = RxCommand.createAsync((RegisterInput registerInput) async {
      FirebaseUser firebaseUser =
          await FirebaseAuth.instance.createUserWithEmailAndPassword(
        email: registerInput.email,
        password: registerInput.password,
      );
      Firestore.instance
          .collection('users')
          .document(firebaseUser.uid)
          .setData({
        'nickname': registerInput.nickname,
        'photo_url':
            'https://firebasestorage.googleapis.com/v0/b/gloopy-aebbc.appspot.com/o/ic_launcher.png.png?alt=media&token=a1dfcc89-948d-452f-b849-d2cf5a38a396',
        'id': firebaseUser.uid
      });
      prefs = await SharedPreferences.getInstance();
      await prefs.setString('id', firebaseUser.uid);
      await prefs.setString('nickname', registerInput.nickname);
      return true;
    });

    getContacts = RxCommand.createSync((_) => Firestore.instance
        .collection('users')
        .where("contacts_id", arrayContains: currentUser.uid)
        .snapshots());
    getContacts();
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
      print("fcmToken = " + fcmToken);
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
