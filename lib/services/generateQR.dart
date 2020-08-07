import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:y_wait/models/user.dart';

class GenerateQR extends StatefulWidget {

  final BusinessData businessData;
  GenerateQR({this.businessData});

  @override
  _GenerateQRState createState() => _GenerateQRState();
}

class _GenerateQRState extends State<GenerateQR> {
  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    return SingleChildScrollView(
      child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget> [
            Container(
              padding: EdgeInsets.fromLTRB(0.0, 20.0, 0.0, 20.0),
              child: Text(
                "Ticket Issued for ${widget.businessData.businessName}!",
                style: GoogleFonts.robotoSlab(
                  color: Colors.black,
                  fontSize: 25,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(0.0, 10.0, 0.0, 10.0),
              child: Text(
                "Here's your QR Code",
                style: GoogleFonts.robotoSlab(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            Container(
              child: QrImage(
                data: "${user.userId} ${widget.businessData.businessName}",
                size: 200,
              ),
            ),
            Container(
              padding: EdgeInsets.fromLTRB(40.0, 40.0, 10.0, 10.0),
              child: Text(
                "You can access this QR code from the TICKETS tab later",
                style: GoogleFonts.robotoSlab(
                  color: Colors.black,
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                ),
              ),
            ),
          ]
      ),
    );
  }
}