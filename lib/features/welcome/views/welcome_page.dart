import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kahootify/color_consts.dart';
import 'package:kahootify/const.dart';
import 'package:kahootify/core/bloc/settings_cubit.dart';
import 'package:kahootify/features/game_config/views/game_config_page.dart';
import 'package:kahootify/features/server_browsing/views/server_discovery_page.dart';
import 'package:kahootify/features/settings/views/settings_page.dart';
import 'package:kahootify/features/welcome/views/widgets/choose_mode_button.dart';

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
        actions: [
          Padding(
            padding: EdgeInsets.only(right: 20.0),
            child: IconButton(
              onPressed: () => Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (routeContext) {
                    return BlocProvider<SettingsCubit>.value(
                      value: context.read<SettingsCubit>(),
                      child: SettingsPage(),
                    );
                  },
                ),
              ),
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
                "SELECT GAME MODE: ",
                style: TextStyle(fontSize: 25, color: kBasedBlackColor),
              ),
              SizedBox(height: 35),
              Column(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ChooseModeButton(
                    onPressed: () => Navigator.of(context).push(GameConfigPage.route()),
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
    );
  }
}
