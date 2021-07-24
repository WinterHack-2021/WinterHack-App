// @dart=2.9

import 'dart:ui';

import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_background_geolocation/flutter_background_geolocation.dart'
    as bg;
import 'package:provider/provider.dart';
import 'package:winterhack_2021/data/shared_storage.dart';
import 'package:winterhack_2021/initial.dart';
import 'package:winterhack_2021/placesapi.dart';

import 'clickable_container.dart';
import 'geofencing.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(OnTrack());
  bg.BackgroundGeolocation.registerHeadlessTask(headlessTask);
}

class OnTrack extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
        create: (context) => PlaceBloc(),
        child: GlobalModel.asWidget(MaterialApp(
          debugShowCheckedModeBanner: false,
          home: HomeWidget(),
          theme: ThemeData.dark(),
        )));
  }
}

class HomeWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Home();
}

class Home extends State<HomeWidget> {
  @override
  void initState() {
    super.initState();
    bg.BackgroundGeolocation.onGeofence((bg.GeofenceEvent event) {
      print('trigged fence');
      print('Action: ${event.action}');
      print('Identifier: ${event.identifier}');
    });

    bg.BackgroundGeolocation.ready(bg.Config(
        enableHeadless: true, stopOnTerminate: false, startOnBoot: true));

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
      body: Consumer<GlobalModel>(
        builder: (context, state, child) {
          Duration duration = Duration(milliseconds: state.totalTime);
          return Column(children: <Widget>[
            SizedBox(height: 20),
            Row(mainAxisAlignment: MainAxisAlignment.center, children: [
              (state.isOnTrack
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
                    value: state.isOnTrack,
                    onChanged: (value) =>
                        setState(() => state.isOnTrack = value),
                  ))
            ]),
            Expanded(
                child: ListView(
              children: [
                ClickableLocationContainer(),
                ClickableAppsContainer(),
                ClickableContainer(
                  title: "Time on Track",
                  child: Padding(
                      padding: EdgeInsets.fromLTRB(0, 10, 0, 30),
                      // Source: https://stackoverflow.com/questions/54775097/formatting-a-duration-like-hhmmss
                      child: Text(
                          "${duration.inHours} Hours, ${duration.inMinutes.remainder(60)} Minutes",
                          style: theme.textTheme.subtitle1
                              .copyWith(fontSize: 23))),
                )
              ],
            )),
          ]);
        },
      ),
    );
  }
}
