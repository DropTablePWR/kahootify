import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:just_audio/just_audio.dart';
import 'package:kahootify/core/bloc/ip_cubit.dart';
import 'package:kahootify/core/data/ip_repository.dart';
import 'package:kahootify/core/data/shared_preferences_repository.dart';
import 'package:kahootify/core/models/settings.dart';
import 'package:kahootify/features/game/views/game_page.dart';
import 'package:kahootify/features/game_config/views/game_config_page.dart';
import 'package:kahootify/features/lobby/views/lobby_page.dart';
import 'package:kahootify/features/manual_server_connection/views/qr_code_scan_page.dart';
import 'package:kahootify/features/results/views/results_page.dart';
import 'package:kahootify/features/server_browsing/views/server_discovery_page.dart';
import 'package:kahootify/features/settings/views/settings_page.dart';
import 'package:kahootify/features/splash/views/splash_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'features/settings/bloc/settings_cubit.dart';
import 'features/welcome/welcome_page.dart';

class SimpleBlocObserver extends BlocObserver {
  @override
  void onChange(BlocBase bloc, Change change) {
    super.onChange(bloc, change);
    print('${bloc.runtimeType} $change');
  }
}

void main() {
  Bloc.observer = SimpleBlocObserver();
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late SharedPreferencesRepository prefsRepository;
  late String ip;
  bool isRepositoryLoaded = false;
  bool isIpLoaded = false;
  late AudioPlayer audioPlayer;
  bool isAudioPlayerLoaded = false;

  Future<void> initializeSharedPreferencesRepository() async {
    prefsRepository = SharedPreferencesRepository(await SharedPreferences.getInstance());
    setState(() => isRepositoryLoaded = true);
  }

  Future<void> tryGetInitialWifiIp() async {
    String? localIP;
    while (localIP == null) {
      localIP = await IpRepository.getIp();
    }
    ip = localIP;
    setState(() => isIpLoaded = true);
  }

  @override
  void initState() {
    super.initState();
    initializeSharedPreferencesRepository();
    tryGetInitialWifiIp();
    initializePlayer();
  }

  Future<void> initializePlayer() async {
    audioPlayer = AudioPlayer();
    await audioPlayer.setAsset('assets/bg_music.mp3');
    await audioPlayer.setLoopMode(LoopMode.one);
    setState(() => isAudioPlayerLoaded = true);
  }

  void startMusic() async {
    if (!audioPlayer.playing) {
      await audioPlayer.play();
    }
  }

  void stopMusic() async {
    if (audioPlayer.playing) {
      await audioPlayer.stop();
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isRepositoryLoaded && isIpLoaded && isAudioPlayerLoaded) {
      return MultiBlocProvider(
        providers: [
          BlocProvider<SettingsCubit>(create: (_) => SettingsCubit(prefsRepository)..initialize()),
          BlocProvider<IpCubit>(create: (_) => IpCubit(ip)),
        ],
        child: Builder(builder: (context) {
          return BlocListener<SettingsCubit, Settings>(
            listenWhen: (previous, current) => previous.isMusicEnabled != current.isMusicEnabled,
            listener: (_, settings) {
              if (settings.isMusicEnabled) {
                startMusic();
              } else {
                stopMusic();
              }
            },
            child: MaterialApp(
              title: 'Kahootify.ly',
              theme: ThemeData(primarySwatch: Colors.blue),
              initialRoute: '/',
              onGenerateRoute: (settings) => getRoute(context, settings),
            ),
          );
        }),
      );
    } else {
      return MaterialApp(home: SplashPage());
    }
  }
}

Route getRoute(BuildContext context, RouteSettings settings) {
  switch (settings.name) {
    case '/':
      return MaterialPageRoute(builder: (_) => WelcomePage(), settings: settings);
    case '/lobby':
      return MaterialPageRoute(builder: (_) => LobbyPage(settings.arguments as GameArgs), settings: settings);
    case '/discovery':
      return MaterialPageRoute(builder: (_) => ServerDiscoveryPage(), settings: settings);
    case '/discovery/manual':
      return MaterialPageRoute(builder: (_) => QrCodeScanPage(), settings: settings);
    case '/game':
      return MaterialPageRoute(builder: (_) => GamePage(settings.arguments as GameArgs), settings: settings);
    case '/game_config':
      return MaterialPageRoute(builder: (_) => GameConfigPage(), settings: settings);
    case '/settings':
      return MaterialPageRoute(builder: (_) => SettingsPage(), settings: settings);
    case '/results':
      return MaterialPageRoute(builder: (_) => ResultsPage(settings.arguments as GameArgs), settings: settings);
    default:
      return MaterialPageRoute(builder: (_) => WelcomePage(), settings: settings);
  }
}
