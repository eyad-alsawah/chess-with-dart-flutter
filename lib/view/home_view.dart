import 'package:chess/view/game_view.dart';
import 'package:chess/view/waiting_for_online_player_view.dart';
import 'package:flutter/material.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFFB58863),
        title: const Text(
          'Choose Game Type',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      backgroundColor: const Color.fromARGB(255, 116, 101, 77),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                  Color(0xFFF0D9B5),
                )),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const GameView(createdGameId: null,
                       joinedGameId: null,
                      playOnline: false,
                    );
                  }));
                },
                child: const Center(
                  child: Text(
                    'Play On Same Device',
                    style: TextStyle(color: Colors.black),
                  ),
                )),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: ElevatedButton(
                style: const ButtonStyle(
                    backgroundColor: MaterialStatePropertyAll(
                  Color(0xFFB58863),
                )),
                onPressed: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return const WaitingForOnlinePlayerView();
                  }));
                },
                child: const Center(
                  child: Text('Play Online'),
                )),
          ),
        ],
      ),
    );
  }
}
