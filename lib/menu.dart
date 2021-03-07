import 'package:flutter/material.dart';
import 'package:hunar/main.dart';

class NavDrawer extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text(
              'Menu',
              style: TextStyle(color: Colors.white, fontSize: 25),
            ),
            decoration: BoxDecoration(
              color: Colors.black,
            ),
          ),
          ListTile(
            leading: Icon(Icons.home),
            title: Text('Home'),
            onTap: () => {
              Navigator.pushReplacement(context,
                  new MaterialPageRoute(builder: (context) => HomePage()))
            },
          ),
          ListTile(
            leading: Icon(Icons.question_answer),
            title: Text('FAQs'),
            onTap: () => {
              Navigator.pushReplacement(
                  context, new MaterialPageRoute(builder: (context) => FAQs()))
            },
          ),
          ListTile(
            leading: Icon(Icons.people),
            title: Text('About Us'),
            onTap: () => {
              Navigator.pushReplacement(context,
                  new MaterialPageRoute(builder: (context) => AboutUs()))
            },
          ),
        ],
      ),
    );
  }
}

class FAQs extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: NavDrawer(),
        appBar: AppBar(
            title: Text("Frequently Asked Questions"),
            backgroundColor: Colors.black),
        body: Column(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Text("How to use this application?",
                        textAlign: TextAlign.left,
                        style: TextStyle(
                            fontSize: 20, fontWeight: FontWeight.bold)),
                    SizedBox(height: 20),
                    Text(
                        "Click on the Register button in the Home page,then from the Dropdown menu select a domain. Once selected, click on the checkboxes that apply. For any additional information you want to provide, write the same in the Textbox and click on Submit. We will reach out to you thereafter",
                        textAlign: TextAlign.justify,
                        style: TextStyle(
                          fontSize: 15,
                        ))
                  ],
                )),
          ],
        ));
  }
}

class AboutUs extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
        drawer: NavDrawer(),
        appBar: AppBar(title: Text("About Us"), backgroundColor: Colors.black),
        body: Column(
          children: <Widget>[
            Padding(
                padding: EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  children: <Widget>[
                    SizedBox(
                      height: 10,
                    ),
                    Text(
                        "We aim to provide Micro, Small , Medium Enterprises a platform to seek the help of independent consultants. Our algorithm analyses the problems MSMEs are facing and reaches out to most suitable consultants for finding a solution to the issue.",
                        style: TextStyle(
                          fontSize: 20.0,
                        ))
                  ],
                )),
          ],
        ));
  }
}
