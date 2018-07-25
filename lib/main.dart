import 'dart:async';
import 'package:flutter/material.dart';
import 'package:bleezy/screen/LoginScreen.dart';
import 'package:bleezy/screen/MyHomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'dart:io' show Platform;


void main() async {
  final FirebaseApp app = await FirebaseApp.configure(
    name: 'db',
    options: Platform.isAndroid
        ? const FirebaseOptions(
        googleAppID: '1:182701212453:android:fcdefc206307f65a',
        apiKey: "AIzaSyD_nMiTID5gViQz3p0_fLfKgpOqM3JfwgM",
        databaseURL: "https://bleezy-7a68e.firebaseio.com",
        storageBucket: "bleezy-7a68e.appspot.com",
    ) : null,
  );
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  FirebaseAuth auth = FirebaseAuth.instance;
  User currentUser = new User();
  MyHomePage homePage;
  LoginScreen loginScreen = new LoginScreen();

  void logout(){
    auth.signOut();
  }

  @override
  Widget build(BuildContext context) {
    logout();
    //var gotUser;
    //existUser().then((b){
    //  gotUser = b; print(gotUser);
    //});

    return new MaterialApp(
      title: 'BLEEZY',
      theme: new ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or press Run > Flutter Hot Reload in IntelliJ). Notice that the
        // counter didn't reset back to zero; the application is not restarted.
        primarySwatch: Colors.deepOrange,
        primaryColor: Colors.deepOrange,
      ),
      home: new LoginScreen(user: currentUser, auth: auth,),
    );
  }
}


class User{
  FirebaseUser user;
}
