import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:winterhack_2021/WelcomeApps.dart';
import 'package:winterhack_2021/WelcomeLocation.dart';
import 'package:winterhack_2021/welcomePage.dart';

class Initial extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(children: [
        WelcomePage(),
        WelcomeApps(),
        WelcomeLocation(),
      ],
      ),
    );
  }
}
