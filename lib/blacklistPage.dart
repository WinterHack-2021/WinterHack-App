import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:installed_apps/app_info.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:provider/provider.dart';
import 'package:winterhack_2021/data/shared_storage.dart';
import 'package:winterhack_2021/selector_card.dart';

import 'data/schema.dart';

const platform = const MethodChannel('winterhack-channel');
const String portName = "ConnectingIsolate";

class BlacklistPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Blacklist();
}

class Blacklist extends State<BlacklistPage> {
  List<AppInfo> appList = [];

  setDisabledApps() async {
    await platform.invokeMethod(
        "setDisabledApps", ["com.google.android.gm", "com.google.android.gm"]);
  }

  @override
  void initState() {
    super.initState();
    InstalledApps.getInstalledApps(true, true).then((value) => setState(() {
          appList = value;
        }));
  }

  @override
  Widget build(BuildContext context) {
    ThemeData theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 80),
      child: Column(
        children: [
          Text("Disabled Apps", style: theme.textTheme.headline3),
          Text("Select the apps you wish to disable",
              style: theme.textTheme.headline6),
          SizedBox(
            height: 40,
          ),
          Expanded(
            child: Consumer<GlobalModel>(
              builder: (context, value, child) {
                final sortedAppList = List.of(appList);
                // Sort the list so switches that are on are at the top
                // otherwise, preserve initial alphabetical ordering.
                sortedAppList.sort((a, b) {
                  final containsA = value.disabledApps.contains(a.name);
                  final containsB = value.disabledApps.contains(b.name);
                  if ((containsA && containsB) || (!containsA && !containsB))
                    return 0;
                  return containsA && !containsB ? -1 : 1;
                });
                return ListView(
                  children: [
                    ...sortedAppList.map((app) => SelectorCardWidget(
                          icon: app.icon,
                          name: app.name != null ? app.name! : "",
                          onChanged: (selected) {
                            if (app.name == null || app.packageName == null)
                              return;
                            if (selected)
                              value.disabledApps.upsert(
                                  App(app.name!, app.packageName!, selected));
                            else
                              value.disabledApps.remove(app.name!);
                          },
                          isActive: app.name != null &&
                              (value.disabledApps.get(app.name!) ?? false),
                        ))
                  ],
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
