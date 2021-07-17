import 'package:flutter/material.dart';
import 'locationPage.dart';
import 'package:flutter/cupertino.dart';
import 'saved_data.dart';
import 'chips.dart';

class ClickableContainer extends StatefulWidget {
  const ClickableContainer({Key? key}) : super(key: key);
  @override
  State<ClickableContainer> createState() => _ClickableContainerState();
}

/// This is the private State class that goes with ClickableContainer.
class _ClickableContainerState extends State<ClickableContainer> {
  chipList() {
    return Wrap(
      spacing: 6.0,
      runSpacing: -1.0,
      alignment: WrapAlignment.center,
      children: [for (var i in savedlocations) _buildChip(i)],
    );
  }

  List<bool> _selected = [];
  _buildChip(i) {
    return ChipState(i);
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
              onTap: () {
                Navigator.push(
                    context,
                    new MaterialPageRoute(
                        builder: (ctxt) => new LocationPage()));
              },
              child: chipList()),
          color: Colors.white,
          elevation: 3,
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
        ),
      )
    ]);
  }
}
