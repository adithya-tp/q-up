import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:y_wait/shared/text_input_decoration.dart';

class GetCustomerDetails extends StatefulWidget {
  @override
  _GetCustomerDetailsState createState() => _GetCustomerDetailsState();
}

class _GetCustomerDetailsState extends State<GetCustomerDetails> {
  List result = [];
  final _formKey = GlobalKey<FormState>();
  TextEditingController customerNameTextEditingController = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color(0xff1f1f1f),
      appBar: AppBar(
        backgroundColor: Color(0xff1f1f1f),
        centerTitle: true,
        title: Text(
          "Enters Details",
          style: GoogleFonts.robotoSlab(
            fontSize: 30.0,
            fontWeight: FontWeight.w500,
            color: Colors.white,
          ),
        ),
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [
                  Color(0xffC6FFDD),
                  Color(0xffFBD786),
                  Color(0xfff7797d)
                ]
            )
        ),
        child: SingleChildScrollView(
          child: Container(
            margin: EdgeInsets.only(top: 20.0),
            padding: EdgeInsets.symmetric(horizontal: 24.0),
            child: Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 50.0, left: 15.0, right: 15.0),
                  height: 540.0,
                  decoration: BoxDecoration(
                    boxShadow: [
                      BoxShadow(color: Colors.grey.withOpacity(0.8),
                          spreadRadius: 5.0,
                          blurRadius: 7.0,
                          offset: Offset(0, 3)),
                    ],
                    borderRadius: BorderRadius.circular(10.0),
                    color: Colors.white,
                  ),
                ),
                Column(
                  children: <Widget>[
                    Form(
                      key: _formKey,
                      child: Container(
                        margin: EdgeInsets.only(top: 200.0, left: 20, right: 20.0),
                        padding: EdgeInsets.symmetric(horizontal: 30.0),
                        child: Column(
                          children: <Widget>[
                            Text(
                              "What is your Full Name?",
                              style: GoogleFonts.robotoSlab(
                                fontSize: 25.0,
                                fontWeight: FontWeight.w600,
                                color: Colors.black,
                              ),
                            ),
                            SizedBox(height: 10.0,),
                            TextFormField(
                              validator: (val) {
                                return val.length > 0 ? null : "Please enter your name";
                              },
                              controller: customerNameTextEditingController,
                              cursorColor: Colors.black,
                              decoration: textInputDecoration.copyWith(hintText: 'Full name'),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.0
                              ),
                            ),
                          ],
                        ),
                      )
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 30.0),
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 140.0,),
                          GestureDetector(
                            onTap: () {
                              if(_formKey.currentState.validate()) {
                                result.add(customerNameTextEditingController.text);
                                Navigator.pop(context, result);
                              }
                            },
                            child: Container(
                              height: 50.0,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Color(0xff302b63),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Text(
                                "Sign Up",
                                style: GoogleFonts.robotoSlab(
                                  fontSize: 15.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ],
            )
          ),
        ),
      ),
    );
  }
}
