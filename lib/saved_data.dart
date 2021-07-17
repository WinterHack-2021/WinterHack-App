import 'package:flutter/material.dart';

class Tuple<T1, T2> {
  final T1 a;
  final T2 b;

  Tuple(this.a, this.b);
}

var savedlocations = [
  Tuple('University', true),
  Tuple('School', false),
  Tuple('', false)
];
var loadedapps = [];
