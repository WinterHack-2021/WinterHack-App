import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:winterhack_2021/initial.dart';
import 'package:flutter/material.dart';
import 'package:winterhack_2021/saved_data.dart';
import 'clickable_container.dart';
import 'geofencing.dart';
import 'dart:isolate';
import 'dart:ui';
import 'package:geofencing/geofencing.dart';
import 'package:animated_text_kit/animated_text_kit.dart';

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
    home: ChangeNotifierProvider(
        create: (BuildContext context) => GlobalModel(), child: HomeWidget()),
    theme: ThemeData.dark(),
  ));
}

class HomeWidget extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Home();
}

class Home extends State<HomeWidget> {
  bool isActive = false;

  String geofenceState = 'N/A';
  ReceivePort port = ReceivePort();

  Future<void> initPlatformState() async {
    print('Initializing...');
    await GeofencingManager.initialize();
    print('Initialization done');
  }

  @override
  void initState() {
    super.initState();
    IsolateNameServer.registerPortWithName(
        port.sendPort, 'geofencing_send_port');
    port.listen((dynamic data) {
      print('Event: $data');
      setState(() {
        geofenceState = data;
      });
    });
    initPlatformState();
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
                  style: theme.textTheme.headline3!.copyWith(
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
                            style: theme.textTheme.subtitle1!
                                .copyWith(fontSize: 23))),
                    onClick: () {
                      value.setTotalTime(value.totalTime + 100000);
                    });
              },
            ),
          ],
        )),
      ]),
    );
  }
}
