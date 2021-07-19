import 'package:flutter/cupertino.dart';
import 'package:winterhack_2021/initial.dart';
import 'package:flutter/material.dart';
import 'clickable_container.dart';

void main() => runApp(MaterialApp(
      home: HomeWidget(),
      theme: ThemeData.dark(),
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
          Text((isActive ? "on" : "off") + "Track ",
              style: theme.textTheme.headline3!
                  .copyWith(fontWeight: FontWeight.w500, color: Colors.white)),
          SizedBox(width: 30),
          Transform.scale(
              scale: 1.5,
              child: CupertinoSwitch(
                value: isActive,
                onChanged: (value) => setState(() => isActive = value),
              ))
        ]),
        ClickableLocationContainer(),
        ClickableAppsContainer(),
        ClickableContainer(
            child: Padding(
                padding: EdgeInsets.fromLTRB(0, 10, 0, 30),
                child: Text("10 Hours, 15 Minutes",
                    style: theme.textTheme.subtitle1!.copyWith(fontSize: 23))),
            onClick: () {})
      ]),
    );
  }
}
