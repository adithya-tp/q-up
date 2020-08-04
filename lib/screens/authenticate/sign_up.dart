import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:y_wait/screens/home/business/business_home.dart';
import 'package:y_wait/screens/home/business/get_business_details.dart';
import 'package:y_wait/screens/home/customer/customer_bottom_navbar.dart';
import 'package:y_wait/screens/home/customer/get_customer_details.dart';
import 'package:y_wait/screens/loading.dart';
import 'package:y_wait/services/auth.dart';
import 'package:y_wait/shared/text_input_decoration.dart';

class SignUp extends StatefulWidget {

  final Function toggleAuthenticationView;
  SignUp({this.toggleAuthenticationView});

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {
  String error = "";
  String errorCategory = "";
  bool isBusinessHighlighted = false;
  bool isCustomerHighlighted = false;
  bool isLoading = false;
  final _formKey = GlobalKey<FormState>();
  TextEditingController emailTextEditingController = new TextEditingController();
  TextEditingController passwordTextEditingController = new TextEditingController();
  FireBaseAuthMethods authMethods = new FireBaseAuthMethods();

  validateSignUp(String category) async {
    String _email = emailTextEditingController.text;
    String _password = passwordTextEditingController.text;
    if(_formKey.currentState.validate()) {
      setState(() {
        isLoading = true;
      });

      // To force a category selection when signing up.
      print("Line1 $isBusinessHighlighted");
      print("Line2 $isCustomerHighlighted");
      if ((isBusinessHighlighted == null && isCustomerHighlighted == null) || !(isBusinessHighlighted || isCustomerHighlighted)) {
        setState(() {
          isLoading = false;
          errorCategory = "Please choose a category";
        });
      }

      // If either category has been chosen, we can move onto the auth check for signing up a user.
      else {
        if(category == "business") {
          final businessResult = await Navigator.push(context, MaterialPageRoute(
              builder: (context) => GetBusinessDetails()
          ));
          print(businessResult);

          if(businessResult != null) {
            dynamic result = await authMethods.signUpBusinessWithEmailAndPassword(
                businessName: businessResult[0], email: _email, password: _password, maxCap: int.parse(businessResult[1]), category: businessResult[2]);
            print(result);
            if(result == null) {
              setState(() {
                isLoading = false;
                error = "Sorry something went wrong";
              });
            } else {
              Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) => BusinessHome()
              ));
            }
          } // end of auth
          else {
            setState(() {
              isLoading = false;
              error = "You did not fill out all the details";
            });
          }
        }
        else if(category == "customer") {
          final customerResult = await Navigator.push(context, MaterialPageRoute(
            builder: (context) => GetCustomerDetails()
          ));
          print(customerResult);

          if(customerResult != null) {
            dynamic result = await authMethods.signUpCustomerWithEmailAndPassword(
              customerName: customerResult[0], email: _email, password: _password
            );
            if(result == null) {
              setState(() {
                isLoading = false;
                error = "Sorry something went wrong";
              });
            } else {
              Navigator.pushReplacement(context, MaterialPageRoute(
                  builder: (context) => CustomerNavBar()
              ));
            }
          }
          else {
            setState(() {
              isLoading = false;
              error = "You did not fill out all the details";
            });
          }
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading ? Loading() :
    Scaffold(
      backgroundColor: Color(0xff1f1f1f),
//      appBar: AppBar(
//        centerTitle: true,
//        title: Image.asset('assets/images/ywait.jpeg', height: 160.0),
//        flexibleSpace: Container(
//          decoration: BoxDecoration(
//              gradient: LinearGradient(
//                  begin: Alignment.centerLeft,
//                  end: Alignment.centerRight,
//                  colors: [
//                    Color(0xff1f1f1f),
//                    Color(0xff1f1f1f)
//                  ]
//              )
//          ),
//        ),
//      ),
      body: isLoading ? Container(
        child: Loading(),
      ) : Container(
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
                  height: 590.0,
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
                                return val.length > 0 ? null : "Please enter an e-mail";
                              },
                              controller: emailTextEditingController,
                              cursorColor: Colors.black,
                              decoration: textInputDecoration.copyWith(hintText: 'E-mail'),
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 20.0
                              ),
                            ),
                            SizedBox(height: 10.0,),
                            TextFormField(
                              validator: (val) {
                                return val.length > 5 ? null : "Enter a password with at least 6 characters";
                              },
                              obscureText: true,
                              controller: passwordTextEditingController,
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
                          SizedBox(height: 5.0,),
                          Text(
                            error,
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 14.0
                            ),
                          ),
                          SizedBox(height: 20.0,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Pick an account type",
                                style: GoogleFonts.robotoSlab(
                                  fontSize: 20.0,
                                  color: Colors.black,
                                  fontWeight: FontWeight.w500,
                                ),
                              )
                            ],
                          ),
                          SizedBox(height: 15.0,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: <Widget>[
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isBusinessHighlighted = !isBusinessHighlighted;
                                    if(isCustomerHighlighted)
                                      isCustomerHighlighted = false;
                                  });
                                },
                                child: Container(
                                  height: 50.0,
                                  width: 150.0,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: isBusinessHighlighted == false ? Color(0xff1f1c18) : Colors.greenAccent,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Text(
                                    "Retailer",
                                    style: GoogleFonts.robotoSlab(
                                      fontSize: 20.0,
                                      color: isBusinessHighlighted == false ? Colors.white : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isCustomerHighlighted = !isCustomerHighlighted;
                                    if(isBusinessHighlighted)
                                      isBusinessHighlighted = false;
                                  });
                                },
                                child: Container(
                                  height: 50.0,
                                  width: 150.0,
                                  alignment: Alignment.center,
                                  decoration: BoxDecoration(
                                    color: isCustomerHighlighted == false ? Color(0xff1f1c18) : Colors.greenAccent,
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  child: Text(
                                    "Customer",
                                    style: GoogleFonts.robotoSlab(
                                      fontSize: 20.0,
                                      color: isCustomerHighlighted == false ? Colors.white : Colors.black,
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 5.0,),
                          Text(
                            errorCategory,
                            style: TextStyle(
                                color: Colors.red,
                                fontSize: 14.0
                            ),
                          ),
                          SizedBox(height: 50.0,),
                          GestureDetector(
                            onTap: () {
                              if(isBusinessHighlighted)
                                validateSignUp("business");
                              else
                                validateSignUp("customer");
                            },
                            child: Container(
                              height: 50.0,
                              alignment: Alignment.center,
                              decoration: BoxDecoration(
                                color: Color(0xff302b63),
                                borderRadius: BorderRadius.circular(10.0),
                              ),
                              child: Text(
                                "Continue with Registration",
                                style: GoogleFonts.robotoSlab(
                                  fontSize: 20.0,
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ),
                          SizedBox(height: 20.0,),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                "Already have an account? ",
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
                                    "Sign In here",
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
