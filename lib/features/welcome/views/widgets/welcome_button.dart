import 'package:flutter/material.dart';
import 'package:kahootify/color_consts.dart';

class WelcomeButton extends StatelessWidget {
  final Function onPressed;
  final String value;

  const WelcomeButton({Key key, this.onPressed, this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      height: 100,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(value, style: TextStyle(fontSize: 20)),
        style: ElevatedButton.styleFrom(
            primary: kBackgroundGreenColor,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
            elevation: 50,
            padding: EdgeInsets.all(20.0),
            textStyle: TextStyle(color: kBackgroundLightColor)),
      ),
    );
  }
}
