import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:y_wait/models/user.dart';
import 'package:y_wait/screens/authenticate/authenticate.dart';
import 'package:y_wait/screens/home/customer/customer_home.dart';
import 'package:y_wait/screens/home/customer/customer_settings.dart';
import 'package:y_wait/screens/home/customer/customer_tickets.dart';
import 'package:y_wait/services/auth.dart';

class CustomerNavBar extends StatefulWidget {
  @override
  _CustomerNavBarState createState() => _CustomerNavBarState();
}

class _CustomerNavBarState extends State<CustomerNavBar> {

  FireBaseAuthMethods _authMethods = new FireBaseAuthMethods();
  String username;
  int selectedIndex = 1;
  final tabs = [
    CustomerTicket(),
    CustomerHome(),
    CustomerSettings(),
  ];

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    final CollectionReference customerCollection = Firestore.instance.collection('customers');
    if(user != null) {
      customerCollection.document(user.userId).get().then((value) {
        if(mounted) {
          setState(() {
            username = value.data["customerName"];
            username = "Welcome back, ${username.split(" ")[0]}!";
          });
        }
      });
    }

    String displayText = username ?? "Welcome Back!";
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      appBar: AppBar(
        backgroundColor: Color(0xff1f1f1f),
        title: Text(
          displayText,
          style: GoogleFonts.robotoSlab(
          fontSize: 20.0,
          fontWeight: FontWeight.w500,
          color: Colors.white),
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              _authMethods.signOut().then((value) {
                //sharedPreferenceMethods.saveUserLoggedInStatus(false);
                Navigator.pushReplacement(context, MaterialPageRoute(
                    builder: (context) => Authenticate()
                ));
              });
            },
            child: Padding(
              padding: const EdgeInsets.all(10.0),
              child: Icon(
                Icons.exit_to_app,
                color: Colors.white,
              ),
            ),
          ),
        ],
      ),
      body: tabs[selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
          currentIndex: selectedIndex,
          items: [
            BottomNavigationBarItem(
              icon: Icon(Icons.home,
                  color: selectedIndex == 0 ? Color(0xff1f1f1f) : Colors.grey, size: 30.0,),
              title: Text("Tickets",
                  style: TextStyle(color: selectedIndex == 0 ? Color(0xff1f1f1f) : Colors.grey , fontSize: 20.0), ),
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.search,
                  color: selectedIndex == 1 ? Color(0xff1f1f1f) : Colors.grey, size: 30.0,),
              title: Text("Home",
                  style: TextStyle(color: selectedIndex == 1 ? Color(0xff1f1f1f) : Colors.grey , fontSize: 20.0)),
            ),

            BottomNavigationBarItem(
              icon: Icon(Icons.settings,
                  color: selectedIndex == 2 ? Color(0xff1f1f1f) : Colors.grey, size: 30.0,),
              title: Text("Settings",
                  style: TextStyle(color: selectedIndex == 2 ? Color(0xff1f1f1f) : Colors.grey , fontSize: 20.0)),
            ),
          ],
          onTap: (index) {
            if(mounted) {
              setState(() {
                selectedIndex = index;
              });
            }
          }
      ),
    );
  }
}
