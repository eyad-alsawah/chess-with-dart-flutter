import 'package:chess/controllers/online_controllers/abstract_online_game_controller.dart';
import 'package:chess/controllers/online_controllers/udp_controller/udp_connection.dart';

import 'package:chess/model/messages.dart';

import 'package:uuid/uuid.dart';
class UdpGameController implements AbstractOnlineGameController {
  UdpConnection udpConnection = UdpConnection();
  String uuid = const Uuid().v1();

  final OnNewGameAvailable onNewGameAvailable;

  UdpGameController({required this.onNewGameAvailable});

  @override
  void getAvailableGames() {
    udpConnection.sendBroadcastMessage(
        message: GetAvailableGames(
          uuid: uuid,
          createdAt: DateTime.now(),
        ));
  }

  @override
  void joinGame({required String uuid}) {
    // Implementation for joining a game
  }

  @override
  void announceAvailableGame() {
    udpConnection.sendBroadcastMessage(
        message: AnnounceAvailableGame(
          uuid: uuid,
          createdAt: DateTime.now(),
        ));
  }

  @override
  void move() {
    udpConnection.sendBroadcastMessage(
        message: GameInitiationRequest(
            uuid: uuid, createdAt: DateTime.now(), text: 'text'));
  }

  @override
  void init() {
    udpConnection.listenForMessages();
    mapMessageToFunction();
  }

  @override
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

enum MessageType {
  gameAnnounciation,
  getAvailableGames,
  gameInitiationRequest,
  chatMessage,
  move,
  unknown,
}

typedef OnNewGameAvailable = Function(String gameId);