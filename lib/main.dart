import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kahootify/core/data/shared_preferences_repository.dart';
import 'package:kahootify/features/splash/views/splash_page.dart';
import 'package:kahootify/features/welcome/views/welcome_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'core/bloc/settings_cubit.dart';

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
  bool isRepositoryLoaded = false;

  Future<void> initializeSharedPreferencesRepository() async {
    prefsRepository = SharedPreferencesRepository(await SharedPreferences.getInstance());
    setState(() {
      isRepositoryLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    initializeSharedPreferencesRepository();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Kahootify.ly',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: isRepositoryLoaded
          ? BlocProvider(
              create: (context) => SettingsCubit(prefsRepository)..initialize(),
              child: WelcomePage(),
            )
          : SplashPage(),
    );
  }
}
