
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as socket_io;
import 'package:logger/logger.dart';

class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();

}

class _HomePageState extends State<HomePage> {
  socket_io.Socket? socket;
  TextEditingController chatController = TextEditingController();
  List<String?> playerHand = [];
  List<String?> playerCards = [];

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

  void dealNewCards() {

  }

  void parseReceivedHand(data) {
    String sentence = data.toString();

    String cleanSentence = sentence
        .replaceAll('[', '')
        .replaceAll(']', '')
        .replaceAll("'", '');
    List<String> splitSentence = cleanSentence
        .split(',')
        .map((e) => e.trim())
        .toList();

    setState(() {
      playerHand = splitSentence;
    });

    print("split " + splitSentence.toString());
  }

  void setupListeners() {
    socket?.on('connect', (_) => Logger().i('Connected'));
    socket?.on('fromServer', (data) {
      Logger().w('Server says: $data');
    });
    socket?.on('getCard', (data) {
      Logger().w('Server says: $data');
      parseReceivedHand(data);
    });
    socket?.on('disconnect', (_) => Logger().e('Disconnected'));
  }

  @override
  Widget build(BuildContext context) =>
      Scaffold(
        appBar: AppBar(title: const Text('Flutter Socket IO')),
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: chatController,
                decoration: const InputDecoration(labelText: 'Type a message'),
              ),
            ),
            ElevatedButton(
              onPressed: () {
                if (chatController.text.isNotEmpty) {
                  socket?.emit('msg', chatController.text);
                  chatController.clear();
                  socket?.emit('requestCard');
                }
              },
              child: const Text('Send to Server'),
            ),
            ElevatedButton(
                onPressed: () {
                  print("new" + playerHand.toString());
                },
                child:
                Text('No Cards yet')
            ),
            SizedBox(
              height: 200,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: playerHand.length < 4
                    ? [const Text('Waiting for cards...')]
                    : [
                  Expanded(child: Image.asset(
                      'images/${playerHand[0]}.png', fit: BoxFit.contain)),
                  Expanded(child: Image.asset(
                      'images/${playerHand[1]}.png', fit: BoxFit.contain)),
                  Expanded(child: Image.asset(
                      'images/${playerHand[2]}.png', fit: BoxFit.contain)),
                  Expanded(child: Image.asset(
                      'images/${playerHand[3]}.png', fit: BoxFit.contain)),
                ],
              ),
            ),
          ],
        ),
      );
}
