import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GameSelectionScreen extends StatefulWidget{
  const GameSelectionScreen({super.key});

  @override
  State<StatefulWidget> createState() => _GameSelectionScreenState();


}

class _GameSelectionScreenState extends State<GameSelectionScreen>{
  @override
  Widget build(BuildContext context) {
    return
    Scaffold(
      appBar: AppBar(
        title: Text( "Select Game"
      ),
      )
    );
  }
}
