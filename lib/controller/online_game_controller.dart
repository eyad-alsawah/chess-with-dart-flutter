import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:chess/controller/udp_controller.dart';
import 'package:chess/model/messages.dart';

import 'package:uuid/uuid.dart';

class OnlineGameController {
  UdpConnection udpConnection = UdpConnection();
  String uuid = const Uuid().v1();

  Future<void> createGame() async {
    udpConnection.sendBroadcastMessage(
        message: GameInitiationRequest(
            uuid: uuid, createdAt: DateTime.now(), text: 'text'));
  }

  Future<void> move() async {
    udpConnection.sendBroadcastMessage(
        message: GameInitiationRequest(
            uuid: uuid, createdAt: DateTime.now(), text: 'text'));
  }

  Future<void> init() async {
    udpConnection.listenForMessages();
  }
}

String messageTypeToString({required MessageType type}) {
  late String typeString;
  switch (type) {
    case MessageType.gameInitiationRequest:
      typeString = 'initiation_request';
      break;
    case MessageType.chatMessage:
      typeString = 'chat_message';
      break;
    case MessageType.unknown:
      typeString = 'unknown';
      break;
    default:
      typeString = 'unknown';
  }
  return typeString;
}

enum MessageType {
  gameInitiationRequest,
  chatMessage,
  move,
  unknown,
}
