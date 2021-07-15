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
      appBar: AppBar(
        title: Text('onTrack', style: TextStyle(color: Colors.white)),
        centerTitle: true,
      ),
      body: Row(
        children: <Widget>[
          TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(builder: (ctxt) => new blacklistPage()),
                );
              },
              child: Text('Blocked Apps')),
          TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(builder: (ctxt) => new locationPage()),
                );
              },
              child: Text('Locations')),
          TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(builder: (ctxt) => new welcomePage()),
                );
              },
              child: Text('welcome page'))
        ],
      ),
      extendBody: true,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.plus_one),
        onPressed: () {
          setState(() {
            timeontrack += 1;
          });
        },
      ),
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
