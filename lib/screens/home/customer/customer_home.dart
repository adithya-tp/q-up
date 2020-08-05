import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:y_wait/screens/home/customer/carousel.dart';
import 'package:y_wait/services/generateQR.dart';

class CustomerHome extends StatefulWidget {
  @override
  _CustomerHomeState createState() => _CustomerHomeState();
}

class _CustomerHomeState extends State<CustomerHome> {
  String username = "";
  Future getNearby() async {
    var fireStore = Firestore.instance;
    QuerySnapshot qn = await fireStore.collection("business").getDocuments();
    return qn.documents;
  }

  void _showQR() {
    showModalBottomSheet(context: context,
        builder: (context) {
          return Container(
            color: Color(0XFF737373),
            height: 500,
            child: Container(
              child: GenerateQR(),
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
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: ListView(
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: <Widget>[
                    Text(
                    "Popular",
                    style: GoogleFonts.robotoSlab(
                      color: Colors.black,
                      fontSize: 45.0,
                      fontWeight: FontWeight.w600,),
                    ),
                  ],
                ),
              ),
            Carousel(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: <Widget>[
                  Text(
                    "Nearby",
                    style: GoogleFonts.robotoSlab(
                      color: Colors.black,
                      fontSize: 45.0,
                      fontWeight: FontWeight.w600,),
                    ),
                  ],
                ),
              ),
            SizedBox(height: 25.0,),
            Container(
              child: FutureBuilder(
                future: getNearby(),
                builder: (_, snapshot) {
                if(snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Text("Loading..."),
                  );
                } else {
                  return ListView.builder(
                    physics: NeverScrollableScrollPhysics(),
                    shrinkWrap: true,
                    itemCount: snapshot.data.length,
                    itemBuilder: (_, index) {
                      String imageQuery = "";
                      if(snapshot.data[index].data["category"] == "clothes") {
                        imageQuery = "https://source.unsplash.com/featured/?${snapshot.data[index].data["category"]}, shop";
                      } else {
                        imageQuery = "https://source.unsplash.com/featured/?${snapshot.data[index].data["category"]}, store";
                      }
                      return Column(
                        children: <Widget>[
                          SizedBox(height: 18.0,),
                          GestureDetector(
                            onTap: () {
                              // TODO: Show Bottom Modal Page for selection from "Popular" List along with generate qr code option
                              showModalBottomSheet(context: context,
                                builder: (context) {
                                  return Container(
                                    color: Color(0XFF737373),
                                    height: 190,
                                    child: Container(
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            padding: EdgeInsets.fromLTRB(18.0, 20.0, 0.0, 10.0),
                                            child: Text(
                                              "${ snapshot.data[index].data["businessName"] }",
                                              style: GoogleFonts.robotoSlab(
                                                color: Colors.black,
                                                fontSize: 25.0,
                                                fontWeight: FontWeight.w500,
                                              ),
                                            ),
                                          ),
                                          Row(
                                            children: <Widget>[
                                              Container(
                                                padding: EdgeInsets.fromLTRB(18.0, 7.0, 0.0, 10.0),
                                                child: Text(
                                                  "People currently in queue: 0",
                                                  style: GoogleFonts.robotoSlab(
                                                    color: Colors.black,
                                                    fontSize: 20,
                                                    fontWeight: FontWeight.w500,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          Column(
                                            children: <Widget>[
                                              ListTile(
                                                leading: Icon(Icons.calendar_today),
                                                title: Text("Queue up"),
                                                onTap: () {
                                                  Navigator.pop(context);
                                                  _showQR();
                                                },
                                              ),
                                            ],
                                          ),
                                        ],
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
                            child: Stack(
                              children: <Widget>[
                                Container(
                                  margin: EdgeInsets.symmetric(horizontal: 24.0),
                                  padding: EdgeInsets.symmetric(horizontal: 12.0),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(15.0),
                                    image: DecorationImage(
                                      image: NetworkImage(imageQuery),
                                      colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.6), BlendMode.dstATop),
                                      fit: BoxFit.cover
                                    )
                                  ),
                                  width: MediaQuery.of(context).size.width,
                                  height: 150.0,
                                ),
                                Container(
                                  width: MediaQuery.of(context).size.width,
                                  height: 150.0,
                                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                                  decoration: BoxDecoration(
                                      borderRadius: BorderRadius.circular(15.0),
                                  ),
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 15.0),
                                        child: Text(
                                          "${snapshot.data[index].data["businessName"].toString()}   (${snapshot.data[index].data["category"].toString()})",
                                          style: GoogleFonts.robotoSlab(
                                            fontSize: 30.0,
                                            color: Colors.black,
                                            fontWeight: FontWeight.w800
                                          ),
                                        ),
                                      ),
                                      Container(
                                        padding: EdgeInsets.symmetric(horizontal: 15.0),
                                        child: Text(
                                          "People in line: ${snapshot.data[index].data["peopleInLine"].toString()}",
                                          style: GoogleFonts.robotoSlab(
                                              fontSize: 20.0,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w600
                                          ),
                                        ),
                                      )
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 18.0,),
                        ],
                      );
                    }
                  );
                }
              },),
            ),
            SizedBox(height: 50.0,)
            ],
          ),
      ),
    );
  }
}
