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
          padding: EdgeInsets.fromLTRB(40, 80, 30, 45),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              Text(
                  'Locations',
                  style: TextStyle(
                    fontSize: 30.0,
                    fontWeight: FontWeight.bold,
                    letterSpacing: 1.0,
                  )
              ),
              SizedBox(height: 20),
              Text(
                'LOCATIONS AT WHICH YOU WISH FOR DISTRACTING APPS TO DISABLE',
                textAlign: TextAlign.left,
                style: TextStyle(
                  height: 1.4,
                  fontSize: 13,
                  letterSpacing: 0.5,
                ),
              ),
              SizedBox(height: 20),
              Container(
                color: Colors.blue,
              ),
            ],
          ),
        )
    );
  }
}
