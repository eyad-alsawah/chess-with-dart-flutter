

import 'package:chess/controller/udp_controller.dart';
import 'package:chess/model/messages.dart';

import 'package:uuid/uuid.dart';

class OnlineGameController {
  UdpConnection udpConnection = UdpConnection();
  String uuid = const Uuid().v1();
  List<String> availableGames = [];
  //-------------------callbacks--------------
  final OnNewGameAvailable onNewGameAvailable;
  //----------------------------

  OnlineGameController({required this.onNewGameAvailable});

  /// ----------------------------------------------Joining a game--------------------------------
  void getAvailableGames() {
    udpConnection.sendBroadcastMessage(
        message: GetAvailableGames(
      uuid: uuid,
      createdAt: DateTime.now(),
    ));
  }

  void joinGame({required String uuid}) {}

  /// -----------------------------------------------Creating a game-------------------------------------------
  void announceAvailableGame() {
    udpConnection.sendBroadcastMessage(
        message: AnnounceAvailableGame(
      uuid: uuid,
      createdAt: DateTime.now(),
    ));
  }

  void move() {
    udpConnection.sendBroadcastMessage(
        message: GameInitiationRequest(
            uuid: uuid, createdAt: DateTime.now(), text: 'text'));
  }

  void init() {
    udpConnection.listenForMessages();
    mapMessageToFunction();
  }

  ///---------------------------------------------
  void mapMessageToFunction() {
    udpConnection.messagesStreamController.stream.listen((message) {
      switch (message.type) {
        case MessageType.gameAnnounciation:
          onNewGameAvailable(message.uuid);
          break;
        case MessageType.getAvailableGames:
          announceAvailableGame();
          break;
        default:
          throw UnimplementedError('unimplemented message type');
      }
    });
  }
}
//-----------------------------------------------

enum MessageType {
  gameAnnounciation,
  getAvailableGames,
  gameInitiationRequest,
  chatMessage,
  move,
  unknown,
}

//-----------------callbacks----------------------------
typedef OnNewGameAvailable = Function(String gameId);
