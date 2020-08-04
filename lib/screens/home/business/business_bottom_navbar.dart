import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:y_wait/screens/authenticate/authenticate.dart';
import 'package:y_wait/screens/home/business/business_home.dart';
import 'package:y_wait/screens/home/business/business_settings.dart';
import 'package:y_wait/services/auth.dart';

class BusinessNavBar extends StatefulWidget {
  @override
  _BusinessNavBarState createState() => _BusinessNavBarState();
}

class _BusinessNavBarState extends State<BusinessNavBar> {
  FireBaseAuthMethods _authMethods = new FireBaseAuthMethods();
  int selectedIndex = 1;
  final tabs = [
    Center(child: Text("Tickets")),
    BusinessHome(),
    BusinessSettings(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),
      appBar: AppBar(
        backgroundColor: Color(0xff1f1f1f),
        title: Text(
          "Welcome Back!",
          style: GoogleFonts.robotoSlab(
              fontSize: 20.0,
              fontWeight: FontWeight.w500,
              color: Colors.white),
        ),
        actions: <Widget>[
          GestureDetector(
            onTap: () {
              _authMethods.signOut().then((value) {
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
