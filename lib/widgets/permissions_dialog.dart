import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const platform = const MethodChannel('winterhack-channel');

class PermissionsDialog extends StatelessWidget {
  showAlertDialog(BuildContext context, String permission) {
    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed: () => Navigator.of(context, rootNavigator: true).pop('dialog'),
    );
    Widget continueButton = TextButton(
      child: Text("Yes"),
      onPressed: () => platform.invokeMethod("openNeededSettings"),
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Enable Permissions"),
      content: Text("Please Enable: $permission"),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<dynamic>(
        future: platform.invokeMethod("getNeededPermission"),
        builder: (context, snapshot) {
          print("Asking for permission: ${snapshot.data}");
          if (snapshot.data != null)
            Future.delayed(
                Duration.zero, () => showAlertDialog(context, snapshot.data));

          return Container();
        });
  }
}
