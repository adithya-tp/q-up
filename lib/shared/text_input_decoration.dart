import 'package:flutter/material.dart';

var textInputDecoration = InputDecoration(
    contentPadding: EdgeInsets.symmetric(horizontal: 10.0, vertical: 20.0),
    fillColor: Colors.white,
    filled: true,
    hintStyle: TextStyle(
      fontSize: 18.0,
      color: Colors.grey[500],
      fontWeight: FontWeight.w400
    ),
    focusedBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.black, width: 4.0),
    ),
    enabledBorder: UnderlineInputBorder(
      borderSide: BorderSide(color: Colors.black, width: 2.0),
    )
);