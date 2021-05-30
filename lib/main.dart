import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kahootify/core/bloc/ip_cubit.dart';
import 'package:kahootify/core/data/ip_repository.dart';
import 'package:kahootify/core/data/shared_preferences_repository.dart';
import 'package:kahootify/features/splash/views/splash_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/bloc/settings_cubit.dart';
import 'features/welcome/views/welcome_page.dart';

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

  Future<void> initializeSharedPreferencesRepository() async {
    prefsRepository = SharedPreferencesRepository(await SharedPreferences.getInstance());
    setState(() {
      isRepositoryLoaded = true;
    });
  }

  Future<void> tryGetInitialWifiIp() async {
    String? localIP;
    while (localIP == null) {
      localIP = await IpRepository.getIp();
    }
    ip = localIP;
    setState(() {
      isIpLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    initializeSharedPreferencesRepository();
  }

  @override
  Widget build(BuildContext context) {
    if (isRepositoryLoaded && isIpLoaded) {
      return MultiBlocProvider(
        providers: [
          BlocProvider<SettingsCubit>(create: (_) => SettingsCubit(prefsRepository)..initialize()),
          BlocProvider<IpCubit>(create: (_) => IpCubit(ip)),
        ],
        child: MaterialApp(
          title: 'Kahootify.ly',
          theme: ThemeData(primarySwatch: Colors.blue),
          home: WelcomePage(),
        ),
      );
    } else {
      return MaterialApp(home: SplashPage());
    }
  }
}
