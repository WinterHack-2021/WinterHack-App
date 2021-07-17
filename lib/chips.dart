import 'saved_data.dart';
import 'package:flutter/material.dart';

chipList() {
  return Wrap(
    spacing: 6.0,
    runSpacing: 6.0,
    children: [for (var i in savedlocations) _buildChip(i)],
  );
}

_buildChip(i) {}
