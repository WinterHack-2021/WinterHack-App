import 'blacklistPage.dart';
import 'locationPage.dart';
import 'welcomePage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() => runApp(MaterialApp(
      home: Home(),
      theme: ThemeData(primaryColor: Colors.lightGreen.shade500),
    ));

class Home extends StatelessWidget {
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
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            CupertinoButton(
              alignment: Alignment.topRight,
              child: Text('Activate'),
              color: Colors.green,
              disabledColor: Colors.red,
              pressedOpacity: 0.4,
              borderRadius: const BorderRadius.all(Radius.circular(8.0)),
              onPressed: () {},
            ),
            Container(
                alignment: Alignment.center,
                margin: EdgeInsets.symmetric(horizontal: 20, vertical: 15),
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
