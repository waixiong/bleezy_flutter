import 'package:flutter/material.dart';
import 'package:bleezy/main.dart';
import 'package:bleezy/screen/MenuPage.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'dart:async';

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title, this.user, this.auth}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;
  var user;//User Holder
  var auth;//auth Holder, used for logout
  var orderList = <DataSnapshot>[];

  @override
  _MyHomePageState createState() => new _MyHomePageState(user: user, auth: auth, orderList: orderList,);
}

class _MyHomePageState extends State<MyHomePage> {
  _MyHomePageState({Key key, this.user, this.auth, this.orderList});
  var user;//User Holder
  FirebaseAuth auth;//auth Holder, used for logout
  DatabaseReference _orderRef;
  var orderList;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _orderRef = FirebaseDatabase.instance.reference().child('OrderList');
    //onChildAdded, Changed, Remove
    _orderRef.onChildAdded.listen((Event event) {
      print("child found ${event.snapshot.value}");
      orderList.add(event.snapshot);
      if(this.mounted) {
        setState(() {});
      }
    }, onError: (Object o) {
      final DatabaseError error = o;
      print('Error: ${error.code} ${error.message}');
    });
    _orderRef.onChildChanged.listen((Event event) {
      orderList.forEach((DataSnapshot item){
        if(item.key == event.snapshot.key){
          item = event.snapshot;
          if(this.mounted) {
            setState(() {});
          }
        }
      });
    }, onError: (Object o) {
      final DatabaseError error = o;
      print('Error: ${error.code} ${error.message}');
    });
    _orderRef.onChildRemoved.listen((Event event) {
      orderList.forEach((DataSnapshot item) {
        if(item.key == event.snapshot.key){
          orderList.remove(item);
          if(this.mounted) {
            setState(() {});
          }
        }
      });
    }, onError: (Object o) {
      final DatabaseError error = o;
      print('Error: ${error.code} ${error.message}');
    });
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.

    var list = <Widget>[];
    list.add(new Container(
      padding: const EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 0.0),
      child: new Text(
        'Available order will be shown below.',
        style: new TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 20.0,
          color: Colors.black,
        ),
      ),
    ));
    orderList.forEach((DataSnapshot item) {
      list.add(new ListTile(
        onTap: (){
          Navigator.push(
            context,
            new MaterialPageRoute(builder: (context) => new MenuPage(title: item.value["restaurant"]+"'s Menu", user: user, auth: auth, order: item,)),
          );
        },
        title: new Text("Restaurant: "+item.value["restaurant"]),
        subtitle: new Text("Destination: " +item.value["destination"] + "\n"
            "Rider: " + item.value["rider"]),
      ));
    });

    print('Hai '+user.user.displayName);
    return new Scaffold(
      appBar: new AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: new Text(widget.title, style: new TextStyle(),),
        centerTitle: true,
        //automaticallyImplyLeading : false,
      ),
      body: new ListView.builder(
        scrollDirection: Axis.vertical,
        shrinkWrap: true,
        padding: const EdgeInsets.all(20.0),
        itemCount: list.length,
        itemBuilder: (BuildContext context, int index) {
          ///Flexible let's your widget flex in  the given space, dealing with the overflow you have
          //  new Flexible(child: new FlatButton(onPressed: ()=>print("You pressed Image No.$index"), child: _partyImage)),
          return list[index];
          //Exact width and height, consider adding Flexible as a parent to the Container

        })
      // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}