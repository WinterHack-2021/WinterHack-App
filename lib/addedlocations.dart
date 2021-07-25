import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class AddedLocations extends StatefulWidget {
  const AddedLocations({Key? key}) : super(key: key);

  @override
  _AddedLocationsState createState() => _AddedLocationsState();
}

class _AddedLocationsState extends State<AddedLocations> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Saved Locations'),
        ),
        body: Column(children: [Text('herl')]));
  }
}
