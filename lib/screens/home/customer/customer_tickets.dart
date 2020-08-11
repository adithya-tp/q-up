import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:y_wait/models/user.dart';
import 'package:y_wait/services/database.dart';

class CustomerTicket extends StatefulWidget {
  @override
  _CustomerTicketState createState() => _CustomerTicketState();
}

class _CustomerTicketState extends State<CustomerTicket> {

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);

    return Container(
      height: MediaQuery.of(context).size.height,
      child: Scaffold(
        body: Container(
          margin: EdgeInsets.all(10.0),
          child: ListView(
            children: <Widget>[
              Container(
                child: StreamBuilder(
                  //future: getNearby(),
                  stream: DatabaseService(uid: user.userId).customerTickets,
                  initialData: [],
                  builder: (_, snapshot) {
                    if(snapshot.connectionState == ConnectionState.waiting) {
                      return Center(
                        child: Text("Loading..."),
                      );
                    } else {
                      String someOtherVarName;
                      return GestureDetector(
                        onTap: () {
                          showModalBottomSheet(context: context,
                            builder: (context) {
                              return Container(
                                color: Color(0XFF737373),
                                height: 500,
                                child: Container(
                                  child: Container(
                                    child: QrImage(
                                      data: "${user.userId} $someOtherVarName",
                                      size: 150,
                                    ),
                                  ),
                                  decoration: BoxDecoration(
                                    color: Theme.of(context).canvasColor,
                                    borderRadius: BorderRadius.only(
                                        topLeft: const Radius.circular(15),
                                        topRight: const Radius.circular(15)
                                    ),
                                  ),
                                ),
                              );
                            },
                          );
                        },
                        child: ListView.builder(
                            physics: NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: snapshot.data.length,
                            itemBuilder: (_, index) {
                              final CollectionReference businessCollection = Firestore.instance.collection("business");
                              print(snapshot.data);
                              String bName;
                              businessCollection.document(snapshot.data[index].uid).get().then((DocumentSnapshot ds) { someOtherVarName = ds.data["businessName"]; bName = ds.data["businessName"]; });
                              return Container(
                                margin: EdgeInsets.all(10),
                                decoration: BoxDecoration(
                                  color: Colors.grey[100],
                                  boxShadow: [
                                    BoxShadow(color: Colors.grey.withOpacity(0.8),
                                        spreadRadius: 5.0,
                                        blurRadius: 7.0,
                                        offset: Offset(0, 3)),
                                  ],
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                                height: 175.0,
                                width: MediaQuery.of(context).size.width,
                                child: Stack(
                                  children: <Widget>[
                                    Container(
                                      margin: EdgeInsets.all(10),
                                      height: 200.0,
//                                  width: MediaQuery.of(context).size.width * 0.3,
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.start,
                                        crossAxisAlignment: CrossAxisAlignment.center,
                                        children: <Widget>[
                                          Column(
                                            children: <Widget>[
                                              Image(
                                                image: AssetImage("assets/images/ticket.png"),
                                                width: 150.0,
                                                height: 150.0,
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    Positioned(
                                      left: MediaQuery.of(context).size.width * 0.3 + 50,
                                      top: 10,
                                      child: Container(
                                        child: Column(
                                          children: <Widget>[
                                            Text(
                                              snapshot.data[index].businessName,
                                              style: GoogleFonts.robotoSlab(
                                                color: Colors.black,
                                                fontSize: 20,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                            SizedBox(height: 20.0,),
                                            Text(
                                              "Your spot in q: ${snapshot.data[index].positionInLine}",
                                              style: GoogleFonts.robotoSlab(
                                                color: Colors.black,
                                                fontSize: 15,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    )
                                  ],
                                ),
                              );
                            }
                        ),
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        )
      ),
    );
  }
}
