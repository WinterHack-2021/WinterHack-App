import 'package:animated_toggle_switch/animated_toggle_switch.dart';

import 'blacklistPage.dart';
import 'locationPage.dart';
import 'welcomePage.dart';
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
      home: HomeWidget(),
      theme: ThemeData(primarySwatch: Colors.green),
    ));

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
      backgroundColor: Colors.lightGreen.shade500,
      appBar: AppBar(
        title: Text('onTrack', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            tooltip: 'Notifications',
            padding: EdgeInsets.only(right: 20),
            onPressed: () {
              // handle the press
            },
          ),
        ],
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(children: <Widget>[
        SizedBox(height: 20),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text("Active: ", style: theme.textTheme.headline5!.copyWith(color: Colors.white)),
          SizedBox(width: 30),
          AnimatedToggleSwitch<bool>.dual(
            first: false,
            current: isActive,
            second: true,
            onChanged: (b) => setState(() => isActive = b),
            colorBuilder: (b) => !b ? Colors.red.shade500 : Colors.green,
            borderColorBuilder: (b) => !b ? Colors.red.shade500 : Colors.green,
          )
        ]),
        SizedBox(height: 20),
        Container(
            alignment: Alignment.center,
            margin: EdgeInsets.symmetric(horizontal: 20),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(20.0)),
            child: Column(
              children: [
                TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (ctxt) => new blacklistPage()),
                      );
                    },
                    child: Text('Blocked Apps')),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (ctxt) => new locationPage()),
                      );
                    },
                    child: Text('Locations')),
                TextButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        new MaterialPageRoute(
                            builder: (ctxt) => new welcomePage()),
                      );
                    },
                    child: Text('welcome page'))
              ],
            ))
      ]),
    );
  }
}

class Timebar extends StatefulWidget {
  @override
  _TimebarState createState() => _TimebarState();
}

class _TimebarState extends State<Timebar> {
  int counter = 0;

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
