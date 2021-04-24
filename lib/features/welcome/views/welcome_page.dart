import 'package:flutter/material.dart';
import 'package:kahootify/color_consts.dart';
import 'package:kahootify/features/settings/views/settings_page.dart';
import 'package:kahootify/features/welcome/views/widgets/welcome_button.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackground2Color,
      appBar: AppBar(
        title: Text("KAHOOTIFY.LY"),
        backgroundColor: kBackground1Color,
        actions: <Widget>[
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: GestureDetector(
              onTap: () => Navigator.of(context).push(MaterialPageRoute(builder: (context) => SettingsPage())), /*settingsDialog(context),*/
              child: Icon(Icons.settings),
            ),
          )
        ],
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  "SELECT GAME MODE: ",
                  style: TextStyle(fontSize: 25, color: kButtonColor),
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
                    ]),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
