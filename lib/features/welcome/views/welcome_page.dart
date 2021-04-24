import 'package:flutter/material.dart';
import 'package:kahootify/features/welcome/views/widgets/fancy_button.dart';

class WelcomePage extends StatefulWidget {
  @override
  _WelcomePageState createState() => _WelcomePageState();
}

class _WelcomePageState extends State<WelcomePage> {
  String value = '10';

  void changeToTwenty(BuildContext superContext) {
    print("test");
    showDialog(
        context: superContext,
        builder: (context) {
          return Material(
            child: Center(
              child: Container(
                child: Column(
                  children: [
                    Text("cześć"),
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          value = "123";
                        });
                        Navigator.of(context).pop();
                      },
                      child: Text("Wyjście"),
                    ),
                  ],
                ),
              ),
            ),
          );
        });
    setState(() {
      value = (int.parse(value) + 1).toString();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("WELCOME SCREEN"),
      ),
      body: SafeArea(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Welcome",
                style: TextStyle(fontSize: 40, color: Colors.red),
              ),
              FancyButton(
                onPressed: () => changeToTwenty(context),
                value: value,
              ),
            ],
          ),
        ),
      ),
    ); //TODO create welcome page UI
  }
}
