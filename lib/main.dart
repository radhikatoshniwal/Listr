import 'package:cloud_firestore/cloud_firestore.dart';

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'form.dart';
import 'globals.dart' as globals;
import 'menu.dart';
import 'problemreg.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'launch.dart';

void main() async {
  runApp(Hunar());
}

class Hunar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Hunar App',
      routes: <String, WidgetBuilder>{
        '/homepage': (BuildContext context) => HomePage(),
        '/loginpage': (BuildContext context) => LoginPage(),
        '/formpage': (BuildContext context) => UserForm(),
        '/problemreg': (BuildContext context) => DropDown(),
      },
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: LaunchPage(),
    );
  }
}

class LoginPage extends StatefulWidget {
  final String title = "Login Page";

  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  TextEditingController _phoneNumberController = TextEditingController();
  TextEditingController _otpController = TextEditingController();

  FirebaseUser _firebaseUser;
  String _status;

  AuthCredential _phoneAuthCredential;
  String _verificationId;
  int _code;

  @override
  void initState() {
    super.initState();
    _getFirebaseUser();
  }

  Future<void> _getFirebaseUser() async {
    this._firebaseUser = await FirebaseAuth.instance.currentUser();
    if (_firebaseUser != null) {
      Navigator.of(context).pushReplacementNamed('/homepage');
    }
  }

  /// phoneAuthentication works this way:
  ///     AuthCredential is the only thing that is used to authenticate the user
  ///     OTP is only used to get AuthCrendential after which we need to authenticate with that AuthCredential
  ///
  /// 1. User gives the phoneNumber
  /// 2. Firebase sends OTP if no errors occur
  /// 3. If the phoneNumber is not in the device running the app
  ///       We have to first ask the OTP and get `AuthCredential`(`_phoneAuthCredential`)
  ///       Next we can use that `AuthCredential` to signIn
  ///    Else if user provided SIM phoneNumber is in the device running the app,
  ///       We can signIn without the OTP.
  ///       because the `verificationCompleted` callback gives the `AuthCredential`(`_phoneAuthCredential`) needed to signIn
  Future<void> _login() async {
    /// This method is used to login the user
    /// `AuthCredential`(`_phoneAuthCredential`) is needed for the signIn method
    /// After the signIn method from `AuthResult` we can get `FirebaserUser`(`_firebaseUser`)
    try {
      await FirebaseAuth.instance
          .signInWithCredential(this._phoneAuthCredential)
          .then((AuthResult authRes) {
        _firebaseUser = authRes.user;
        print(_firebaseUser.toString());
      });

      globals.userPhone =
          "+91 " + _phoneNumberController.text.toString().trim();

      Navigator.of(context).pop();
      Navigator.of(context).pushReplacementNamed('/formpage');
    } catch (e) {
      setState(() {
        _status += e.toString() + '\n';
      });
      print(e.toString());
    }
  }

  Future<void> _submitPhoneNumber() async {
    /// NOTE: Either append your phone number country code or add in the code itself
    /// Since I'm in India we use "+91 " as prefix `phoneNumber`
    String phoneNumber = "+91 " + _phoneNumberController.text.toString().trim();
    print(phoneNumber);
    final prefs = await SharedPreferences.getInstance();
    prefs.setString('UserPhone', phoneNumber);

    /// The below functions are the callbacks, separated so as to make code more redable
    void verificationCompleted(AuthCredential phoneAuthCredential) {
      print('verificationCompleted');
      setState(() {
        _status += 'verificationCompleted\n';
      });
      this._phoneAuthCredential = phoneAuthCredential;
      print(phoneAuthCredential);
    }

    void verificationFailed(AuthException error) {
      print('verificationFailed');
      print(error.message);
      setState(() {
        _status += '$error\n';
      });
      print(error);
    }

    void codeSent(String verificationId, [int code]) {
      print('codeSent');
      smsOTPDialog(context);
      this._verificationId = verificationId;
      print(verificationId);
      this._code = code;
      print(code.toString());
      setState(() {
        _status += 'Code Sent\n';
      });
    }

    void codeAutoRetrievalTimeout(String verificationId) {
      print('codeAutoRetrievalTimeout');
      setState(() {
        _status += 'codeAutoRetrievalTimeout\n';
      });
      print(verificationId);
    }

    await FirebaseAuth.instance.verifyPhoneNumber(
      /// Make sure to prefix with your country code
      phoneNumber: phoneNumber,

      /// `seconds` didn't work. The underlying implementation code only reads in `millisenconds`
      timeout: Duration(milliseconds: 12000),

      /// If the SIM (with phoneNumber) is in the current device this function is called.
      /// This function gives `AuthCredential`. Moreover `login` function can be called from this callback
      verificationCompleted: verificationCompleted,

      /// Called when the verification is failed
      verificationFailed: verificationFailed,

      /// This is called after the OTP is sent. Gives a `verificationId` and `code`
      codeSent: codeSent,

      /// After automatic code retrival `tmeout` this function is called
      codeAutoRetrievalTimeout: codeAutoRetrievalTimeout,
    ); // All the callbacks are above
  }

  void _submitOTP() {
    /// get the `smsCode` from the user
    String smsCode = _otpController.text.toString().trim();

    /// when used different phoneNumber other than the current (running) device
    /// we need to use OTP to get `phoneAuthCredential` which is inturn used to signIn/login
    this._phoneAuthCredential = PhoneAuthProvider.getCredential(
        verificationId: this._verificationId, smsCode: smsCode);

    _login();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
        backgroundColor: Colors.black,
      ),
      body: ListView(
        padding: EdgeInsets.all(16),
        // mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          SizedBox(height: 24),
          Row(
            children: <Widget>[
              Text("+91 "),
              Expanded(
                flex: 2,
                child: TextField(
                  keyboardType: TextInputType.numberWithOptions(
                      decimal: false, signed: false),
                  controller: _phoneNumberController,
                  decoration: InputDecoration(
                    hintText: 'Phone Number',
                    border: OutlineInputBorder(
                        borderSide:
                            BorderSide(color: Colors.purple[900], width: 3)),
                    focusColor: Colors.purple[900],
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.black, width: 3)),
                  ),
                  cursorColor: Colors.black,
                ),
              ),
              SizedBox(
                width: 10,
              ),
              Expanded(
                flex: 1,
                child: OutlineButton(
                  hoverColor: Colors.blueAccent[400],
                  onPressed: () {
                    _submitPhoneNumber();
                  },
                  splashColor: Colors.purple[900],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  borderSide: BorderSide(color: Colors.black, width: 3),
                  child: Text(
                    'Get OTP',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  color: Theme.of(context).accentColor,
                ),
              ),
            ],
          ),
          SizedBox(height: 10),
        ],
      ),
    );
  }

  Future<bool> smsOTPDialog(BuildContext context) {
    return showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return new AlertDialog(
            title: Text('Enter OTP'),
            content: Container(
              height: 85,
              child: Column(children: [
                TextField(
                  controller: _otpController,
                  keyboardType: TextInputType.numberWithOptions(
                      decimal: false, signed: false),
                ),
              ]),
            ),
            contentPadding: EdgeInsets.all(10),
            actions: <Widget>[
              OutlineButton(
                hoverColor: Colors.blueAccent[400],
                onPressed: () {
                  _submitOTP();
                },
                splashColor: Colors.purple[900],
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20)),
                borderSide: BorderSide(color: Colors.black, width: 3),
                child: Text(
                  'Verify',
                  style: TextStyle(
                      fontWeight: FontWeight.bold, color: Colors.black),
                ),
                color: Theme.of(context).accentColor,
              ),
            ],
          );
        });
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

String userDocId;
String userIs;

class _HomePageState extends State<HomePage> {
  void initstate() {
    getprefs();
  }

  Future<Null> getprefs() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    globals.docID = userDocId = prefs.getString('UserDocId');
    globals.user = userIs = prefs.getString('UserIs');

    print(userIs);
    print(userDocId);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      drawer: NavDrawer(),
      appBar: AppBar(
        title:
            Text('हुनर', style: TextStyle(color: Colors.white, fontSize: 40)),
        backgroundColor: Colors.black,
      ),
      resizeToAvoidBottomInset: false,
      resizeToAvoidBottomPadding: false,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Expanded(
              child: StreamBuilder<QuerySnapshot>(
                  stream: Firestore.instance
                      .collection(globals.user == 'consultants'
                          ? 'consultants'
                          : 'companies')
                      .document(globals.docID)
                      .collection(globals.user == 'consultants'
                          ? 'expertise'
                          : 'problems')
                      .snapshots(),
                  builder: (BuildContext context,
                      AsyncSnapshot<QuerySnapshot> snapshot) {
                    if (snapshot.hasError)
                      return new Text('Error: ${snapshot.error}');
                    switch (snapshot.connectionState) {
                      case ConnectionState.waiting:
                        return new Text('Loading...');
                      default:
                        {
                          return new ListView(
                            children: snapshot.data.documents
                                .map((DocumentSnapshot document) {
                              return new Dismissible(
                                  key: Key(document.documentID),
                                  child: ListTile(
                                    title: Text(
                                        document['Problem']
                                            .toString()
                                            .replaceAll('[]', 'Others')
                                            .replaceAll(']', '')
                                            .replaceAll('[', ''),
                                        style: TextStyle(fontSize: 15)),
                                    subtitle: Text("Added on:" +
                                        document['Date'].split(' ').first),
                                  ),
                                  background: Container(
                                    color: Colors.red,
                                    child: Padding(
                                      padding: EdgeInsets.fromLTRB(
                                          300.0, 0.0, 0.0, 0.0),
                                      child: Icon(
                                        Icons.delete,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  direction: DismissDirection.endToStart,
                                  onDismissed: (direction) {
                                    Firestore.instance
                                        .collection(
                                            globals.user == 'consultants'
                                                ? 'consultants'
                                                : 'companies')
                                        .document(globals.docID)
                                        .collection(
                                            globals.user == 'consultants'
                                                ? 'expertise'
                                                : 'problems')
                                        .document(document.documentID)
                                        .delete();
                                  });
                            }).toList(),
                          );
                        }
                    }
                  })),
          OutlineButton(
            onPressed: () => {
              Navigator.pushReplacement(context,
                  new MaterialPageRoute(builder: (context) => new DropDown())),
            },
            child: Text("Register"),
            splashColor: Colors.purple[900],
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
            borderSide: BorderSide(color: Colors.black, width: 3),
          ),
        ],
      ),
    );
  }
}
