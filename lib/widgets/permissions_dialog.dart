import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

const platform = const MethodChannel('winterhack-channel');

class PermissionsDialog extends StatefulWidget {
  @override
  _PermissionsDialogState createState() => _PermissionsDialogState();
}

class _PermissionsDialogState extends State<PermissionsDialog> {
  bool isOpen = false;

  showAlertDialog(BuildContext context, String permission) {
    if (isOpen) return;
    var close = () {
      Navigator.of(context, rootNavigator: true).pop('dialog');
      setState(() => isOpen = false);
    };
    Widget continueButton = TextButton(
      child: Text("Allow Access"),
      onPressed: () {
        platform.invokeMethod("openNeededSettings");
        close();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Enable Permissions"),
      content: Text("Please Enable: $permission"),
      actions: [
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        isOpen = true;
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
