import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class GameSelectionScreen extends StatefulWidget{
  const GameSelectionScreen({super.key});

  @override
  State<StatefulWidget> createState() => _GameSelectionScreenState();


}

class _GameSelectionScreenState extends State<GameSelectionScreen>{

  Future openDialog() => showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Your name'),
      content: TextField(
        decoration: InputDecoration(hintText: 'Enter your name'),
      ),
      actions: [
        TextButton(onPressed: () {}, child: Text('Submit'))
      ],
    )

  );


  @override
  Widget build(BuildContext context) {
    return
    Scaffold(
      appBar: AppBar(
        title: Text( "Select Game"
      ),
      ),
      body: GestureDetector(
        child: Text('Create Game'
        ),
        onTap: (){
          openDialog();
        },
      ),
    );
  }


}
