import 'package:logger/logger.dart';
import 'package:socket_io_client/socket_io_client.dart' as socket_io;

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'home_page.dart';

class GameSelectionScreen extends StatefulWidget{
  const GameSelectionScreen({super.key});

  @override
  State<StatefulWidget> createState() => _GameSelectionScreenState();


}

class _GameSelectionScreenState extends State<GameSelectionScreen>{
  socket_io.Socket? socket;
  TextEditingController playerName = TextEditingController();
  TextEditingController gameNumberToJoin = TextEditingController();
  String currentGameNumber = '';

  int playerNumber = 0;

  @override
  void initState() {
    super.initState();

    socket = socket_io.io(
        'http://10.0.2.2:5000',
        socket_io.OptionBuilder()
            .setTransports(['websocket', 'polling'])
            .enableAutoConnect()
            .build()
    );

    setupListeners();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void setupListeners() {
    socket?.on('connect', (_) => Logger().i('Connected'));

    socket?.on('fromServer', (data) {
      Logger().w('Server says: $data');
    });

    socket?.on('gameNumberFromServer',(data){
      Logger().w('Server says GameNumber: $data');
      currentGameNumber = data.toString();
      print("Current game from Print is $currentGameNumber");

      Navigator.of(context).pushReplacement(
        MaterialPageRoute(
          builder: (context) => HomePage(gameId: currentGameNumber, playerNumber: playerNumber),
        ),
      );

    });

    socket?.on('disconnect', (_) => Logger().e('Disconnected'));
  }


  Future openStartGameDialog() => showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Your name'),
      content: TextField(
        controller: playerName,
        decoration: InputDecoration(hintText: 'Enter your name to start game'),
      ),
      actions: [
        TextButton(onPressed: () {
          playerNumber = 2;
          socket?.emit('startGame', {
            'playerName':playerName.text,
            'playerNumber': playerNumber
          });
          Navigator.of(context).pop();
        }, child: Text('Submit'))
      ],
    )

  );

  Future openJoinGameDialog() => showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text('Game ID'),
        content: Column(
        children: [
          TextField(
          controller: gameNumberToJoin,
          decoration: InputDecoration(hintText: 'Enter your game ID'),
        ),
          SizedBox(height: 16),
          TextField(
            controller: playerName,
            decoration: InputDecoration(hintText: 'Enter your name to join game'),
          ),
        ]
        ),
        actions: [
          TextButton(
            onPressed: () {
            socket?.emit('joinGameViaGameID',{
              'gameId': gameNumberToJoin.text,
              'name': playerName.text
      });
            Navigator.of(context).pop();
          },
          child: Text('Submit')
      )
        ],
      ),
  );

  @override
  Widget build(BuildContext context) {
    return
    Scaffold(
      appBar: AppBar(
        title: Text( "Select Game"
      ),
      ),
      body: Column(
        children: [
          GestureDetector(
        child: Text('Create Game'
        ),
        onTap: (){
          openStartGameDialog();
        },
      ),
          GestureDetector(
            child: Text('Join Game'
            ),
            onTap: () async {
              await openJoinGameDialog();
            },
          ),
      ]
      )
    );
  }


}
