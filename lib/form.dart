import 'package:flutter/material.dart';
import 'globals.dart' as globals;
import 'main.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

class UserForm extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = 'User Form';
    return MaterialApp(
      title: appTitle,
      routes: <String, WidgetBuilder>{
        '/homepage': (BuildContext context) => HomePage(),
      },
      home: Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
          backgroundColor: Colors.black,
        ),
        body: FormPage(),
        resizeToAvoidBottomPadding: false,
        resizeToAvoidBottomInset: false,
      ),
    );
  }
}

// Create a Form widget.
class FormPage extends StatefulWidget {
  @override
  FormPageState createState() {
    return FormPageState();
  }
}

bool validateEmail(String value) {
  Pattern pattern =
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$';
  RegExp regex = new RegExp(pattern);
  return (!regex.hasMatch(value)) ? false : true;
}

// Create a corresponding State class, which holds data related to the form.
class FormPageState extends State<FormPage> {
  // Create a global key that uniquely identifies the Form widget
  // and allows validation of the form.
  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final firestoreInstance = Firestore.instance;
    // Build a Form widget using the _formKey created above.
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.purple[900], width: 3),
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(20),
                    )),
                focusColor: Colors.purple[900],
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 3),
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(20),
                    )),
                icon: const Icon(Icons.person, color: Colors.black),
                hintText: 'Name',
              ),
              validator: (value) {
                if (value.isEmpty) {
                  return 'Please enter some text';
                }
                globals.userName = value;
                return null;
              },
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: TextFormField(
              decoration: InputDecoration(
                border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.purple[900], width: 3),
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(20),
                    )),
                focusColor: Colors.purple[900],
                focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.black, width: 3),
                    borderRadius: const BorderRadius.all(
                      const Radius.circular(20),
                    )),
                icon: const Icon(Icons.mail, color: Colors.black),
                hintText: 'Email ID',
              ),
              validator: (value) {
                if (validateEmail(value) == false) {
                  return 'Please enter a valid email ID';
                }
                globals.userEmail = value;
                return null;
              },
            ),
          ),
          SizedBox(height: 15),
          Padding(
            padding: EdgeInsets.only(left: 10, right: 10),
            child: Container(
                decoration: BoxDecoration(
                    borderRadius:
                        const BorderRadius.all(const Radius.circular(20)),
                    border: Border.all(color: Colors.black38)),
                child: Column(
                  children: <Widget>[
                    Text(
                      "Are you a Consultant or an MSME?",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
                    ),
                    ListTile(
                      title: const Text('MSME'),
                      leading: Radio(
                        activeColor: Colors.black,
                        value: globals.category.companies,
                        groupValue: globals.userIs,
                        onChanged: (globals.category value) {
                          setState(() {
                            globals.userIs = value;
                          });
                        },
                      ),
                    ),
                    ListTile(
                      title: const Text('Consultant'),
                      leading: Radio(
                        activeColor: Colors.black,
                        value: globals.category.consultants,
                        groupValue: globals.userIs,
                        onChanged: (globals.category value) {
                          setState(() {
                            globals.userIs = value;
                          });
                        },
                      ),
                    ),
                  ],
                )),
          ),
          SizedBox(
            height: 10,
          ),
          Center(
              child: new OutlineButton(
            child: const Text('Submit'),
            splashColor: Colors.purple[900],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            borderSide: BorderSide(color: Colors.black, width: 3),
            onPressed: () async {
              // It returns true if the form is valid, otherwise returns false
              final prefs = await SharedPreferences.getInstance();
              if (_formKey.currentState.validate()) {
                prefs.setString(
                    "UserIs", globals.userIs.toString().split('.').last);
                firestoreInstance
                    .collection(globals.userIs.toString().split('.').last)
                    .add({
                  "name": globals.userName,
                  "email": globals.userEmail,
                  "phone": prefs.getString('UserPhone'),
                }).then((value) {
                  globals.user = prefs.getString('UserIs');
                  globals.docID = value.documentID;
                  prefs.setString('UserDocId', value.documentID);
                  print(globals.docID);
                });
                Navigator.pushReplacement(
                        context,
                        new MaterialPageRoute(
                            builder: (context) => new HomePage()))
                    .then((value) => setState(() {}));
              }
            },
          )),
        ],
      ),
    );
  }
}
