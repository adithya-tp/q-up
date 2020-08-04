import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

class Loading extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
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
      child: Center(
        child: SpinKitCubeGrid(
          color: Colors.greenAccent,
          size: 50.0,
        ),
      ),
    );
  }
}