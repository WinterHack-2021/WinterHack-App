import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:winterhack_2021/pages/geofence_page.dart';
import 'package:winterhack_2021/widgets/selector_card.dart';

class WelcomeLocation extends StatefulWidget {
  @override
  _WelcomeLocationState createState() => _WelcomeLocationState();
}

class _WelcomeLocationState extends State<WelcomeLocation> {
  bool isActive = false;

  @override
  Widget build(BuildContext context) {
    Function(bool selected) onChanged =
        (selected) => setState(() => isActive = selected);
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.fromLTRB(30, 0, 30, 30),
      child: SingleChildScrollView(child: GeoFenceWidget()),
    ));
  }
}
