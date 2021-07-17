import 'package:flutter/material.dart';
import 'locationPage.dart';
import 'package:flutter/cupertino.dart';
import 'saved_data.dart';

class ClickableContainer extends StatefulWidget {
  const ClickableContainer({Key? key}) : super(key: key);
  @override
  State<ClickableContainer> createState() => _ClickableContainerState();
}

/// This is the private State class that goes with ClickableContainer.
class _ClickableContainerState extends State<ClickableContainer> {
  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        margin: EdgeInsets.symmetric(vertical: 20, horizontal: 20),
        height: 300,
        width: double.infinity,
        child: Card(
          child: new InkWell(
            onTap: () {
              Navigator.push(context,
                  new MaterialPageRoute(builder: (ctxt) => new LocationPage()));
            },
            child: Column(children: [
              FilterChip(
                label: Text('University..'),
                disabledColor: Colors.lightBlue,
                selectedColor: Colors.orange,
                selected: true,
                onSelected: (bool selected) {
                  setState(() {});
                },
              ),
            ]),
          ),
          color: Colors.white,
          elevation: 3,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
      )
    ]);
  }
}
