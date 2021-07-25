import 'dart:typed_data';
import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SelectorCardWidget extends StatelessWidget {
  final String name;
  final bool isActive;
  final void Function(bool selected) onChanged;
  final Uint8List? icon;

  SelectorCardWidget(
      {required this.name,
      required this.isActive,
      required this.onChanged,
      this.icon});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: new InkWell(
          customBorder: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(30),
          ),
          onTap: () => onChanged(!isActive),
          child: Column(children: [
            Align(
                alignment: Alignment.centerLeft,
                child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 25),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                            flex: 2,
                            child: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              child: icon != null
                                  ? Image.memory(icon!)
                                  : Icon(Icons.location_pin,
                                      color: Colors.grey),
                            )),
                        Expanded(
                            flex: 6,
                            child: Text(
                              name,
                              style:
                                  TextStyle(color: Colors.white, fontSize: 20),
                            )),
                        Expanded(
                          flex: 3,
                          child: Transform.scale(
                              scale: 1.5,
                              child: CupertinoSwitch(
                                value: isActive,
                                onChanged: onChanged,
                              )),
                        ),
                      ],
                    ))),
          ])),
      color: Color(0xff1c1c1e),
      elevation: 3,
      shape: RoundedRectangleBorder(
          side: BorderSide(width: 1, color: Colors.grey.shade800),
          borderRadius: BorderRadius.circular(30)),
    );
  }
}
