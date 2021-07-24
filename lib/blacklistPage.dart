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

class BlacklistPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => Blacklist();
}

class Blacklist extends State<BlacklistPage> {
  List<AppInfo> appList = [];

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
      padding: const EdgeInsets.fromLTRB(30, 80, 30, 80),
      child: Column(
        children: [
          Container(
              margin: EdgeInsets.only(bottom: 30),
              child: Text("Disabled Apps", style: theme.textTheme.headline3)),
          Text("Select the apps you wish to disable:",
              style: theme.textTheme.headline6),
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
    );
  }
}
