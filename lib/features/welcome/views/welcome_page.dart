import 'package:flutter/material.dart';
import 'package:kahootify/color_consts.dart';
import 'package:kahootify/features/settings/views/settings_page.dart';
import 'package:kahootify/features/welcome/views/widgets/welcome_button.dart';

import '../../../const.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundLightColor,
      appBar: AppBar(
        title: Text(kAppName),
        backgroundColor: kBackgroundGreenColor,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: IconButton(
              onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => SettingsPage())),
              icon: Icon(Icons.settings),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                kSelectGameMode,
                style: TextStyle(fontSize: 25, color: kBasedBlackColor),
              ),
              SizedBox(height: 35),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  WelcomeButton(
                    /* onPressed: () => changeToTwenty(context),*/
                    onPressed: () {
                      print("User wybrał host-player mode");
                    }, //TODO funkcja od wyboru host-player mode
                    value: "HOST-PLAYER MODE",
                  ),
                  SizedBox(height: 50),
                  WelcomeButton(
                    /* onPressed: () => changeToTwenty(context),*/
                    onPressed: () {
                      print("User wybrał player mode");
                    }, //TODO funkcja od wyboru player mode
                    value: "PLAYER MODE",
                  ),
                  SizedBox(height: 50),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
