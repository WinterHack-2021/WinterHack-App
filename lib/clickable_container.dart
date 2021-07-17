import 'dart:ffi';

import 'package:flutter/material.dart';
import 'locationPage.dart';
import 'package:flutter/cupertino.dart';
import 'saved_data.dart';
import 'chips.dart';
import 'blacklistPage.dart';

class ClickableLocationContainer extends StatefulWidget {
  @override
  State<ClickableLocationContainer> createState() =>
      _ClickableLocationContainerState();
}

/// This is the private State class that goes with ClickableLocationContainer.
class _ClickableLocationContainerState
    extends State<ClickableLocationContainer> {
  @override
  // MaterialPageRoute navpage;
  // _ClickableLocationContainerState(this.navpage);
  chipList() {
    return Wrap(
      spacing: 6.0,
      runSpacing: -1.0,
      alignment: WrapAlignment.center,
      children: [for (var i in savedlocations) ChipState(i)],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        width: double.infinity,
        padding: EdgeInsets.all(8),
        child: Card(
          child: new InkWell(
              customBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              onTap: () {
                Navigator.push(context,
                    new MaterialPageRoute(builder: (ctxt) => LocationPage()));
              },
              child: chipList()),
          color: Colors.white,
          elevation: 3,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
      ),
    ]);
  }
}

class ClickableAppsContainer extends StatefulWidget {
  @override
  State<ClickableAppsContainer> createState() => _ClickableAppsContainerState();
}

class _ClickableAppsContainerState extends State<ClickableAppsContainer> {
  @override
  chipList() {
    return Wrap(
      spacing: 6.0,
      runSpacing: -1.0,
      alignment: WrapAlignment.center,
      children: [for (var i in loadedapps) ChipState(i)],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        width: double.infinity,
        padding: EdgeInsets.all(8),
        child: Card(
          child: new InkWell(
              customBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              onTap: () {
                Navigator.push(context,
                    new MaterialPageRoute(builder: (ctxt) => BlacklistPage()));
              },
              child: chipList()),
          color: Colors.white,
          elevation: 3,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
      ),
    ]);
  }
}
