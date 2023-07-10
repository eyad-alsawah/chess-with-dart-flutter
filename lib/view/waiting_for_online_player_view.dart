import 'package:chess/controllers/online_controllers/firebase_controller/firebase_data_source.dart';
import 'package:chess/controllers/online_controllers/udp_controller/udp_game_controller.dart';
import 'package:chess/view/game_view.dart';


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
  FirebaseDataSource firebaseDataSource = FirebaseDataSource();

  late UdpGameController onlineGameController;

  @override
  void initState() {
    super.initState();
    //
    // onlineGameController = UdpGameController(
    //   onNewGameAvailable: (gameId) {
    //     availableGames.clear();
    //     availableGames.add(gameId);
    //     setState(() {});
    //   },
    // );
    // onlineGameController.init();
    // onlineGameController.getAvailableGames();


  }

  Future<void> onRefresh() async {
    onlineGameController.getAvailableGames();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 143, 109, 51),
      ),
      backgroundColor: const Color.fromARGB(255, 168, 149, 117),
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
              StreamBuilder<List<String>>(
                stream: firebaseDataSource.getAvailableGamesStream(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    List<String> availableGames = snapshot.data ?? [];

                    return Expanded(
                      child: ListView.builder(
                        itemCount: availableGames.length,
                        itemBuilder: (context, index) {
                          return InkWell(
                            onTap: () {
                              firebaseDataSource.joinGame(gameId: availableGames[index]);
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) {
                                    return  GameView(
                                      playOnline: true,
                                      createdGameId: null,
                                      joinedGameId: availableGames[index],
                                    );
                                  },
                                ),
                              );
                            },
                            child: Center(
                              child: Text(availableGames[index]),
                            ),
                          );
                        },
                      ),
                    );
                  }
                },
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
                    onPressed: () async{
                      String createdGameId = DateTime.now().toString();
                  await  firebaseDataSource.createGame(createdGameId: createdGameId);
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) {
                            return  GameView(
                              playOnline: true,
                              joinedGameId: null,
                              createdGameId: createdGameId,
                            );
                          },
                        ),
                      );
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
