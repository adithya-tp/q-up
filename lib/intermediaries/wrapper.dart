import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:y_wait/models/user.dart';
import 'package:y_wait/screens/authenticate/authenticate.dart';
import 'package:y_wait/screens/home/business/business_home.dart';
import 'package:y_wait/screens/home/customer/customer_bottom_navbar.dart';
import 'package:y_wait/screens/loading.dart';
import 'package:y_wait/services/database.dart';

class Wrapper extends StatefulWidget {
  @override
  _WrapperState createState() => _WrapperState();
}

class _WrapperState extends State<Wrapper> {
  bool customerOrNot;

  _initGetCustomerOrNot(User user) async {
    if(user != null) {
      bool userStatus = await DatabaseService(uid: user.userId).getCustomerOrNot();
      if(userStatus != null) {
        if(mounted) {
          setState(() {
            customerOrNot = userStatus;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = Provider.of<User>(context);
    // return either the Home or Authenticate widget
    if (user == null){
      return Authenticate();
    } else {
      _initGetCustomerOrNot(user);
      if(customerOrNot == null) {
        return Loading();
      } else {
        if(customerOrNot) {
          return CustomerNavBar();
        } else {
          return BusinessHome();
        }
      }
    }
  }
}