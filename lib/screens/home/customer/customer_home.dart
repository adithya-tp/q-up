import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:y_wait/screens/home/customer/carousel.dart';

class CustomerHome extends StatefulWidget {
  @override
  _CustomerHomeState createState() => _CustomerHomeState();
}

class _CustomerHomeState extends State<CustomerHome> {
  String username = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xffffffff),

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
          ],
        ),
    );
  }
}
