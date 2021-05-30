import 'package:flutter/material.dart';
import 'package:kahootify/color_const.dart';

class ChooseModeButton extends StatelessWidget {
  final Function() onPressed;
  final String text;

  const ChooseModeButton({required this.onPressed, required this.text});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 250,
      height: 100,
      child: ElevatedButton(
        onPressed: onPressed,
        child: Text(
          text,
          style: TextStyle(fontSize: 20),
        ),
        style: ElevatedButton.styleFrom(
          primary: kBackgroundGreenColor,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
          elevation: 15,
          padding: EdgeInsets.all(20.0),
          textStyle: TextStyle(color: kBackgroundLightColor),
        ),
      ),
    );
  }
}
