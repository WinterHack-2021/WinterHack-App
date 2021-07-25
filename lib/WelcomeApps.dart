import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:winterhack_2021/blacklistPage.dart';

class WelcomeApps extends StatelessWidget {
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.fromLTRB(30, 80, 30, 30),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text('Blacklisted Apps',
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              )),
          SizedBox(height: 20),
          Text(
            'APPS THAT WILL DISABLE WHEN YOU ENTER HIGH PRODUCTIVITY LOCATIONS',
            textAlign: TextAlign.left,
            style: TextStyle(
              height: 1.4,
              fontSize: 13,
              letterSpacing: 0.5,
            ),
          ),
          AppListWidget(),
        ],
      ),
    ));
  }
}
