import 'package:chess/controller/enums.dart';
import 'package:chess/view/game_view.dart';
import 'package:flutter/material.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
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
  String squareName = "";
  List<String> movementHistory = [];
  String currentPlayingTurn = "White's Turn";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Color.fromARGB(255, 38, 37, 33),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          ChessBoard(
            playingAs: PlayingAs.white,
            size: 375,
            onTap: (name) {},
            onPlayingTurnChanged: (playingTurn) {
              currentPlayingTurn = playingTurn == PlayingTurn.white
                  ? "White's Turn"
                  : "Black's Turn";
              setState(() {});
            },
          ),
          Center(
            child: Text(
              currentPlayingTurn,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
