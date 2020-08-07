import 'package:barcode_scan/barcode_scan.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
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
  String image = "https://is5-ssl.mzstatic.com/image/thumb/Purple123/v4/db/9e/ee/db9eee75-b8bc-6656-39c6-9ba2c84f7612/AppIcon-0-0-1x_U007emarketing-0-0-0-7-0-0-sRGB-0-0-0-GLES2_U002c0-512MB-85-220-0-0.png/246x0w.png";

  Future<bool> validateScan(String uid, String customer) async {
    final CollectionReference businessCollection = Firestore.instance.collection("business");
    String bName = await businessCollection.document(uid).get().then((DocumentSnapshot ds) => ds.data["businessName"]);
    List<String> person = await businessCollection.document(uid).get().then((DocumentSnapshot ds) => ds.data["people"]);
    List<String> customerData = customer.split(" ");
    if(person.isNotEmpty) {
      if(customerData[0] == person[0].toString() && customerData[1] == bName) {
        print("Granted!");
        return true;
      }
      else
        print("Not granted!");
      return false;
    }
    print("yo ass @ the wrong store foo!");
    return false;
  }

  @override
  Widget build(BuildContext context) {
    User user = Provider.of<User>(context);
    return Scaffold(
      body: Center(
        child: Column(
          children: <Widget>[
            SizedBox(height: 100,),
            Text(result,
            textAlign: TextAlign.center,
            style: GoogleFonts.robotoSlab(
              fontSize: 15.0,
              fontWeight: FontWeight.w600,
            )),
            SizedBox(height: 20.0,),
            Container(
              child: Image(
                image: NetworkImage(
                  image
                ),
              ),
              height: 200,
            ),
            RaisedButton(
              onPressed: () async {
                var scanning = await BarcodeScanner.scan();
                bool granted = await validateScan(user.userId, scanning.rawContent);
                if(granted) {
                  setState(() {
                    result = "Your ticket has been validated!";
                    image = "https://encrypted-tbn0.gstatic.com/images?q=tbn%3AANd9GcQSYLCgYmsWzps-k4-DSaySLiCKaJxGV2A8ow&usqp=CAU";
                  });
                }
                else {
                  setState(() {
                    result = "Invalid ticket!";
                    image = "https://media1.thehungryjpeg.com%2Fthumbs2%2Fori_3492754_88a3f58393f5cf49f38c7707a038c956be66b6e0_stop-sign-symbol-warning-stopping-icon-prohibitory-character-or-traf.jpg";
                  });
                }
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
