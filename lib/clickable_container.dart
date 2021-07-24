import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:winterhack_2021/data/shared_storage.dart';
import 'locationPage.dart';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'chips.dart';
import 'blacklistPage.dart';
import 'geofencing.dart';

class ClickableContainer extends StatelessWidget {
  static const double BORDER_RADIUS = 10;
  final Widget child;
  final String title;
  final void Function()? onClick;

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      Container(
        margin: EdgeInsets.all(20),
        child: Card(
          child: new InkWell(
              customBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(BORDER_RADIUS),
              ),
              onTap: onClick,
              child: Column(children: [
                Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 35, vertical: 17),
                        child: Row(
                          children: [
                            Text(title.toUpperCase(),
                                style: Theme.of(context)
                                    .textTheme
                                    .caption!
                                    .copyWith(
                                        color: Color(0xff969696),
                                        fontWeight: FontWeight.w600,
                                        fontSize: 14)),
                            SizedBox(width: 3),
                            onClick!=null? Icon(
                              Icons.arrow_forward_ios,
                              color: Color(0xff969696),
                              size: 13,
                            ):SizedBox(),
                          ],
                        ))),
                child
              ])),
          color: Color(0xff1c1c1e),
          elevation: 3,
          shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: Colors.grey.shade800),
              borderRadius: BorderRadius.circular(BORDER_RADIUS)),
        ),
      ),
    ]);
  }

  ClickableContainer(
      {required this.child,
      this.onClick,
      this.title = "Sample Title"});
}

class ClickableLocationContainer extends StatefulWidget {
  @override
  State<ClickableLocationContainer> createState() =>
      _ClickableLocationContainerState();
}

/// This is the private State class that goes with ClickableLocationContainer.
class _ClickableLocationContainerState
    extends State<ClickableLocationContainer> {
  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalModel>(
        builder: (context, value, child) => ClickableContainer(
            child: getChipsWidget(Future.value(value.savedLocations)),
            title: "Locations",
            onClick: () {
              Navigator.push(context,
                  new MaterialPageRoute(builder: (ctxt) => GeoFence()));
            }));
  }
}

class ClickableAppsContainer extends StatefulWidget {
  @override
  State<ClickableAppsContainer> createState() => _ClickableAppsContainerState();
}

class _ClickableAppsContainerState extends State<ClickableAppsContainer> {
  @override
  Widget build(BuildContext context) {
    return Consumer<GlobalModel>(
        builder: (context, value, child) => ClickableContainer(
            child: getChipsWidget(Future.value(value.disabledApps)),
            title: "Disabled Apps",
            onClick: () {
              Navigator.push(context,
                  new MaterialPageRoute(builder: (ctxt) => BlacklistPage()));
            }));
  }
}

Widget getChipsWidget(Future<StorageMap> func) {
  return FutureBuilder(
    future: func,
    builder: (context, AsyncSnapshot<StorageMap> snapshot) {
      final dat = snapshot.hasData ? snapshot.data!.items : Map();
      if (dat.isEmpty) {
        return Padding(
            padding: EdgeInsets.fromLTRB(0, 0, 0, 20),
            child: Text(
              "(Tap to Add Items)",
              style:
                  Theme.of(context).textTheme.overline!.copyWith(fontSize: 15),
            ));
      }
      return Wrap(
        spacing: 6.0,
        runSpacing: -1.0,
        alignment: WrapAlignment.center,
        children: [
          for (var i in dat.entries)
            ChipWidget(
                name: i.key,
                isChecked: i.value,
                onSelected: (selected) =>
                    snapshot.data!.upsert(i.key, selected))
        ],
      );
    },
  );
}
