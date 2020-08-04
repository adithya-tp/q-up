import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:y_wait/models/user.dart';
import 'package:y_wait/screens/loading.dart';
import 'package:y_wait/services/database.dart';

class CustomerSettings extends StatefulWidget {
  @override
  _CustomerSettingsState createState() => _CustomerSettingsState();
}

class _CustomerSettingsState extends State<CustomerSettings> {
  final _formKey = GlobalKey<FormState>();
  String _customerName;

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    return StreamBuilder<CustomerData>(
      stream: DatabaseService(uid: user.userId).customerData,
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          CustomerData customerData = snapshot.data;
          return SingleChildScrollView(
            child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        Color(0xffC6FFDD),
                        Color(0xffFBD786),
                        Color(0xfff7797d)
                      ]
                  )
              ),
              child: Form(
                key: _formKey,
                child: Stack(
                  children: <Widget>[
                    Container(
                      margin: EdgeInsets.only(top: 20.0, left: 15.0, right: 15.0),
                      height: 300.0,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10.0),
                        color: Colors.white.withOpacity(0.5),
                      ),
                    ),
                    Container(
                      margin: EdgeInsets.only(top: 60.0, left: 15.0, right: 15.0),
                      padding: EdgeInsets.symmetric(horizontal: 24.0),
                      child: Column(
                        children: <Widget>[
                          Text(
                            "Update your settings",
                            style: GoogleFonts.robotoSlab(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 30.0,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "Full Name",
                                style: GoogleFonts.robotoSlab(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w800,
                                  color: Colors.deepOrangeAccent
                                ),
                              ),
                              SizedBox(height: 30.0,),
                            ],
                          ),
                          TextFormField(
                            initialValue: _customerName ?? customerData.customerName,
                            validator: (val) {
                              return val.length > 0 ? null : "Please enter your name";
                            },
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                                fillColor: Colors.white.withOpacity(0.0),
                                filled: true,
                                hintText: "Name",
                                hintStyle: TextStyle(
                                    fontSize: 18.0,
                                    color: Colors.black.withOpacity(0.2),
                                    fontWeight: FontWeight.w400
                                ),
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black, width: 4.0),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black, width: 2.0),
                                )
                            ),
                            style: GoogleFonts.robotoSlab(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w800,
                            ),
                            onChanged: (val) {
                              setState(() {
                                _customerName = val;
                              });
                            },
                          ),
                          SizedBox(height: 50.0,),
                          RaisedButton(
                            color: Colors.amber,
                            child: Text(
                              "Update",
                              style: GoogleFonts.robotoSlab(
                                fontSize: 20.0,
                                fontWeight: FontWeight.w800,
                              ),
                            ),
                            onPressed: () async {
                              if(_formKey.currentState.validate()) {
                                await DatabaseService(uid: user.userId).updateCustomerData(
                                  customerName: _customerName ?? snapshot.data.customerName,
                                );
                              }
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
            ),
          );
        } else {
          return Loading();
        }
      },
    );
  }
}
