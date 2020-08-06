import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:y_wait/models/user.dart';
import 'package:y_wait/screens/home/customer/carousel.dart';
import 'package:y_wait/services/database.dart';
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

  Future<dynamic> _notInQ(User user, BusinessData businessData) async {
    final CollectionReference specificBusinessCollection = Firestore.instance.collection('${businessData.uid}');
    final snapshot = await specificBusinessCollection.document(user.userId).get();
    if(snapshot.exists || snapshot == null) {
      return false;
    }
    else {
      return true;
    }
  }

  _addToQ(User user, BusinessData businessData) async {
    final CollectionReference specificBusinessCollection = Firestore.instance.collection(businessData.uid.trim());
    final CollectionReference specificCustomerCollection = Firestore.instance.collection(user.userId.trim());
    final CollectionReference customerCollection = Firestore.instance.collection('customers');
    final CollectionReference businessCollection = Firestore.instance.collection('business');

    final snapshot = await customerCollection.document(user.userId.trim()).get();
    await specificBusinessCollection.document(user.userId.trim()).setData({
      'uid': user.userId.trim(),
      // we should be able to delete this customer name later down the line.
      'customerName': snapshot.data["customerName"],
      'positionInLine': businessData.peopleInLine + 1
    });
    await specificCustomerCollection.document(businessData.uid.trim()).setData({
      'uid': businessData.uid.trim(),
      // we should be able to delete this business name later down the line.
      'businessName': businessData.businessName,
      'positionInLine': businessData.peopleInLine + 1
    });
    print(businessData);
    print(businessData.uid);
    await businessCollection.document(businessData.uid.trim()).updateData({
      'peopleInLine': businessData.peopleInLine + 1
    });
  }

  void _showQR(User user, BusinessData businessData) async {
    dynamic notInQ = await _notInQ(user, businessData);
    if(notInQ) {
      await _addToQ(user, businessData);
      showModalBottomSheet(context: context,
        builder: (context) {
          return Container(
            color: Color(0XFF737373),
            height: 500,
            child: Container(
              child: GenerateQR(businessData: businessData,),
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
    } else {
      showModalBottomSheet(context: context,
        builder: (context) {
          return Container(
            height: 200,
            child: Container(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Container(
                    padding: EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      "Sorry, you already have a ticket issued at this place.",
                      style: GoogleFonts.robotoSlab(
                        color: Colors.black,
                        fontSize: 25,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(15),
                  topRight: const Radius.circular(15)
              ),
            ),
          );
        }
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);

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
              child: StreamBuilder(
                //future: getNearby(),
                stream: DatabaseService().businesses,
                initialData: [],
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
                          if(snapshot.data[index].category == "clothes") {
                            imageQuery = "https://source.unsplash.com/featured/?${snapshot.data[index].category}, shop";
                          } else {
                            imageQuery = "https://source.unsplash.com/featured/?${snapshot.data[index].category}, store";
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
                                        height: 190,
                                        child: Container(
                                          child: Column(
                                            children: <Widget>[
                                              Container(
                                                padding: EdgeInsets.fromLTRB(18.0, 20.0, 0.0, 10.0),
                                                child: Text(
                                                  "${ snapshot.data[index].businessName }",
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
                                                      "People currently in queue: ${snapshot.data[index].peopleInLine}",
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
//                                                      print(snapshot.data[index].runtimeType);
//                                                      print(snapshot.data[index].businessName);
//                                                      print(snapshot.data[index].category);
//                                                      print(snapshot.data[index].uid);
                                                      Navigator.pop(context);
                                                      _showQR(user, snapshot.data[index]);
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
                                              colorFilter: new ColorFilter.mode(Colors.black.withOpacity(0.8), BlendMode.dstATop),
                                              fit: BoxFit.cover
                                          )
                                      ),
                                      width: MediaQuery.of(context).size.width,
                                      height: 200.0,
                                    ),
                                    Container(
                                      margin: EdgeInsets.symmetric(horizontal: 30.0, vertical: 15.0),
                                      padding: EdgeInsets.symmetric(horizontal: 12.0),
                                      child: Column(
                                        children: <Widget>[
                                          Container(
                                            width: MediaQuery.of(context).size.width,
                                            height: 100.0,
                                            padding: EdgeInsets.symmetric(horizontal: 24.0),
                                            decoration: BoxDecoration(
                                              borderRadius: BorderRadius.circular(15.0),
                                              color: Colors.white.withOpacity(0.5)
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      width: MediaQuery.of(context).size.width,
                                      height: 200.0,
                                      padding: EdgeInsets.symmetric(horizontal: 24.0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(15.0),
                                      ),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: <Widget>[
                                          Container(
                                            margin: EdgeInsets.fromLTRB(24, 20, 24, 0),
                                            padding: EdgeInsets.symmetric(horizontal: 15.0),
                                            child: Text(
                                              "${snapshot.data[index].businessName.toString()}   (${snapshot.data[index].category.toString()})",
                                              style: GoogleFonts.robotoSlab(
                                                  fontSize: 22.0,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w800
                                              ),
                                            ),
                                          ),
                                          Container(
                                            margin: EdgeInsets.fromLTRB(40, 0, 0, 0),
                                            child: Text(
                                              "People in line: ${snapshot.data[index].peopleInLine.toString()}",
                                              style: GoogleFonts.robotoSlab(
                                                  fontSize: 28.0,
                                                  color: Colors.black87,
                                                  fontWeight: FontWeight.w800
                                              ),
                                            ),
                                          ),
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