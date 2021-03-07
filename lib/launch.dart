import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'main.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'globals.dart' as globals;

class LaunchPage extends StatefulWidget {
  final String title = "Launch Page";

  @override
  _LaunchPageState createState() => _LaunchPageState();
}

class _LaunchPageState extends State<LaunchPage> {
  FirebaseUser _firebaseUser;

  @override
  void initState() {
    super.initState();
    _getFirebaseUser();
  }

  Future<void> _getFirebaseUser() async {
    this._firebaseUser = await FirebaseAuth.instance.currentUser();
    SharedPreferences prefs = await SharedPreferences.getInstance();
    globals.docID = prefs.getString('UserDocId');
    globals.user = prefs.getString('UserIs');
    if (_firebaseUser != null) {
      Navigator.pushReplacement(context,
              new MaterialPageRoute(builder: (context) => new HomePage()))
          .then((value) => setState(() {}));
    } else {
      Navigator.pushReplacement(context,
          new MaterialPageRoute(builder: (context) => new LoginPage()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        //Here you can set what ever background color you need.
        backgroundColor: Colors.black,
        body: Center(
          child: Text(
            "Loading...",
            style: TextStyle(color: Colors.white, fontSize: 20),
          ),
        ));
  }
}
