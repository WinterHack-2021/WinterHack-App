import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'welcomePage.dart';
import 'package:flutter/material.dart';
import 'clickable_container.dart';

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
        centerTitle: true,
        elevation: 0,
        title: Text('onTrack', style: TextStyle(color: Colors.white)),
        actions: [
          IconButton(
            icon: const Icon(Icons.notifications, color: Colors.white),
            tooltip: 'Notifications',
            padding: EdgeInsets.only(right: 20),
            onPressed: () {
              Navigator.push(
                context,
                new MaterialPageRoute(builder: (ctxt) => new WelcomePage()),
              );
            },
          ),
        ],
      ),
      body: Column(children: <Widget>[
        SizedBox(height: 20),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: [
          Text("Active: ",
              style: theme.textTheme.headline5!.copyWith(color: Colors.white)),
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
        ClickableLocationContainer(),
        ClickableAppsContainer()
      ]),
    );
  }
}
