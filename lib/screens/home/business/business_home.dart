import 'package:barcode_scan/barcode_scan.dart';
import 'package:flutter/material.dart';

class BusinessHome extends StatefulWidget {
  @override
  _BusinessHomeState createState() => _BusinessHomeState();
}

class _BusinessHomeState extends State<BusinessHome> {
  String result = "Latest Scanned Ticket: None";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            Text(result),
            SizedBox(height: 20.0,),
            RaisedButton(
              onPressed: () async {
                var scanning = await BarcodeScanner.scan();
                setState(() {
                  result = "Latest Scanned Ticket: ${scanning.rawContent}";
                });
              },
              child: Text("Scan Ticket"),
            ),
          ],
        )
      ),
      backgroundColor: Colors.white,
    );
  }
}
