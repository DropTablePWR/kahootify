import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kahootify/color_consts.dart';
import 'package:kahootify/const.dart';
import 'package:kahootify/core/bloc/settings_cubit.dart';
import 'package:kahootify/core/models/settings.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPage createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {
  final playerNameInputController = TextEditingController();

  @override
  void initState() {
    super.initState();
    playerNameInputController.addListener(_setCurrentPlayerName);
  }

  @override
  void dispose() {
    playerNameInputController.dispose();
    super.dispose();
  }

  _setCurrentPlayerName() {
    context.read<SettingsCubit>().setPlayerName(playerNameInputController.text);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: kBackgroundLightColor,
      appBar: AppBar(
        title: Text(kSettings),
        backgroundColor: kBackgroundGreenColor,
      ),
      body: SafeArea(
        child: BlocBuilder<SettingsCubit, Settings>(
          builder: (context, settings) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(height: 35),
                Center(
                  child: Text(
                    settings.playerName == null ? "PLAYERNAME" : settings.playerName.toString(),
                    style: TextStyle(fontSize: 35, color: kBasedBlackColor, fontWeight: FontWeight.bold),
                  ),
                ),
                SizedBox(height: 35),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 8, vertical: 16),
                  child: TextField(
                    textCapitalization: TextCapitalization.characters,
                    controller: playerNameInputController,
                    decoration: InputDecoration(
                      border: UnderlineInputBorder(),
                      labelText: 'Enter your username',
                    ),
                  ),
                ),
                SizedBox(height: 35),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(settings.isMusicEnabled == true ? Icons.volume_up : Icons.volume_off, size: 50, color: kBackgroundGreenColor),
                    SizedBox(width: 35),
                    Switch(
                      value: settings.isMusicEnabled,
                      onChanged: (value) => context.read<SettingsCubit>().setMusicEnabled(isMusicEnabled: !settings.isMusicEnabled),
                      activeTrackColor: kBasedBlackColor,
                      activeColor: kBackgroundGreenColor,
                    ),
                  ],
                ),
                SizedBox(height: 35),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Icon(settings.isSfxEnabled == true ? Icons.music_note : Icons.music_off, size: 50, color: kBackgroundGreenColor),
                    SizedBox(width: 35),
                    Switch(
                      value: settings.isSfxEnabled,
                      onChanged: (value) => context.read<SettingsCubit>().setSfxEnabled(isSfxEnabled: !settings.isSfxEnabled),
                      activeTrackColor: kBasedBlackColor,
                      activeColor: kBackgroundGreenColor,
                    ),
                  ],
                ),
              ],
            );
          },
        ),
      ),
    );
  }
}
