import 'dart:math';

import 'package:chess/game_logic.dart';

import 'package:flutter/material.dart';

import 'logic.dart';

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
  String squareName = "";
  List<String> movementHistory = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 141, 141, 141),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.all(20),
            child: ChessBoard(
                playingAs: PlayingAs.white,
                size: 330,
                onTap: (name) {
                  // setState(() {
                  //   movementHistory.add("$name, ");
                  //   squareName = name;
                  // });
                }),
          ),
          IconButton(
              onPressed: () {
                //emptying the chess board
                for (var element in chessBoard) {
                  element['piece'] = null;
                  element['type'] = null;
                }
                List<int> insertionIndex = List.generate(64, (index) => index);
                insertionIndex.shuffle();
                for (var newPiece in listToShuffleFrom) {
                  final random = Random();
                  int randomIndex = random.nextInt(insertionIndex.length);
                  insertionIndex.removeAt(randomIndex);
                  chessBoard[randomIndex]['piece'] = newPiece['piece'];
                  chessBoard[randomIndex]['type'] = newPiece['type'];
                }
                setState(() {});
              },
              icon: const Icon(Icons.shuffle)),
          Switch(
              value: getAllPieces,
              onChanged: (value) {
                getAllPieces = value;
                setState(() {});
              }),
          // const SizedBox(height: 20),
          // Padding(
          //   padding: const EdgeInsets.symmetric(horizontal: 30),
          //   child: SizedBox(
          //     height: 100,
          //     child: SingleChildScrollView(
          //       child: Text(
          //         movementHistory.join(),
          //         style: const TextStyle(
          //             fontSize: 10, fontWeight: FontWeight.bold),
          //       ),
          //     ),
          //   ),
          // ),
        ],
      ),
    );
  }
}

List<Map<String, dynamic>> listToShuffleFrom = [
  {
    "piece": PiecesT.rook,
    "type": PieceTypeT.light,
  },
  {"piece": PiecesT.knight, "type": PieceTypeT.light},
  {"piece": PiecesT.bishop, "type": PieceTypeT.light},
  {"piece": PiecesT.queen, "type": PieceTypeT.light},
  {"piece": PiecesT.king, "type": PieceTypeT.light},
  {"piece": PiecesT.bishop, "type": PieceTypeT.light},
  {"piece": PiecesT.knight, "type": PieceTypeT.light},
  {"piece": PiecesT.rook, "type": PieceTypeT.light},
  {"piece": PiecesT.pawn, "type": PieceTypeT.light},
  {"piece": PiecesT.pawn, "type": PieceTypeT.light},
  {"piece": PiecesT.pawn, "type": PieceTypeT.light},
  {"piece": PiecesT.pawn, "type": PieceTypeT.light},
  {"piece": PiecesT.pawn, "type": PieceTypeT.light},
  {"piece": PiecesT.pawn, "type": PieceTypeT.light},
  {"piece": PiecesT.pawn, "type": PieceTypeT.light},
  {"piece": PiecesT.pawn, "type": PieceTypeT.light},
  //-----------------------------------dark----------------------------------
  {"piece": PiecesT.pawn, "type": PieceTypeT.dark},
  {"piece": PiecesT.pawn, "type": PieceTypeT.dark},
  {"piece": PiecesT.pawn, "type": PieceTypeT.dark},
  {"piece": PiecesT.pawn, "type": PieceTypeT.dark},
  {"piece": PiecesT.pawn, "type": PieceTypeT.dark},
  {"piece": PiecesT.pawn, "type": PieceTypeT.dark},
  {"piece": PiecesT.pawn, "type": PieceTypeT.dark},
  {"piece": PiecesT.pawn, "type": PieceTypeT.dark},
  {"piece": PiecesT.rook, "type": PieceTypeT.dark},
  {"piece": PiecesT.knight, "type": PieceTypeT.dark},
  {"piece": PiecesT.bishop, "type": PieceTypeT.dark},
  {"piece": PiecesT.queen, "type": PieceTypeT.dark},
  {"piece": PiecesT.king, "type": PieceTypeT.dark},
  {"piece": PiecesT.bishop, "type": PieceTypeT.dark},
  {"piece": PiecesT.knight, "type": PieceTypeT.dark},
  {"piece": PiecesT.rook, "type": PieceTypeT.dark}
];
