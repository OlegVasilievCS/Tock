
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:socket_io_client/socket_io_client.dart' as socket_io;
import 'package:logger/logger.dart';

class HomePage extends StatefulWidget{
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();

}

class _HomePageState extends State<HomePage>{
  socket_io.Socket? socket;

  TextEditingController chatController = TextEditingController();

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
    socket?.on('disconnect', (_) => Logger().e('Disconnected'));
  }

  @override
  Widget build(BuildContext context) => Scaffold(
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
            }
          },
          child: const Text('Send to Server'),
        ),
      ],
    ),
  );


}