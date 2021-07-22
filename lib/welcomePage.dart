import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    const duration = const Duration(milliseconds: 50);
    var styling = TextStyle(fontSize: 45.0, fontWeight: FontWeight.bold);
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            SizedBox(
              height: 75
            ),
            Text(
              "Stay",
              style: TextStyle(fontSize: 40.0, fontWeight: FontWeight.normal),
            ),
            SizedBox(
              height: 10.0,
            ),
            AnimatedTextKit(
              pause: const Duration(milliseconds: 50),
              animatedTexts: [
                TyperAnimatedText(
                    'Productive!',
                    textStyle:
                      styling,
                    speed: duration,
                ),
                TyperAnimatedText(
                    'Focused!',
                    textStyle:
                      styling,
                    speed: duration,
                ),
                TyperAnimatedText(
                    'Concentrated!',
                    textStyle:
                      styling,
                    speed: duration,
                ),
                ColorizeAnimatedText(
                    '#onTrack',
                    textStyle:
                      TextStyle(fontSize: 45.0, fontFamily: 'Horizon', fontWeight: FontWeight.bold),
                    speed: duration,
                    colors: [
                      Colors.purple,
                      Colors.blue,
                      Colors.yellow,
                      Colors.red,
                    ]
                )
              ],
                totalRepeatCount: 1,
            )
          ]
        )
      )
    );
  }
}