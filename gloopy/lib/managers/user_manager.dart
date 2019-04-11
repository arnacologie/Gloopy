
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:gloopy/keys.dart';
import 'package:gloopy/main.dart';
import 'package:rx_command/rx_command.dart';
import 'package:shared_preferences/shared_preferences.dart';


class UserManager{

  //RxCommands
  RxCommand<void, bool> isSignedIn;
  RxCommand<BuildContext, bool> signIn;
  //RxCommand isSignedIn;
  FirebaseMessaging _firebaseMessaging = FirebaseMessaging();
  SharedPreferences prefs;
  FirebaseUser currentUser;
  String currentFCMToken;

  UserManager(){
    signIn = RxCommand.createAsync((BuildContext context) async{
      prefs = await SharedPreferences.getInstance();

    // this.setState(() {
    //   isLoading = true;
    // });

    AppKeys.loginForm.currentState.save();
    if (AppKeys.loginForm.currentState.validate()) {

      FirebaseUser firebaseUser = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password)
            .catchError((onError){
              print(onError);
              //isLoading = false;
            });

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
      // Fluttertoast.showToast(msg: "Sign in success");
      // this.setState(() {
      //   isLoading = false;
      // });

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
    });
  }


  void firebaseCloudMessaging_Listeners() {
  if (Platform.isIOS) _iOS_Permission();


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
    //currentFCMToken = ok;
  });
}

void _iOS_Permission() {
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

    _formKey.currentState.save();
    if (_formKey.currentState.validate()) {

      FirebaseUser firebaseUser = await FirebaseAuth.instance
            .signInWithEmailAndPassword(email: _email, password: _password)
            .catchError((onError){
              print(onError);
              isLoading = false;
            });

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


}