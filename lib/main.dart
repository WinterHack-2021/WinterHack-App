import 'package:flutter/cupertino.dart';
import 'package:winterhack_2021/initial.dart';
import 'package:flutter/material.dart';
import 'clickable_container.dart';
import 'package:android_alarm_manager_plus/android_alarm_manager_plus.dart';
import 'locationPage.dart';
import 'dart:isolate';
import 'package:animated_text_kit/animated_text_kit.dart';

void printHello() {
  final DateTime now = DateTime.now();
  final int isolateId = Isolate.current.hashCode;
  print("[$now] Hello, world! isolate=${isolateId} function='$printHello'");
  print('yoyoyoy');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final int locationAlarmID = 0;
  await AndroidAlarmManager.initialize();
  runApp(MaterialApp(
    home: HomeWidget(),
    theme: ThemeData.dark(),
  ));

  await AndroidAlarmManager.periodic(
      const Duration(seconds: 5), locationAlarmID, printHello,
      exact: true);
}

class HomeWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Home();
}

class Home extends State<HomeWidget> {
  bool isActive = false;

  @override
  Widget build(BuildContext context) {
    var theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        centerTitle: true,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            tooltip: 'Notifications',
            padding: EdgeInsets.only(right: 20),
            onPressed: () {
              Navigator.push(
                context,
                new MaterialPageRoute(builder: (ctxt) => new Initial()),
              );
            },
          ),
        ],
      ),
      body: Column(children: <Widget>[
        SizedBox(height: 20),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          (isActive ? AnimatedTextKit(animatedTexts: [ColorizeAnimatedText(
              'onTrack', textStyle: TextStyle(fontSize: 45.0, fontFamily: 'Horizon', fontWeight: FontWeight.bold),
              colors: [
                Colors.white,
                Colors.white,
                Colors.purple,
                Colors.blue,
                Colors.yellow,
                Colors.red,
              ]
          )], totalRepeatCount: 1,) : Text("offTrack", style: theme.textTheme.headline3!.copyWith(fontWeight: FontWeight.w500, color: Colors.white))),
          SizedBox(width: 30),
          Transform.scale(
              scale: 1.5,
              child: CupertinoSwitch(
                value: isActive,
                onChanged: (value) => setState(() => isActive = value),
              ))
        ]),
        Expanded(
            child: ListView(
          children: [
            ClickableLocationContainer(),
            ClickableAppsContainer(),
            ClickableContainer(
                child: Padding(
                    padding: EdgeInsets.fromLTRB(0, 10, 0, 30),
                    child: Text("10 Hours, 15 Minutes",
                        style:
                            theme.textTheme.subtitle1!.copyWith(fontSize: 23))),
                onClick: () {}),
          ],
        )),
      ]),
    );
  }
}
