import 'package:flutter/material.dart';

class FancyButton extends StatelessWidget {
  final Function() onPressed;
  final String value;

  const FancyButton({Key? key, required this.onPressed, required this.value}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      style: ButtonStyle(
        backgroundColor: MaterialStateProperty.all<Color>(Colors.black),
      ),
      onPressed: onPressed,
      child: Text(value),
    );
  }
}
