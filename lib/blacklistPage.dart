import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class BlacklistPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
        appBar: AppBar(
      title: Text('Blacklist Page'),
          elevation: 0,
        ),
      body: Container(child: Column(children: [BlacklistBox()])));
  }
}

class BlacklistBox extends StatefulWidget {
  @override
  _BlacklistBoxState createState() => _BlacklistBoxState();
}

class _BlacklistBoxState extends State<BlacklistBox> {
  Widget build(BuildContext context) {
    return Container(
        child: Column(children: [
          TextButton(
              onPressed: () {
                setState(() {
                  // Some state change
                });
              },
              child: Text('Click for location')),
          Text("Lol")
        ]));
  }
}
