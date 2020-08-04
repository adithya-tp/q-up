import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:y_wait/screens/home/business/business_home.dart';
import 'package:y_wait/screens/home/customer/customer_bottom_navbar.dart';
import 'package:y_wait/screens/loading.dart';
import 'package:y_wait/services/auth.dart';
import 'package:y_wait/services/database.dart';
import 'package:y_wait/shared/text_input_decoration.dart';
import 'package:flutter/services.dart';

FireBaseAuthMethods authMethods = new FireBaseAuthMethods();

class SignIn extends StatefulWidget {

  final Function toggleAuthenticationView;
  SignIn({this.toggleAuthenticationView});

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  String error = "";
  bool yeOrNah;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();

  validateSignIn() async {
    String _email = emailTextEditingController.text;
    String _password = passwordTextEditingController.text;
    if(_formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      dynamic result;
      try {
        result = await authMethods.signInWithEmailAndPassword(email: _email, password: _password);
      } catch(e) {
        print(e.toString());
      }
      if(result == null) {
        setState(() {
          isLoading = false;
          error = "Wrong username / password";
        });
      }
      else {
        try {
          final clientStatus = await DatabaseService(uid: result.userId).getCustomerOrNot();
          if(clientStatus != null) {
            if(mounted) {
              setState(() {
                yeOrNah = clientStatus;
              });
            }
          }
        } catch(e) {
          print(e.toString());
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return isLoading ? Loading() :
    Scaffold(
//      appBar: AppBar(
//        centerTitle: true,
//        title: Image.asset('assets/images/ywait.jpeg', height: 160.0),
//        flexibleSpace: Container(
//          decoration: BoxDecoration(
//            gradient: LinearGradient(
//              begin: Alignment.centerLeft,
//              end: Alignment.centerRight,
//              colors: [
//                Color(0xff1f1f1f),
//                Color(0xff1f1f1f)
//              ]
//            )
//          ),
//        ),
//      ),
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
            padding: EdgeInsets.symmetric(horizontal: 2.0),
            child: Stack(
              children: <Widget>[
                Container(
                  margin: EdgeInsets.only(top: 10, left: 15),
                  child: Image.asset(
                    'assets/images/logo.png',
                    height: 150.0,
                    width: 600.0,
                  ),
                ),
                Container(
                  margin: EdgeInsets.only(top: 160.0, left: 15.0, right: 15.0),
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
                        margin: EdgeInsets.only(top: 240.0, left: 20, right: 20.0),
                        padding: EdgeInsets.symmetric(horizontal: 30.0),
                        child: Column(
                          children: <Widget>[
                            TextFormField(
                              validator: (val) {
                                return val.length > 0 ? null : "Please enter E-mail";
                              },
                              controller: emailTextEditingController,
                              cursorColor: Colors.black,
                              decoration: textInputDecoration.copyWith(hintText: 'E-mail'),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.0,
                              ),
                            ),
                            SizedBox(height: 10.0,),
                            TextFormField(
                              validator: (val) {
                                return val.length > 0 ? null : "Please enter password";
                              },
                              controller: passwordTextEditingController,
                              obscureText: true,
                              cursorColor: Colors.black,
                              decoration: textInputDecoration.copyWith(hintText: 'Password'),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.0
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.symmetric(horizontal: 30.0),
                      child: Column(
                        children: <Widget>[
                          SizedBox(height: 8.0,),
                          Container(
                            alignment: Alignment.centerRight,
                            child: Container(
                              padding: EdgeInsets.symmetric(vertical: 16.0, horizontal: 8.0),
                              child: Text(
                                  "Forgot Password?",
                                  style: GoogleFonts.robotoSlab(
                                      color: Colors.black,
                                      fontSize: 15.0,
                                      fontWeight: FontWeight.w800
                                  )
                              ),
                            ),
                          ),
                          SizedBox(height: 20.0,),
                          Text(
                            error,
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 14.0
                            ),
                          ),
                          SizedBox(height: 50.0,),
                          GestureDetector(
                            onTap: () async {
                              await validateSignIn();
                              if(yeOrNah != null) {
                                if(yeOrNah) {
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                                      builder: (BuildContext context) => CustomerNavBar()
                                  ));
                                }
                                else {
                                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                                      builder: (BuildContext context) => BusinessHome()
                                  ));
                                }
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
                                "Sign In",
                                style: GoogleFonts.robotoSlab(
                                  fontSize: 15.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 40.0,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Don't have an account? ",
                                style: TextStyle(
                                    color: Colors.black
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  widget.toggleAuthenticationView();
                                },
                                child: Container(
                                  padding: EdgeInsets.symmetric(vertical: 8.0),
                                  child: Text(
                                    "Register now",
                                    style: TextStyle(
                                        color: Colors.black,
                                        decoration: TextDecoration.underline
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          )
                        ],
                      ),
                    )
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
