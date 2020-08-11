import 'package:barcode_scan/barcode_scan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:y_wait/models/user.dart';

class BusinessHome extends StatefulWidget {
  @override
  _BusinessHomeState createState() => _BusinessHomeState();
}

class _BusinessHomeState extends State<BusinessHome> {
  String result = "Latest Scanned Ticket: None";
  String image = "assets/images/default_scan.png";

  Future<int> validateScan(String uid, String customer) async {
    final CollectionReference businessCollection = Firestore.instance.collection("business");
    final CollectionReference customerCollection = Firestore.instance.collection("customers");
    List<String> customerData = customer.split(" ");
    String bidnessName = customerData.sublist(1, customerData.length).join(' ');
    bool inStore = await customerCollection.document(customerData[0]).get().then((DocumentSnapshot ds) => ds.data["inStore"]);
    String bName = await businessCollection.document(uid).get().then((DocumentSnapshot ds) => ds.data["businessName"]);

    if(!inStore) {
      List<dynamic> person = await businessCollection.document(uid).get().then((DocumentSnapshot ds) => ds.data["people"]);
      int peopleInLine = await businessCollection.document(uid).get().then((DocumentSnapshot ds) => ds.data["peopleInLine"]);
      if(person.isNotEmpty) {
        if(customerData[0] == person[0].toString() && bidnessName == bName) {
          print("Granted entry!");
          await businessCollection.document(uid).updateData({
            "people": FieldValue.arrayRemove([customerData[0]]),
            "inStore": FieldValue.arrayUnion([customerData[0]]),
            "peopleInLine": peopleInLine - 1
          });
          await customerCollection.document(customerData[0]).updateData({"inStore": true});
          return 1;
        }
        else
          print("Not granted!");
        return 0;
      }
    }
    else if(inStore) {
      if(bidnessName == bName) {
        print("Checkout Successful!");
        await businessCollection.document(uid).updateData({
          "inStore": FieldValue.arrayRemove([customerData[0]]),
        });
        final CollectionReference specificCustomer = Firestore.instance.collection(customerData[0]);
        String bUid = await businessCollection.document(uid).get().then((DocumentSnapshot ds) => ds.data["uid"]);
        await specificCustomer.document(bUid).delete();
        await customerCollection.document(customerData[0]).updateData({"inStore": false});
        return 2;
      } else {
        print("Please show the right ticket...");
        return 0;
      }
    }
    print("yo ass @ the wrong store foo!");
    return 0;
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);

    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
            child: Column(
              children: <Widget>[
                Row(
//                crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: <Widget>[
                    Container(
                      height: 80.0,
                      width: MediaQuery.of(context).size.width,
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 20),
                          Text(
                              "Scan Customer Tickets",
                              style: GoogleFonts.robotoSlab(
                                color: Colors.white,
                                fontSize: 30.0,
                                fontWeight: FontWeight.w600,
                              )
                          ),
                        ],
                      ),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.only(
                          bottomLeft: Radius.circular(25.0),
                          bottomRight: Radius.circular(25.0),
                        ),
                        gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Color(0xff7F00FF),
                              Color(0xffE100FF),
                            ]
                        ),
                        boxShadow: [
                          BoxShadow(color: Colors.grey.withOpacity(0.8),
                              spreadRadius: 5.0,
                              blurRadius: 7.0,
                              offset: Offset(0, 3)),
                        ],
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 60,),
                Stack(
                  children: <Widget>[
                    Center(
                      child: Container(
                        //margin: EdgeInsets.only(top: 160.0, left: 15.0, right: 15.0),
                        height: 450.0,
                        width: 350.0,
                        decoration: BoxDecoration(
//                        boxShadow: [
//                          BoxShadow(color: Colors.grey.withOpacity(0.8),
//                              spreadRadius: 5.0,
//                              blurRadius: 7.0,
//                              offset: Offset(0, 3)),
//                        ],
                          borderRadius: BorderRadius.circular(10.0),
                          color: Colors.blueAccent.withOpacity(0.4),
                        ),
                      ),
                    ),
                    Center(
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 20.0,),
                          Text(result, textAlign: TextAlign.center, style: GoogleFonts.robotoSlab(fontSize: 20, fontWeight: FontWeight.w600),),
                          SizedBox(height: 5.0,),
                          Container(
                            height: 300.0,
                            width: 250.0,
                            child: Image(
                              image: AssetImage(image),
                            ),
                          ),
                          SizedBox(height: 5.0,),
                          RaisedButton(
                            onPressed: () async {
                              var scanning = await BarcodeScanner.scan();
                              int granted = await validateScan(user.userId, scanning.rawContent);
                              print(granted);
                              if(granted == 1) {
                                setState(() {
                                  result = "Success! You've been checked in!";
                                  image = "assets/images/success.png";
                                });
                              }

                              else if(granted == 2) {
                                setState(() {
                                  result = "Checkout Successful!";
                                  image = "assets/images/success.png";
                                });
                              }

                              else {
                                setState(() {
                                  result = "Invalid Ticket!";
                                  image = "assets/images/fail.png";
                                });
                              }
                            },
                            child: Text(
                                "Scan Ticket",
                                style: GoogleFonts.robotoSlab(
                                  color: Colors.black,
                                  fontSize: 20.0,
                                  fontWeight: FontWeight.w600,
                                )
                            ),
                            color: Colors.amber,
                          ),
                          SizedBox(height: 100,),
                        ],
                      ),
                    )
                  ],
                )
              ],
            )
        ),
      ),
    );
  }
}