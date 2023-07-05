import 'package:chess/controller/online_game_controller.dart';

import 'package:flutter/material.dart';

class WaitingForOnlinePlayerView extends StatefulWidget {
  const WaitingForOnlinePlayerView({super.key});

  @override
  State<WaitingForOnlinePlayerView> createState() =>
      _WaitingForOnlinePlayerViewState();
}

class _WaitingForOnlinePlayerViewState
    extends State<WaitingForOnlinePlayerView> {
  OnlineGameController onlineGameController = OnlineGameController();

  @override
  void initState() {
    super.initState();
    onlineGameController.init();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 116, 101, 77),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Center(
            child: IconButton(
                onPressed: () {
                  onlineGameController.createGame();
                },
                icon: const Icon(Icons.send)),
          ),

          // FutureBuilder(
          //     future: onlineGameController.getAvailableGames(),
          //     builder: (context, snapshot) {
          //       if (snapshot.hasData) {}
          //       if (snapshot.hasError) {}
          //       return const SizedBox();
          //     })
        ],
      ),
    );
  }
}
