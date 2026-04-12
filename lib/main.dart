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
      home: GameSelectionScreen(),

    );
  }
}
// TO-DO: Add 4 green marble icons over each card so that the player can choose which marble to
// play, if the marble is out of the house can make it have a halo or alight behind it

// TO-DO: When the Marble button above is selected, its' avatar on the board should select too