import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kahootify/color_const.dart';
import 'package:kahootify/core/models/settings.dart';
import 'package:kahootify/features/settings/bloc/settings_cubit.dart';

class SettingsPage extends StatefulWidget {
  @override
  _SettingsPage createState() => _SettingsPage();
}

class _SettingsPage extends State<SettingsPage> {
  late final playerNameInputController;

  @override
  void initState() {
    super.initState();
    playerNameInputController = TextEditingController(text: context.read<SettingsCubit>().state.playerName);
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
      backgroundColor: KColors.backgroundLightColor,
      appBar: AppBar(
        title: Text("SETTINGS"),
        backgroundColor: KColors.backgroundGreenColor,
      ),
      body: SafeArea(
        child: BlocBuilder<SettingsCubit, Settings>(
          builder: (context, settings) {
            return SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(height: 35),
                  Center(
                    child: Text(settings.playerName, style: TextStyle(fontSize: 35, color: KColors.basedBlackColor, fontWeight: FontWeight.bold)),
                  ),
                  SizedBox(height: 35),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 30, vertical: 16),
                    child: TextField(
                      textCapitalization: TextCapitalization.characters,
                      controller: playerNameInputController,
                      cursorColor: KColors.backgroundGreenColor,
                      decoration: InputDecoration(
                        focusedBorder: UnderlineInputBorder(
                          borderSide: BorderSide(color: KColors.backgroundGreenColor),
                        ),
                        labelText: 'Enter your username',
                        labelStyle: TextStyle(color: KColors.backgroundGreenColor),
                      ),
                    ),
                  ),
                  SizedBox(height: 35),
                  _SoundSettingsTile(
                    icon: settings.isMusicEnabled == true ? Icons.volume_up : Icons.volume_off,
                    value: settings.isMusicEnabled,
                    onChanged: (value) => context.read<SettingsCubit>().setMusicEnabled(isMusicEnabled: !settings.isMusicEnabled),
                  ),
                  SizedBox(height: 35),
                  _SoundSettingsTile(
                    icon: settings.isSfxEnabled == true ? Icons.music_note : Icons.music_off,
                    value: settings.isSfxEnabled,
                    onChanged: (value) => context.read<SettingsCubit>().setSfxEnabled(isSfxEnabled: !settings.isSfxEnabled),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}

class _SoundSettingsTile extends StatelessWidget {
  final IconData icon;
  final bool value;
  final Function(bool) onChanged;

  const _SoundSettingsTile({
    Key? key,
    required this.icon,
    required this.value,
    required this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Icon(icon, size: 50, color: KColors.backgroundGreenColor),
        SizedBox(width: 35),
        Switch(
          value: value,
          onChanged: onChanged,
          activeTrackColor: KColors.basedBlackColor,
          activeColor: KColors.backgroundGreenColor,
          inactiveThumbColor: KColors.basedBlackColor,
        ),
      ],
    );
  }
}
