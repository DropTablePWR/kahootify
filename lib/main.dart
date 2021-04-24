import 'package:flutter/material.dart';
import 'package:kahootify/features/welcome/views/welcome_page.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: WelcomePage(),
    );
  }
}
