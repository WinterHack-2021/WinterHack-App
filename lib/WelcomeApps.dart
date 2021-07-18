import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class WelcomeApps extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(15, 80, 30, 15),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Blacklisted Apps',
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              )
            ),
            SizedBox(height: 20),
            Text(
              'APPS THAT WILL AUTOMATICALLY DISABLE WHEN YOU ENTER HIGH PRODUCTIVITY LOCATIONS',
              textAlign: TextAlign.center,
            )
          ],
        ),
      )
      );
  }
}