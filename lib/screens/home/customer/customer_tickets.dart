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

    return Scaffold(
      body: Container(
        margin: EdgeInsets.all(10.0),
        height: MediaQuery.of(context).size.height,
        child: Column(
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
                                    data: user.userId,
                                    size: 200,
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
                            return Container(
                              margin: EdgeInsets.all(10),
                              decoration: BoxDecoration(
                                color: Colors.white,
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
                                            QrImage(
                                              data: user.userId,
                                              size: 140,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                  Positioned(
                                    left: MediaQuery.of(context).size.width * 0.3 + 30,
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
                                              fontSize: 25,
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
    );
  }
}
