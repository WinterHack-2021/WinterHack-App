import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class WelcomeLocation extends StatefulWidget {
  @override
  _WelcomeLocationState createState() => _WelcomeLocationState();
}

class _WelcomeLocationState extends State<WelcomeLocation> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
          padding: EdgeInsets.fromLTRB(15, 80, 30, 15),
          child: Column(
            children: <Widget>[
              Text('Locations'),
            ],
          ),
        ),
    );
  }
}
