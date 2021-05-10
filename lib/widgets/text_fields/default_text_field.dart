import 'package:flutter/material.dart';
import 'package:kahootify/color_consts.dart';

class DefaultTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? label;

  const DefaultTextField({required this.controller, this.label});

  @override
  Widget build(BuildContext context) {
    return TextField(
      textCapitalization: TextCapitalization.characters,
      controller: controller,
      cursorColor: kBackgroundGreenColor,
      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: kBackgroundGreenColor),
        ),
        labelText: label,
        labelStyle: TextStyle(color: kBackgroundGreenColor),
      ),
    );
  }
}
