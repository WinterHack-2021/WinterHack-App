import 'package:flutter/material.dart';

class ChipState extends StatefulWidget {
  String locationname;

  ChipState(this.locationname);

  @override
  _ChipStateState createState() => _ChipStateState();
}

class _ChipStateState extends State<ChipState> {
  bool _selected = false;

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(widget.locationname,
          style: Theme.of(context).textTheme.caption!.copyWith(
              color: _selected ? Colors.white : Colors.grey.shade800)),
      selected: _selected,
      backgroundColor: Colors.grey.shade300,
      selectedColor: Colors.orange,
      onSelected: (bool selected) {
        setState(() {
          _selected = !_selected;
        });
      },
    );
  }
}
