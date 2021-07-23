// @dart=2.9

import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:winterhack_2021/initial.dart';
import 'package:flutter/material.dart';
import 'package:winterhack_2021/saved_data.dart';
import 'clickable_container.dart';
import 'dart:isolate';
import 'dart:ui';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;

void printHello() {
  final DateTime now = DateTime.now();
  final int isolateId = Isolate.current.hashCode;
  print("[$now] Hello, world! isolate=${isolateId} function='$printHello'");
  print('yoyoyoy');
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(MaterialApp(
    debugShowCheckedModeBanner: false,
    home: GlobalModel.asWidget(HomeWidget()),
    theme: ThemeData.dark(),
  ));
}

class HomeWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Home();
}

class Home extends State<HomeWidget> {
  bool isActive = false;

  @override
  void initState() {
    super.initState();
    bg.BackgroundGeolocation.onGeofence((bg.GeofenceEvent event) {
      print('trigged fence');
      print('Action: ${event.action}');
      print('Identifier: ${event.identifier}');
    });

    bg.BackgroundGeolocation.start();
  }

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
          (isActive
              ? AnimatedTextKit(
                  animatedTexts: [
                    ColorizeAnimatedText('onTrack',
                        textStyle: TextStyle(
                            fontSize: 45.0,
                            fontFamily: 'Horizon',
                            fontWeight: FontWeight.bold),
                        colors: [
                          Colors.white,
                          Colors.white,
                          Colors.purple,
                          Colors.blue,
                          Colors.yellow,
                          Colors.red,
                        ])
                  ],
                  totalRepeatCount: 1,
                )
              : Text("offTrack",
                  style: theme.textTheme.headline3.copyWith(
                      fontWeight: FontWeight.w500, color: Colors.white))),
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
            Consumer<GlobalModel>(
              builder: (context, value, child) {
                Duration duration = Duration(milliseconds: value.totalTime);

                return ClickableContainer(
                    child: Padding(
                        padding: EdgeInsets.fromLTRB(0, 10, 0, 30),
                        // Source: https://stackoverflow.com/questions/54775097/formatting-a-duration-like-hhmmss
                        child: Text(
                            "${duration.inHours} Hours, ${duration.inMinutes.remainder(60)} Minutes",
                            style: theme.textTheme.subtitle1
                                .copyWith(fontSize: 23))),
                    onClick: () {
                      value.setTotalTime(value.totalTime + 100000);
                      value.savedLocations.upsert("ff", false);
                    });
              },
            ),
          ],
        )),
      ]),
    );
  }
}
