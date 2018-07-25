import 'dart:async';
import 'package:flutter/material.dart';
import 'package:path/path.dart';
import 'package:bleezy/screen/MyHomePage.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';


class LoginScreen extends StatelessWidget {
  LoginScreen({Key key, this.user, this.auth}) : super(key: key);
  var user;//User Holder
  FirebaseAuth auth;//auth Holder, used for logout
  MyHomePage homePage;
  bool loginState = false;

  Future<bool> _hasUser() async{
    homePage = new MyHomePage(title: 'BLEEZY', user: user, auth: auth,);
    user.user = await auth.currentUser();
    if(user.user != null)
      return true;
    else
      return false;
  }

  @override
  Widget build(BuildContext context) {
    _hasUser().then((b){
      print('login $b');
      if(b && !loginState) {
        loginState = false;
        Navigator.push(
          context,
          new MaterialPageRoute(builder: (context) => homePage),
        );
        Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => homePage));
      }
      loginState = true;
    });
    return new Scaffold(

      body: new Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: new Column(
          // Column is also layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug paint" (press "p" in the console where you ran
          // "flutter run", or select "Toggle Debug Paint" from the Flutter tool
          // window in IntelliJ) to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            new Container(
              padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 60.0),
              child: new Text(
                'BLEEZY', style: new TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 64.0,
                color: Theme.of(context).primaryColor,
              ),
              ),
            ),
            new Container(
              padding: const EdgeInsets.fromLTRB(60.0, 8.0, 60.0, 8.0),
              child: new RaisedButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    new MaterialPageRoute(builder: (context) => new LoginPage(user: user, auth: auth, homePage: homePage,)),
                  );
                },
                color: Theme.of(context).primaryColor,
                child: new Center(
                    child: new Text('Login',
                      style: new TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        color: Colors.white,
                      ),)
                ),
              ),
            ),
            new Container(
              padding: const EdgeInsets.fromLTRB(60.0, 8.0, 60.0, 8.0),
              child: new RaisedButton(
                onPressed: (){

                },
                color: Theme.of(context).primaryColor,
                child: new Center(
                    child: new Text('Register',
                      style: new TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20.0,
                        color: Colors.white,
                      ),)
                ),
              ),
            )
          ],
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}

class LoginPage extends StatefulWidget {
  LoginPage({Key key, this.user, this.auth, this.homePage}) : super(key: key);
  var user;//User Holder
  FirebaseAuth auth;//auth Holder
  MyHomePage homePage;

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  @override
  _LoginPageState createState() => new _LoginPageState(userHolder: user, auth: auth, homePage: homePage);
}

class _LoginPageState extends State<LoginPage> {
  _LoginPageState({Key key, this.userHolder, this.auth, this.homePage}) : super();
  var userHolder;//User Holder
  FirebaseAuth auth;//auth Holder
  MyHomePage homePage;

  String _email = '';
  String _password = '';
  final formKey = new GlobalKey<FormState>();//for save and submit text used

  //final FirebaseAuth auth = FirebaseAuth.instance;
  final GoogleSignIn googleSignIn = new GoogleSignIn();

  //googleSignIn
  Future<FirebaseUser> signInGoogle() async{
    //FirebaseAuth auth = FirebaseAuth.instance;
    GoogleSignInAccount googleAccount = await googleSignIn.signIn();
    GoogleSignInAuthentication googleAuth = await googleAccount.authentication;

    FirebaseUser loginUser = await auth.signInWithGoogle(
        idToken: googleAuth.idToken, accessToken: googleAuth.accessToken);
    print(loginUser.displayName);
    return loginUser;
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      body: new Center(
        child: new Container(
          margin: const EdgeInsets.fromLTRB(20.0, 36.0, 20.0, 36.0),
          decoration: new BoxDecoration(
              border: new Border.all(color: Theme.of(context).primaryColor)
          ),
          child: new Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              new Container(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 2.0),
                child: new Text(
                  'BLEEZY', style: new TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 32.0,
                  color: Theme.of(context).primaryColor,
                ),
                ),
              ),
              new Container(
                padding: const EdgeInsets.fromLTRB(0.0, 0.0, 0.0, 0.0),
                child: new Text(
                  'LOGIN', style: new TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 20.0,
                  color: Theme.of(context).primaryColor,
                ),
                ),
              ),
              new Form(
                key: formKey,
                child: new Column(
                  children: <Widget>[
                    new Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new TextFormField(
                        onSaved: (val) => setState((){_email = val;}),
                        decoration: new InputDecoration(labelText: "Email"),
                      ),
                    ),
                    new Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: new TextFormField(
                        onSaved: (val) => setState((){_password = val;}),
                        obscureText: true,
                        validator: (val) {
                          return val.length < 6
                              ? "Password must have atleast 6 chars or numbers"
                              : null;
                        },
                        decoration: new InputDecoration(labelText: "Password"),
                      ),
                    ),
                  ],
                ),
              ),
              new Container(
                padding: const EdgeInsets.fromLTRB(40.0, 8.0, 40.0, 8.0),
                child: new RaisedButton(
                  onPressed: (){
                    final form = formKey.currentState;
                    form.save();

                    //login firebase email auth
                  },
                  color: Theme.of(context).primaryColor,
                  child: new Center(
                      child: new Text('Login',
                        style: new TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          color: Colors.white,
                        ),)
                  ),
                ),
              ),
              new Container(
                padding: const EdgeInsets.fromLTRB(40.0, 8.0, 40.0, 8.0),
                child: new RaisedButton(
                  onPressed: (){
                    //login firebase facebook auth
                    signInGoogle().then((user){
                      userHolder.user = user;

                      //pop to first login then perform replacement
                      Navigator.pop(context);
                      Navigator.pushReplacement(context, new MaterialPageRoute(builder: (context) => homePage));
                    });
                  },
                  color: Theme.of(context).primaryColor,
                  child: new Center(
                      child: new Text('Login With Google',
                        style: new TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16.0,
                          color: Colors.white,
                        ),)
                  ),
                ),
             )
            ],
          ),
        ),
      ),
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}