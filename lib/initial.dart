
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:winterhack_2021/WelcomeApps.dart';
import 'package:winterhack_2021/WelcomeLocation.dart';
import 'package:winterhack_2021/main.dart';
import 'package:winterhack_2021/welcomePage.dart';

class Initial extends StatefulWidget {
  @override
  _InitialState createState() => _InitialState();
}

class _InitialState extends State<Initial> {

  PageController pageController = PageController(initialPage: 0);
  int pageChanged = 0;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 10,
            child: PageView(
              controller: pageController,
              onPageChanged: (index){
                setState(() {
                  pageChanged = index;
                });
              },
              children: [
                WelcomePage(),
                WelcomeLocation(),
                WelcomeApps(),
              ],
            ),
          ),
          Expanded(
            flex: 1,
            child: Container(
              margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(splashRadius: 20,onPressed: (){
                    if (pageChanged == 2) {
                      Navigator.pop(context);
                    } else {
                      setState(() {
                        pageController.animateToPage(++pageChanged, duration: Duration(milliseconds: 150), curve: Curves.bounceInOut);
                      });
                    }
                  }, icon: Icon(Icons.arrow_forward_ios, color: Colors.white)),
                  SizedBox(width: 15)
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}