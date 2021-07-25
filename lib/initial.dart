import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:winterhack_2021/pages/onboarding/welcome_apps.dart';
import 'package:winterhack_2021/pages/onboarding/welcome_location.dart';
import 'package:winterhack_2021/pages/onboarding/welcome_page.dart';

class Initial extends StatefulWidget {
  @override
  _InitialState createState() => _InitialState();
}

class _InitialState extends State<Initial> {
  PageController pageController = PageController(initialPage: 0);
  int _currentPage = 0;
  var _pages = [
    WelcomePage(),
    WelcomeLocation(),
    WelcomeApps(),
  ];

  List<Widget> _buildPageIndicator() {
    List<Widget> list = [];
    for (int i = 0; i < _pages.length; i++) {
      list.add(i == _currentPage ? _indicatorWidget(true) : _indicatorWidget(false));
    }
    return list;
  }

  Widget _indicatorWidget(bool isActive) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 150),
      margin: EdgeInsets.symmetric(horizontal: 8.0),
      height: 8.0,
      width: isActive ? 24.0 : 16.0,
      decoration: BoxDecoration(
        color: isActive ? Colors.white : Color(0xfff00008),
        borderRadius: BorderRadius.all(Radius.circular(12)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      body: Column(
        children: [
          Expanded(
            flex: 10,
            child: PageView(
              controller: pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentPage = index;
                });
              },
              children: _pages,
            ),
          ),
          Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: _buildPageIndicator()),
          Container(
            margin: const EdgeInsets.fromLTRB(0, 0, 0, 10),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                IconButton(
                    splashRadius: 20,
                    onPressed: () {
                      if (_currentPage == 2) {
                        Navigator.pop(context);
                      } else {
                        setState(() {
                          pageController.animateToPage(++_currentPage,
                              duration: Duration(milliseconds: 150),
                              curve: Curves.bounceInOut);
                        });
                      }
                    },
                    icon: Icon(Icons.arrow_forward_ios, color: Colors.white)),
                SizedBox(width: 15)
              ],
            ),
          ),
        ],
      ),
    );
  }
}
