import 'package:flutter/material.dart';

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
        margin: EdgeInsets.symmetric(vertical: 20, horizontal: 30),
        height: 300,
        child: Card(
            child: new InkWell(onTap: () {}),
            color: Colors.white,
            elevation: 3,
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30))),
      )
    ]);
  }
}
