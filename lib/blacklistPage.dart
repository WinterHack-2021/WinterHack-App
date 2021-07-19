import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:installed_apps/installed_apps.dart';
import 'package:installed_apps/app_info.dart';

// class BlacklistPage extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return new Scaffold(
//         appBar: AppBar(
//       title: Text('Blacklist Page'),
//           elevation: 0,
//         ),
//       body: Container(child: Column(children: [BlacklistBox()])));
//   }
// }
//
// class BlacklistBox extends StatefulWidget {
//   @override
//   _BlacklistBoxState createState() => _BlacklistBoxState();
// }

class BlacklistPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    // TODO: implement createState
    return Blacklist();
  }
}

class Blacklist extends State<BlacklistPage> {
  //Widget get home => _BlacklistBoxState();

  static const platform = const MethodChannel('winterhack-channel');
  String _randomString = '';

  Future<void> _getAndroidString() async {
    String randomString;
    try {
      final String result = await platform.invokeMethod('disablerEnabler');
      randomString = 'Random string $result % .';
    } on PlatformException catch (e) {
      randomString = "Failed to get random string: '${e.message}'.";
    }

    setState(() {
      _randomString = randomString;
    });
  }

  @override
  Widget build(BuildContext context) {
    _getAndroidString();
    // 1. Enable an app
    // 2. Disable app
    // enableApp(appId)
    // disableApp(appId)
    //print(_randomString);
    return Scaffold(body: Column(children:[Text(_randomString)]));
  }
}

class _BlacklistBoxState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Installed Apps Example")),
      body: ListView(
        children: [
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: ListTile(
                title: Text("Installed Apps"),
                subtitle: Text(
                    "Get installed apps on device. With options to exclude system app, get app icon & matching package name prefix."),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => InstalledAppsScreen(),
                  ),
                ),
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: ListTile(
                title: Text("App Info"),
                subtitle: Text("Get app info with package name"),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => AppInfoScreen(),
                  ),
                ),
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: ListTile(
                title: Text("Start App"),
                subtitle: Text(
                    "Start app with package name. Get callback of success or failure."),
                onTap: () => InstalledApps.startApp("com.google.android.gm"),
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: ListTile(
                title: Text("Go To App Settings Screen"),
                subtitle: Text(
                    "Directly navigate to app settings screen with package name"),
                onTap: () =>
                    InstalledApps.openSettings("com.google.android.gm"),
              ),
            ),
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8),
              child: ListTile(
                title: Text("Check If System App"),
                subtitle: Text("Check if app is system app with package name"),
                onTap: () =>
                    InstalledApps.isSystemApp("com.google.android.gm").then(
                  (bool? value) => _showDialog(
                      context,
                      value ?? false
                          ? "The requested app is system app."
                          : "Requested app in not system app."),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  void _showDialog(BuildContext context, String text) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(text),
          actions: <Widget>[
            TextButton(
              child: Text("Close"),
              onPressed: () => Navigator.of(context).pop(),
            ),
          ],
        );
      },
    );
  }
}

class InstalledAppsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Installed Apps")),
      body: FutureBuilder<List<AppInfo>>(
        future: InstalledApps.getInstalledApps(true, true),
        builder:
            (BuildContext buildContext, AsyncSnapshot<List<AppInfo>> snapshot) {
          return snapshot.connectionState == ConnectionState.done
              ? snapshot.hasData
                  ? ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        AppInfo app = snapshot.data![index];
                        return Card(
                          child: ListTile(
                            leading: CircleAvatar(
                              backgroundColor: Colors.transparent,
                              child: Image.memory(app.icon!),
                            ),
                            title: Text(app.name!),
                            subtitle: Text(app.getVersionInfo()),
                            onTap: () =>
                                InstalledApps.startApp(app.packageName!),
                            onLongPress: () =>
                                InstalledApps.openSettings(app.packageName!),
                          ),
                        );
                      },
                    )
                  : Center(
                      child: Text(
                          "Error occurred while getting installed apps ...."))
              : Center(child: Text("Getting installed apps ...."));
        },
      ),
    );
  }
}

class AppInfoScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("App Info")),
      body: FutureBuilder<AppInfo>(
        future: InstalledApps.getAppInfo("com.google.android.gm"),
        builder: (BuildContext buildContext, AsyncSnapshot<AppInfo> snapshot) {
          return snapshot.connectionState == ConnectionState.done
              ? snapshot.hasData
                  ? Center(
                      child: Column(
                        children: [
                          Image.memory(snapshot.data!.icon!),
                          Text(
                            snapshot.data!.name!,
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 40,
                            ),
                          ),
                          Text(snapshot.data!.getVersionInfo())
                        ],
                      ),
                    )
                  : Center(child: Text("Error while getting app info ...."))
              : Center(child: Text("Getting app info ...."));
        },
      ),
    );
  }
}

// Widget build(BuildContext context) {
//   return Container(
//       child: Column(children: [
//         TextButton(
//             onPressed: () {
//               setState(() {
//                 // Some state change
//               });
//             },
//             child: Text('Click for location')),
//         Text("Lol")
//       ]));
// }
