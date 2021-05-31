import 'package:flutter/material.dart';
import 'package:flutter_neumorphic/flutter_neumorphic.dart';
import 'package:kahootify/color_const.dart';
import 'package:kahootify_server/models/server_info.dart';
import 'package:qr_flutter/qr_flutter.dart';

class BackLayer extends StatelessWidget {
  final ServerInfo serverInfo;
  final bool isPortrait;

  const BackLayer({required this.serverInfo, required this.isPortrait});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: EdgeInsets.symmetric(horizontal: 30),
        child: Column(children: [
          SizedBox(height: 20),
          ServerInfoWidget(name: "SERVER NAME: ", text: serverInfo.name, isPortrait: isPortrait),
          SizedBox(height: 20),
          ServerInfoWidget(name: "CATEGORY: ", text: serverInfo.category.name, isPortrait: isPortrait),
          SizedBox(height: 20),
          ServerInfoWidget(name: "NUMBER OF QUESTIONS: ", text: serverInfo.numberOfQuestions.toString(), isPortrait: isPortrait),
          SizedBox(height: 20),
          ServerInfoWidget(name: "TIME TO ANSWER: ", text: serverInfo.answerTimeLimit.toString() + ' s', isPortrait: isPortrait)
        ]),
      ),
    );
  }
}

class ServerInfoWidget extends StatelessWidget {
  final String name;
  final String? text;
  final bool isPortrait;

  const ServerInfoWidget({Key? key, required this.name, this.text, this.isPortrait = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Expanded(
          child: Text(
            name,
            style: TextStyle(fontSize: 15, color: isPortrait ? Colors.white : KColors.basedBlackColor, fontWeight: FontWeight.bold),
          ),
        ),
        SizedBox(width: 25),
        Expanded(
          child: Text(
            text ?? "",
            style: TextStyle(fontSize: 15, color: isPortrait ? Colors.white : KColors.basedBlackColor, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }
}

class IAmReadyButton extends StatelessWidget {
  final bool iAmReady;
  final Function() onPressed;

  const IAmReadyButton({Key? key, required this.iAmReady, required this.onPressed}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return NeumorphicButton(
      style: NeumorphicStyle(
        color: iAmReady ? KColors.backgroundGreenColor : KColors.basedBlackColor,
        depth: iAmReady ? -10 : 10,
        oppositeShadowLightSource: false,
        shadowDarkColor: KColors.basedBlackColor,
        shadowDarkColorEmboss: KColors.basedBlackColor,
        shadowLightColor: KColors.backgroundLightColor,
        shadowLightColorEmboss: KColors.backgroundLightColor,
        shape: NeumorphicShape.concave,
        boxShape: NeumorphicBoxShape.roundRect(BorderRadius.circular(8)),
      ),
      child: Container(
        width: 140,
        height: 30,
        child: iAmReady
            ? Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  NeumorphicIcon(Icons.check, size: 30),
                  Text("I am ready", style: TextStyle(color: Colors.white)),
                ],
              )
            : Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  NeumorphicIcon(Icons.clear, size: 30),
                  Text("I am not ready", style: TextStyle(color: Colors.white)),
                ],
              ),
      ),
      onPressed: onPressed,
    );
  }
}

class StartGameButton extends StatelessWidget {
  const StartGameButton({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton.extended(
      backgroundColor: KColors.backgroundGreenColor,
      label: Text("Start a game"),
      onPressed: () {
        print("Start a game");
        //TODO Rozpoczęcie rozgrywki
      },
      icon: Icon(Icons.outlined_flag, color: Colors.white, size: 50),
      shape: OutlineInputBorder(),
    );
  }
}

class DisplayQRCodeButton extends StatelessWidget {
  final String qrCode;
  final String code;

  const DisplayQRCodeButton({
    Key? key,
    required this.qrCode,
    required this.code,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(right: 20.0),
      child: IconButton(
        onPressed: () {
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Container(
                      height: 200,
                      width: 200,
                      child: QrImage(
                        data: qrCode,
                        version: QrVersions.auto,
                        size: 300.0,
                      ),
                    ),
                    Text(code)
                  ],
                ),
              );
            },
          );
        },
        icon: Icon(Icons.qr_code),
      ),
    );
  }
}
