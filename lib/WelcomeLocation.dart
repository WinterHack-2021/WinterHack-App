import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:animated_text_kit/animated_text_kit.dart';
import 'package:winterhack_2021/clickable_container.dart';

class WelcomeLocation extends StatefulWidget {
  @override
  _WelcomeLocationState createState() => _WelcomeLocationState();
}

class _WelcomeLocationState extends State<WelcomeLocation> {
  Widget _locationCard(String name) {
    return Column(children: [
      Container(
        margin: EdgeInsets.all(20),
        child: Card(
          child: new InkWell(
              customBorder: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              onTap: (){},
              child: Column(children: [
                Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                        padding:
                        EdgeInsets.symmetric(horizontal: 35, vertical: 17),
                        child: Row(
                          children: [

                            SizedBox(width: 3),
                            Icon(Icons.arrow_forward_ios, color: Color(0xff969696), size: 13,),
                          ],
                        )
                    )),
                Text("awdawd ")
              ])),
          color: Color(0xff1c1c1e),
          elevation: 3,
          shape: RoundedRectangleBorder(
              side: BorderSide(width: 1, color: Colors.grey.shade800),
              borderRadius: BorderRadius.circular(30)),
        ),
      ),
    ]);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Padding(
      padding: EdgeInsets.fromLTRB(40, 80, 30, 45),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text('Locations',
              style: TextStyle(
                fontSize: 30.0,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.0,
              )),
          SizedBox(height: 20),
          Text(
            'LOCATIONS AT WHICH YOU WISH FOR DISTRACTING APPS TO DISABLE',
            textAlign: TextAlign.left,
            style: TextStyle(
              height: 1.4,
              fontSize: 13,
              letterSpacing: 0.5,
            ),
          ),
          SizedBox(height: 20),
          Container(
            child: Expanded(
              child: ListView(
                children: <Widget>[
                  _locationCard("AIWUdb")
                ],
              ),
            ),
          ),
        ],
      ),
    ));
  }
}
