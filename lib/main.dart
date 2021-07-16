import 'blacklistPage.dart';
import 'locationPage.dart';
import 'welcomePage.dart';

import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
      home: Home(),
      theme: ThemeData(primaryColor: Colors.lightGreen.shade500),
    ));

class Home extends StatefulWidget {
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int timeontrack = 0;

  @override
  Widget build(BuildContext context) {
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
      body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 20),
                decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20.0)),
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
