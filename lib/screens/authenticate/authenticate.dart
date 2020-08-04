import 'package:flutter/material.dart';
import 'package:y_wait/screens/authenticate/sign_in.dart';
import 'package:y_wait/screens/authenticate/sign_up.dart';

class Authenticate extends StatefulWidget {
  @override
  _AuthenticateState createState() => _AuthenticateState();
}

class _AuthenticateState extends State<Authenticate> {
  bool showSignIn = true;

  // The authentication page toggling function that we'll be passing in to the sign in and sign up widget.
  void toggleAuthenticationPage() {
    setState(() {
      showSignIn = !showSignIn;
    });
  }

  @override
  Widget build(BuildContext context) {
    return showSignIn ? SignIn(toggleAuthenticationView: toggleAuthenticationPage) :
    SignUp(toggleAuthenticationView: toggleAuthenticationPage);
  }
}
