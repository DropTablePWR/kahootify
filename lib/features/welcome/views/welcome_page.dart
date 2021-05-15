import 'package:flutter/material.dart';
import 'package:kahootify/color_consts.dart';
import 'package:kahootify/const.dart';
import 'package:kahootify/features/game_config/models/game_config.dart';
import 'package:kahootify/features/game_config/views/game_config_page.dart';
import 'package:kahootify/features/server_browsing/views/server_discovery_page.dart';
import 'package:kahootify/features/settings/views/settings_page.dart';
import 'package:kahootify/features/welcome/views/widgets/choose_mode_button.dart';

class WelcomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundLightColor,
      appBar: AppBar(
        title: Text(kAppName),
        backgroundColor: kBackgroundGreenColor,
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: IconButton(
              onPressed: () => Navigator.of(context).push<GameConfig>(MaterialPageRoute(builder: (routeContext) => SettingsPage())),
              icon: Icon(Icons.settings),
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
                  style: TextStyle(fontSize: 25, color: kBasedBlackColor),
                ),
                SizedBox(height: 35),
                Column(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    ChooseModeButton(
                      onPressed: () => Navigator.of(context).push(MaterialPageRoute(builder: (routeContext) => GameConfigPage())),
                      text: "HOST-GAME",
                    ),
                    SizedBox(height: 50),
                    ChooseModeButton(
                      onPressed: () => Navigator.of(context).push(ServerDiscoveryPage.route()),
                      text: "JOIN GAME",
                    ),
                    SizedBox(height: 50),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
