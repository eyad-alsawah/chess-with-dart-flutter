import 'package:chess/game_logic.dart';
import 'package:chess/image_assets.dart';
import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 141, 141, 141),
      body: Column(
        children: [
          Image.asset(blackCastle),
          const SizedBox(height: 400),
          Padding(
              padding: const EdgeInsets.all(20),
              child: drawBoard(playingAs: PlayingAs.white, size: 350)),
        ],
      ),
    );
  }
}
