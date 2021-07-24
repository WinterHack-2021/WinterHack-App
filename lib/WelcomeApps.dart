import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:winterhack_2021/clickable_container.dart';
import 'package:winterhack_2021/selector_card.dart';
import 'data/schema.dart';
import 'package:flutter/services.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:provider/provider.dart';
import 'package:winterhack_2021/data/shared_storage.dart';



class WelcomeApps extends StatefulWidget {
  @override
  _WelcomeAppsState createState() => _WelcomeAppsState();
}

class _WelcomeAppsState extends State<WelcomeApps> {
  bool isActive = false;
  List<AppInfo> appList = [];

  @override
  void initState() {
    super.initState();
    InstalledApps.getInstalledApps(true, true).then((value) => setState(() {
      appList = value;
    }));
  }

  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    Function(bool selected) onChanged=(selected)=>setState(()=>isActive=selected);
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.fromLTRB(30, 80, 30, 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text(
              'Blacklisted Apps',
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              )
            ),
            SizedBox(height: 20),
            Text(
              'APPS THAT WILL DISABLE WHEN YOU ENTER HIGH PRODUCTIVITY LOCATIONS',
              textAlign: TextAlign.left,
              style: TextStyle(
                height: 1.4,
                fontSize: 13,
                letterSpacing: 0.5,
              ),
            ),
            Expanded(
              child: Consumer<GlobalModel>(
                builder: (context, value, child) {
                  final sortedAppList = List.of(appList);
                  // Sort the list so switches that are on are at the top
                  // otherwise, preserve initial alphabetical ordering.
                  sortedAppList.sort((a, b) {
                    final containsA = value.disabledApps.contains(a.packageName);
                    final containsB = value.disabledApps.contains(b.packageName);
                    if ((containsA && containsB) || (!containsA && !containsB))
                      return 0;
                    return containsA && !containsB ? -1 : 1;
                  });
                  return ListView(
                    children: [
                      ...sortedAppList.map((app) => SelectorCardWidget(
                        icon: app.icon,
                        name: app.name ?? "Unknown name",
                        onChanged: (selected) {
                          if (app.name == null || app.packageName == null)
                            return;
                          if (selected)
                            value.disabledApps.upsert(
                                App(app.name!, app.packageName!, selected));
                          else
                            value.disabledApps.remove(app.packageName!);
                        },
                        isActive: app.packageName != null &&
                            ((value.disabledApps.get(app.packageName!) ??
                                false)),
                      ))
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      )
      );
  }
}