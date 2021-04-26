import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kahootify/features/game_config/bloc/game_config_cubit.dart';
import 'package:kahootify/features/game_config/bloc/game_config_page/game_config_page_bloc.dart';

class GameConfigPage extends StatelessWidget {
  static Route route() => MaterialPageRoute(builder: (context) => GameConfigPage());

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => GameConfigCubit()),
        BlocProvider(create: (_) => GameConfigPageBloc()..add(GameConfigPageEntered())),
      ],
      child: Scaffold(
        appBar: AppBar(
          title: Text('GAME CONFIG'),
        ),
        body: GameConfigPageView(),
      ),
    );
  }
}

class GameConfigPageView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GameConfigPageBloc, GameConfigPageState>(
      builder: (context, pageState) {
        if (pageState is GameConfigPageError) {
          return Center(
            child: Text(pageState.errorMessage),
          );
        } else if (pageState is GameConfigPageReady) {
          return Column(
            children: [
              Container(
                child: Text("Tutaj switche slideey i inne \n+na zachęte lista category tak żebyś widział gdzie jest"),
              ),
              SizedBox(
                height: 300,
                child: ListView.builder(
                  itemCount: pageState.categoriesToChoose.length,
                  itemBuilder: (_, index) {
                    return Text(pageState.categoriesToChoose[index].name);
                  },
                ),
              ),
            ],
          );
        } else {
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      },
    );
  }
}
