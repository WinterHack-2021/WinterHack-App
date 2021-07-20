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
            SizedBox(
              height: 90
            ),
            Text(
              "Stay",
              style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.normal),
            ),
            SizedBox(
              height: 10.0,
            ),
            AnimatedTextKit(
              animatedTexts: [
                TyperAnimatedText(
                    'Productive!',
                    textStyle:
                      TextStyle(fontSize: 45.0, fontWeight: FontWeight.bold)
                ),
                TyperAnimatedText(
                    'Focused!',
                    textStyle:
                      TextStyle(fontSize: 45.0, fontWeight: FontWeight.bold)
                ),
                TyperAnimatedText(
                    'Concentrated!',
                    textStyle:
                      TextStyle(fontSize: 45.0, fontWeight: FontWeight.bold)
                ),
                ColorizeAnimatedText(
                    '#onTrack',
                    textStyle:
                      TextStyle(fontSize: 45.0, fontFamily: 'Horizon', fontWeight: FontWeight.bold),
                    colors: [
                      Colors.purple,
                      Colors.blue,
                      Colors.yellow,
                      Colors.red,
                    ]
                )
              ],
                totalRepeatCount: 1
            )
          ]
        )
      )
    );
  }
}