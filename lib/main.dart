import 'dart:ffi';
import 'blacklistPage.dart';

import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
      home: Home(),
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
        title: Text('onTrack'),
        centerTitle: true,
        backgroundColor: Colors.purple,
      ),
      body: Row(
        children: <Widget>[
          Center(
            child: Text(
              '$timeontrack',
              style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 2.0,
                  color: Colors.grey[600]),
            ),
          ),
          TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  new MaterialPageRoute(builder: (ctxt) => new blacklistPage()),
                );
              },
              child: Text('CLICK HERE'))
        ],
      ),
      extendBody: true,
      floatingActionButton: FloatingActionButton(
        child: Text('Press to Block'),
        onPressed: () {
          setState(() {
            timeontrack += 1;
          });
        },
        backgroundColor: Colors.deepPurple,
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
