import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:kahootify/color_const.dart';
import 'package:kahootify/features/server_browsing/bloc/server_discovery_bloc.dart';

class SearchingErrorWidget extends StatelessWidget {
  final String message;
  final String? solutionMessage;

  const SearchingErrorWidget({required this.message, this.solutionMessage});

  static const _errorTextStyle = TextStyle(fontSize: 25, color: KColors.basedBlackColor);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(top: 35),
      constraints: BoxConstraints.expand(),
      child: Column(children: [
        Text(message, style: _errorTextStyle),
        if (solutionMessage != null) Text(solutionMessage!, style: _errorTextStyle),
        SizedBox(height: 35),
        ElevatedButton(
          onPressed: () => context.read<ServerDiscoveryBloc>().add(RefreshRequested()),
          child: Text("REFRESH", style: TextStyle(fontSize: 20)),
          style: ElevatedButton.styleFrom(
            primary: KColors.backgroundGreenColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            elevation: 5,
            padding: EdgeInsets.all(20.0),
            textStyle: TextStyle(color: KColors.backgroundLightColor),
          ),
        ),
      ]),
    );
  }
}
