import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'globals.dart' as globals;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'main.dart';

class DropDown extends StatefulWidget {
  DropDown() : super();

  final String title = "DropDown Demo";

  @override
  DropDownState createState() => DropDownState();
}

class Company {
  int id;
  String name;

  Company(this.id, this.name);

  static List<Company> getCompanies() {
    return <Company>[
      Company(1, 'Finance'),
      Company(2, 'Legal'),
      Company(3, 'Technical'),
      Company(4, 'Marketing'),
      Company(5, 'HR'),
      Company(6, 'Other'),
    ];
  }
}

class DropDownState extends State<DropDown> {
  //
  List<Company> _companies = Company.getCompanies();
  List<DropdownMenuItem<Company>> _dropdownMenuItems;
  Company _selectedCompany;

  @override
  void initState() {
    _dropdownMenuItems = buildDropdownMenuItems(_companies);
    _selectedCompany = _dropdownMenuItems[0].value;

    super.initState();
  }

  final firestoreInstance = Firestore.instance;
  Map current;

  Map<String, bool> finance = {
    'Account': false,
    'Bank Loan': false,
    'Subsidy': false,
    'Taxation': false,
  };

  Map<String, bool> legal = {
    'Payment Realisation': false,
    'Rent related cases': false,
    'PF': false,
    'ESI': false,
    'Customs': false,
    'IT': false,
    'Municipal Taxes': false,
    'Insurance': false,
    'Pollution': false,
  };
  Map<String, bool> hr = {
    'Turnkey Recruitments': false,
    'Interviews': false,
    'PF related issues': false,
    'ESI related issues': false,
    'HR training': false,
    'HR Policy Documentation': false
  };
  Map<String, bool> technical = {
    'Buying/Selling Industry equipments': false,
    'Industry Specific Project reports': false,
  };
  Map<String, bool> marketing = {
    'Exploring Export Market': false,
    'Digital Marketing': false,
    'Franchise': false,
    'Distributorship/ Dealership': false,
    'Advertisement/ Market Communication': false,
  };

  var tmpArray = [];

  getCheckboxItems() {
    try {
      current.forEach((key, value) {
        if (value == true) {
          tmpArray.add(key);
        }
      });

      // Printing all selected items on Terminal screen.
      print(tmpArray);
      // Here you will get all your selected Checkbox items.

      // Clear array after use.
    } catch (e) {
      return null;
    }
  }

  String problemdetails;

  List<DropdownMenuItem<Company>> buildDropdownMenuItems(List companies) {
    List<DropdownMenuItem<Company>> items = List();
    for (Company company in companies) {
      items.add(
        DropdownMenuItem(
          value: company,
          child: Text(company.name),
        ),
      );
    }
    return items;
  }

  @override
  Widget build(BuildContext context) {
    return new MaterialApp(
      routes: {
        '\homepage': (context) => HomePage(),
      },
      debugShowCheckedModeBanner: false,
      home: new Scaffold(
        appBar: AppBar(
          title: Text("Select a Domain from the drop down",
              style: TextStyle(fontSize: 20)),
          backgroundColor: Colors.black,
        ),
        resizeToAvoidBottomInset: false,
        body: new Container(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 10,
              ),

              SizedBox(
                height: 20.0,
              ),
              DropdownButton(
                  value: _selectedCompany,
                  items: _dropdownMenuItems,
                  onChanged: (Company selectedCompany) {
                    setState(() {
                      _selectedCompany = selectedCompany;
                    });
                  }),
              SizedBox(
                height: 5.0,
              ),
              Visibility(
                child: (Expanded(
                  child: ListView(
                    children: finance.keys.map((String key) {
                      return new CheckboxListTile(
                        title: new Text(key),
                        value: finance[key],
                        activeColor: Colors.black,
                        checkColor: Colors.white,
                        onChanged: (bool value) {
                          setState(() {
                            finance[key] = value;
                            current = finance;
                          });
                        },
                      );
                    }).toList(),
                  ),
                )),
                visible: _selectedCompany.name == 'Finance',
              ),
              Visibility(
                child: (Expanded(
                  child: ListView(
                    children: legal.keys.map((String key) {
                      return new CheckboxListTile(
                        title: new Text(key),
                        value: legal[key],
                        activeColor: Colors.black,
                        checkColor: Colors.white,
                        onChanged: (bool value) {
                          setState(() {
                            legal[key] = value;
                            current = legal;
                          });
                        },
                      );
                    }).toList(),
                  ),
                )),
                visible: _selectedCompany.name == 'Legal',
              ), //Legal Checkboxes
              Visibility(
                child: (Expanded(
                  child: ListView(
                    children: marketing.keys.map((String key) {
                      return new CheckboxListTile(
                        title: new Text(key),
                        value: marketing[key],
                        activeColor: Colors.black,
                        checkColor: Colors.white,
                        onChanged: (bool value) {
                          setState(() {
                            marketing[key] = value;
                            current = marketing;
                          });
                        },
                      );
                    }).toList(),
                  ),
                )),
                visible: _selectedCompany.name == 'Marketing',
              ),
              Visibility(
                child: (Expanded(
                  child: ListView(
                    children: technical.keys.map((String key) {
                      return new CheckboxListTile(
                        title: new Text(key),
                        value: technical[key],
                        activeColor: Colors.black,
                        checkColor: Colors.white,
                        onChanged: (bool value) {
                          setState(() {
                            technical[key] = value;
                            current = technical;
                          });
                        },
                      );
                    }).toList(),
                  ),
                )),
                visible: _selectedCompany.name == 'Technical',
              ),
              Visibility(
                child: (Expanded(
                  child: ListView(
                    children: hr.keys.map((String key) {
                      return new CheckboxListTile(
                        title: new Text(key),
                        value: hr[key],
                        activeColor: Colors.black,
                        checkColor: Colors.white,
                        onChanged: (bool value) {
                          setState(() {
                            hr[key] = value;
                            current = hr;
                            print(current);
                          });
                        },
                      );
                    }).toList(),
                  ),
                )),
                visible: _selectedCompany.name == 'HR',
              ),
              TextFormField(
                decoration: InputDecoration(
                    border: InputBorder.none,
                    hintText: 'Tell us more about the it'),
                onChanged: (value) {
                  problemdetails = value;
                },
              ),
              OutlineButton(
                  child: Text("Submit"),
                  splashColor: Colors.purple[900],
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(20)),
                  borderSide: BorderSide(color: Colors.black, width: 3),
                  onPressed: () async {
                    getCheckboxItems();
                    print(tmpArray);
                    SharedPreferences prefs =
                        await SharedPreferences.getInstance();
                    try {
                      globals.docID = prefs.getString('UserDocId');
                      globals.user = prefs.getString('UserIs');
                      firestoreInstance
                          .collection(prefs.getString('UserIs') == 'consultants'
                              ? "consultants"
                              : "companies")
                          .document(prefs.getString('UserDocId'))
                          .collection(prefs.getString('UserIs') == 'consultants'
                              ? "expertise"
                              : "problems")
                          .add({
                        "Problem": tmpArray,
                        "Details": problemdetails,
                        "Date": DateTime.now().toString(),
                      });
                      tmpArray.clear();
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      ).then((value) => setState(() {}));
                    } catch (e) {
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => HomePage()),
                      ).then((value) => setState(() {}));
                    }
                  })
            ],
          ),
        ),
      ),
    );
  }
}
