import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:winterhack_2021/clickable_container.dart';
import 'package:winterhack_2021/selector_card.dart';

class WelcomeApps extends StatefulWidget {
  @override
  _WelcomeAppsState createState() => _WelcomeAppsState();
}

class _WelcomeAppsState extends State<WelcomeApps> {
  bool isActive = false;

  @override
  Widget build(BuildContext context) {
    Function(bool selected) onChanged=(selected)=>setState(()=>isActive=selected);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(30, 80, 30, 30),
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
              'APPS THAT WILL DISABLE WHEN YOU ENTER HIGH PRODUCTIVITY LOCATIONS',
              textAlign: TextAlign.left,
              style: TextStyle(
                height: 1.4,
                fontSize: 13,
                letterSpacing: 0.5,
              ),
            ),
            Expanded(
              child: ListView(
                children: <Widget>[
                  SelectorCardWidget(
                    name: "University",
                    isActive: isActive,
                    onChanged: onChanged,
                  ),
                  SelectorCardWidget(
                    name: "Work",
                    isActive: isActive,
                    onChanged: onChanged,
                  ),
                  SelectorCardWidget(
                    name: "School",
                    isActive: isActive,
                    onChanged: onChanged,
                  ),
                  SelectorCardWidget(
                    name: "McDonalds",
                    isActive: isActive,
                    onChanged: onChanged,
                  ),
                  SelectorCardWidget(
                    name: "Vishal's Crib",
                    isActive: isActive,
                    onChanged: onChanged,
                  ),
                  SelectorCardWidget(
                    name: "Office",
                    isActive: isActive,
                    onChanged: onChanged,
                  ),
                  SelectorCardWidget(
                    name: "Optiver's bank",
                    isActive: isActive,
                    onChanged: onChanged,
                  ),
                ],
              ),
            ),
          ],
        ),
      )
      );
  }
}