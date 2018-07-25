import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class MenuPage extends StatefulWidget {
  MenuPage({Key key, this.title, this.user, this.auth, this.order}) : super(key: key);

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
  var order;
  var firestoreRef;

  @override
  _MenuPageState createState() => new _MenuPageState(user: user, auth: auth, order: order, firestoreRef: firestoreRef,);
}

class _MenuPageState extends State<MenuPage> {
  _MenuPageState({Key key, this.user, this.auth, this.order, this.firestoreRef});
  var user;//User Holder
  var auth;//auth Holder, used for logout
  var order;
  var firestoreRef;
  List<dynamic> MenuList = <dynamic>[];


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print(order.value["restaurant"]);
    getData();
  }

  void getData() async {
    firestoreRef = await Firestore.instance.collection("Menu").document(order.value["restaurant"]).get();
    if(firestoreRef.exists){
      MenuList = await firestoreRef.data["Food"];
      setState(() {});
    }
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
    MenuList.forEach((dynamic item) {
      list.add(new ListTile(
        onTap: (){

        },
        title: new Text(item["name"]),
        subtitle: new Text("RM "+item["price"].toString()),
      ));
    });

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