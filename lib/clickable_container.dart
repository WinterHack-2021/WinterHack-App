import 'package:flutter/material.dart';
import 'locationPage.dart';
import 'package:flutter/cupertino.dart';
import 'saved_data.dart';
import 'chips.dart';
import 'blacklistPage.dart';

class ClickableContainer extends StatelessWidget {
  static const double BORDER_RADIUS = 10;
  final Widget child;
  final String title;
  final void Function() onClick;

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
                            EdgeInsets.symmetric(horizontal: 35, vertical: 10),
                        child: Text(title.toUpperCase(),
                            style: Theme.of(context)
                                .textTheme
                                .caption!
                                .copyWith(
                                    color: Color(0xff969696),
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14)))),
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
      required this.onClick,
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
  // MaterialPageRoute navpage;
  // _ClickableLocationContainerState(this.navpage);
  Widget chipList() {
    return Wrap(
      spacing: 6.0,
      runSpacing: -1.0,
      alignment: WrapAlignment.center,
      children: [for (var i in savedlocations) ChipState(i)],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClickableContainer(
        child: chipList(),
        title: "Locations",
        onClick: () {
          Navigator.push(context,
              new CupertinoPageRoute(builder: (ctxt) => LocationPage()));
        });
  }
}

class ClickableAppsContainer extends StatefulWidget {
  @override
  State<ClickableAppsContainer> createState() => _ClickableAppsContainerState();
}

class _ClickableAppsContainerState extends State<ClickableAppsContainer> {
  chipList() {
    return Wrap(
      spacing: 6.0,
      runSpacing: -1.0,
      alignment: WrapAlignment.center,
      children: [for (var i in loadedapps) ChipState(i)],
    );
  }

  @override
  Widget build(BuildContext context) {
    return ClickableContainer(
        title: "Disabled Apps",
        onClick: () {
          Navigator.push(context,
              new CupertinoPageRoute(builder: (ctxt) => BlacklistPage()));
        },
        child: chipList());
  }
}
