
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
  List<String?> playerCards = [];
  List<String?> playerBalls = [];

  List<Alignment> mockHoles = [
    Alignment(-0.5, -0.5),
    Alignment(-0.5, 0.5),
    Alignment(0.5, -0.5),
    Alignment(0.5, 0.5),
  ];

  Widget buildCard(int cardIndex){
    return Expanded(
      child: GestureDetector(
      onTap: () {
        print("Card ${cardIndex + 1} is played");
      },
      child: Image.asset('images/${playerCards[cardIndex]}.png', fit: BoxFit.contain),
      ),
    );
  }

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
      playerCards = splitSentence;
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
            AspectRatio(
              aspectRatio: 1,
            child: Stack(
              children: [
                ClipRRect(
                  borderRadius: const BorderRadius.vertical(
                    top: Radius.circular(8.0)),
                    child: Image.asset('images/board.jpg'),
                  ),
                ...mockHoles.map((pos) => Align(
                  alignment: pos,
                  child: SizedBox(
                    width: 10,
                    height: 10,
                    child: ClipOval(
                    child: Image.asset('images/green_marble.jpg',
                      fit: BoxFit.cover),
                  ),
                  )
                )).toList()
              ]
            ),
            ),
            const Spacer(),
            SizedBox(
              height: 200,
              child: Row(
                children: playerCards.length < 4
                    ? [const Text('Waiting for cards...')]
                    : [
                      buildCard(0),
                      buildCard(1),
                      buildCard(2),
                      buildCard(3),
                ]
              ),
            ),
          ],
        ),
      );
}
