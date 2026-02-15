
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
    Alignment(-0.175, 0.865), //SW00
    Alignment(-0.135, 0.78), //SW01
    Alignment(-0.11, 0.69), //SW02
    Alignment(-0.10, 0.69), //SW02
    Alignment(-0.09, 0.59), //SW03
    Alignment(-0.10, 0.49), //SW04
    Alignment(-0.12, 0.41), //SW05
    Alignment(-0.17, 0.33), //SW06
    Alignment(-0.23, 0.26), //SW07
    Alignment(-0.30, 0.19), //SW08
    Alignment(-0.39, 0.15), //SW09
    Alignment(-0.49, 0.12), //SW10
    Alignment(-0.58, 0.12), //SW11
    Alignment(-0.67, 0.13), //SW12
    Alignment(-0.76, 0.15), //SW13
    Alignment(-0.85, 0.19), //SW14
    Alignment(-0.84, 0.10), //SW15
    Alignment(-0.84, 0.00), //SW16
    Alignment(-0.84, -0.09), //SW17
    Alignment(0.10, -0.84), //NW17
    Alignment(0.01, -0.84), //NW16
    Alignment(-0.08, -0.84), //NW15
    Alignment(-0.175, -0.865), //NW14
    Alignment(-0.13, -0.78), //NW13
    Alignment(-0.10, -0.69), //NW12
    Alignment(-0.09, -0.59), //NW11
    Alignment(-0.10, -0.50), //NW10
    Alignment(-0.13, -0.40), //NW09
    Alignment(-0.17, -0.32), //NW08
    Alignment(-0.24, -0.24), //NW07
    Alignment(-0.30, -0.19), //NW06
    Alignment(-0.39, -0.14), //NW05
    Alignment(-0.49, -0.11), //NW04
    Alignment(-0.58, -0.10), //NW03
    Alignment(-0.67, -0.11), //NW02
    Alignment(-0.75, -0.14), //NW01
    Alignment(-0.85, -0.18), //NW00
    Alignment(-0.09, 0.865), //SE17
    Alignment(0.01, 0.865), //SE16
    Alignment(0.11, 0.865), //SE15
    Alignment(0.19, 0.865), //SE14
    Alignment(0.15, 0.78), //SE13
    Alignment(0.13, 0.69), //SE12
    Alignment(0.11, 0.59), //SE11
    Alignment(0.12, 0.50), //SE10
    Alignment(0.15, 0.41), //SE09
    Alignment(0.20, 0.33), //SE08
    Alignment(0.26, 0.26), //SE07
    Alignment(0.34, 0.19), //SE06
    Alignment(0.42, 0.15), //SE05
    Alignment(0.515, 0.12), //SE04
    Alignment(0.62, 0.12), //SE03
    Alignment(0.7, 0.12), //SE02
    Alignment(0.79, 0.15), //SE01
    Alignment(0.87, 0.19), //SE00
    Alignment(0.2, -0.86), //NE00
    Alignment(0.15, -0.78), //NE01
    Alignment(0.13, -0.69), //NE02
    Alignment(0.11, -0.59), //NE03
    Alignment(0.12, -0.50), //NE04
    Alignment(0.15, -0.41), //NE05
    Alignment(0.19, -0.32), //NE06
    Alignment(0.26, -0.24), //NE07
    Alignment(0.34, -0.17), //NE08
    Alignment(0.43, -0.13), //NE09
    Alignment(0.515, -0.11), //NE10
    Alignment(0.61, -0.10), //NE11
    Alignment(0.695, -0.11), //NE12
    Alignment(0.79, -0.13), //NE13
    Alignment(0.87, -0.17), //NE14
    Alignment(0.87, -0.09), //NE15
    Alignment(0.87, -0.0), //NE16
    Alignment(0.87, 0.09), //NE17
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
                    width: 13,
                    height: 13,
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
