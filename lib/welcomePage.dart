import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              "Stay",
              style: TextStyle(fontSize: 32.0, fontWeight: FontWeight.normal),
            ),
            SizedBox(
              height: 10.0,
            ),
            TypewriterAnimatedTextKit(
                text: ["Productive!", "synonym 1!", "synonym 2!", "#onTrack"],
                textStyle:
                  TextStyle(fontSize: 42.0, fontWeight: FontWeight.bold),
                textAlign: TextAlign.center,
                totalRepeatCount: 4,
                displayFullTextOnTap: true,
                stopPauseOnTap: true
            )
          ]
        )
      )
    );
  }
}