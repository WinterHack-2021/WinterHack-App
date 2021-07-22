import 'package:flutter/material.dart';

class ChipWidget extends StatelessWidget {
  final String name;
  final bool isChecked;
  final void Function(bool selected) onSelected;

  ChipWidget({required this.name,required  this.isChecked, required this.onSelected});

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(name,
          style: Theme.of(context).textTheme.caption!.copyWith(
              color: isChecked ? Colors.white : Colors.grey.shade800)),
      selected: isChecked,
      backgroundColor: Colors.grey.shade300,
      selectedColor: Colors.orange,
      onSelected:onSelected,
    );
  }

}
