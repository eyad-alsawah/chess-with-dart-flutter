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
  List<String> availableGames = [];

  late OnlineGameController onlineGameController;

  @override
  void initState() {
    super.initState();

    onlineGameController = OnlineGameController(
      onNewGameAvailable: (gameId) {
        availableGames.clear();
        availableGames.add(gameId);
        setState(() {});
      },
    );
    onlineGameController.init();
    onlineGameController.getAvailableGames();
  }

  Future<void> onRefresh() async {
    onlineGameController.getAvailableGames();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color.fromARGB(255, 143, 109, 51),
      ),
      backgroundColor: Color.fromARGB(255, 168, 149, 117),
      body: RefreshIndicator(
        onRefresh: onRefresh,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(
                height: 30,
              ),
              const Text('Available Games:',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Visibility(
                visible: availableGames.isNotEmpty,
                replacement: const Padding(
                  padding: EdgeInsets.symmetric(vertical: 30),
                  child: Center(
                    child: Text('No Games Available...'),
                  ),
                ),
                child: Expanded(
                  child: ListView.builder(
                      itemCount: availableGames.length,
                      itemBuilder: (context, index) {
                        return InkWell(
                          onTap: () {
                            onlineGameController.joinGame(
                                uuid: availableGames[index]);
                          },
                          child: Center(
                            child: Text(availableGames[index]),
                          ),
                        );
                      }),
                ),
              ),
              const Divider(thickness: 5),
              const SizedBox(
                height: 30,
              ),
              const Text('Create a game',
                  style: TextStyle(fontWeight: FontWeight.bold)),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: ElevatedButton(
                    style: const ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(
                      Color(0xFFB58863),
                    )),
                    onPressed: () {
                      onlineGameController.announceAvailableGame();
                      // Navigator.push(
                      //   context,
                      //   MaterialPageRoute(
                      //     builder: (context) {
                      //       return const GameView(
                      //         playOnline: true,
                      //       );
                      //     },
                      //   ),
                      // );
                    },
                    child: const Center(
                      child: Text('Create a game'),
                    )),
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
        ),
      ),
    );
  }
}
