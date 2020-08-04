import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:y_wait/models/user.dart';
import 'package:y_wait/screens/loading.dart';
import 'package:y_wait/services/database.dart';
import 'package:flutter/services.dart';

class BusinessSettings extends StatefulWidget {
  @override
  _BusinessSettingsState createState() => _BusinessSettingsState();
}

class _BusinessSettingsState extends State<BusinessSettings> {

  final _formKey = GlobalKey<FormState>();
  final List<String> categories = ["Mall", "Restaurant", "Theatre", "Clothes", "General Store", "Pharmacy"];
  String _businessName;
  String _category;
  int _maxCap;
  
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);

    return StreamBuilder<BusinessData>(
      stream: DatabaseService(uid: user.userId).businessData,
      builder: (context, snapshot) {
        if(snapshot.hasData) {
          BusinessData businessData = snapshot.data;
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
                      height: 500.0,
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
                            "Update your business settings",
                            style: GoogleFonts.robotoSlab(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          SizedBox(height: 30.0,),
                          TextFormField(
                            initialValue: _businessName ?? businessData.businessName,
                            validator: (val) {
                              return val.length > 0 ? null : "Please enter a business name";
                            },
                            cursorColor: Colors.black,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                                fillColor: Colors.white.withOpacity(0.0),
                                filled: true,
                                hintText: "Business Name",
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
                                _businessName = val;
                              });
                            },
                          ),
                          SizedBox(height: 10.0,),
                          DropdownButtonFormField(
                            value: _category ?? businessData.category,
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                                fillColor: Colors.white.withOpacity(0.0),
                                filled: true,
                                focusedBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black, width: 4.0),
                                ),
                                enabledBorder: UnderlineInputBorder(
                                  borderSide: BorderSide(color: Colors.black, width: 2.0),
                                )
                            ),
                            items: categories.map((cat) {
                              return DropdownMenuItem(
                                value: cat,
                                child: Text(
                                  '$cat',
                                  style: GoogleFonts.robotoSlab(
                                    fontSize: 20.0,
                                    fontWeight: FontWeight.w800,
                                  ),
                                ),
                              );
                            }).toList(),
                            onChanged: (val) => setState(() => _category = val ),
                          ),
                          SizedBox(height: 10.0,),
                          TextFormField(
                            keyboardType: TextInputType.number,
                            inputFormatters: <TextInputFormatter>[
                              WhitelistingTextInputFormatter.digitsOnly
                            ],
                            decoration: InputDecoration(
                                contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
                                fillColor: Colors.white.withOpacity(0.0),
                                filled: true,
                                hintText: "Max Capacity",
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
                            validator: (val) {
                              print(val);
                              return ((int.parse(val) > 0) && val != null) ? null : "Please enter a valid capacity";
                            },
                            cursorColor: Colors.black,
                            style: GoogleFonts.robotoSlab(
                              fontSize: 20.0,
                              fontWeight: FontWeight.w800,
                            ),
                            onChanged: (val) {
                              setState(() {
                                _maxCap = int.parse(val);
                              });
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: <Widget>[
                              Text(
                                "(Current value: ${businessData.maxCap})",
                                style: GoogleFonts.robotoSlab(
                                  fontSize: 15.0,
                                  fontWeight: FontWeight.w800,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 100.0,),
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
                                await DatabaseService(uid: user.userId).updateBusinessData(
                                  businessName: _businessName ?? snapshot.data.businessName,
                                  category: _category ?? snapshot.data.category,
                                  maxCap: _maxCap ?? snapshot.data.maxCap,
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
