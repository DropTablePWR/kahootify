import 'package:flutter/material.dart';
import 'package:kahootify/color_const.dart';

class DefaultTextField extends StatelessWidget {
  final TextEditingController controller;
  final String? label;

  const DefaultTextField({required this.controller, this.label});

  @override
  Widget build(BuildContext context) {
    return TextField(
      textCapitalization: TextCapitalization.characters,
      controller: controller,
      cursorColor: KColors.backgroundGreenColor,
      decoration: InputDecoration(
        focusedBorder: UnderlineInputBorder(
          borderSide: BorderSide(color: KColors.backgroundGreenColor),
        ),
        labelText: label,
        labelStyle: TextStyle(color: KColors.backgroundGreenColor),
      ),
    );
  }
}
