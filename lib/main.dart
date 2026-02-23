import 'package:flutter/material.dart';
import 'package:tock/screens/game_selection_screen.dart';
import 'package:tock/screens/home_page.dart';


void main() async {



  runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});



  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AI Anki',
      home: HomePage(gameId: '2'),
    );
  }
}
