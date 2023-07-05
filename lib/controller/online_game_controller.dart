import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:chess/model/messages.dart';
import 'package:chess/model/online_game_description.dart';
import 'package:uuid/uuid.dart';

class OnlineGameController {
  // used to detect duplicate messages
  String lastMessageCreationTime = '';
  String uuid = const Uuid().v1();
  String availableGamesCheckMessage = 'who is online?';
  // Future<List<OnlineGameDescription>> getAvailableGames() async {
  //   sendBroadCastMessage(message: availableGamesCheckMessage);
  // }
  final StreamController<UdpMessage> messagesStreamController =
      StreamController<UdpMessage>();

  Future<void> createGame() async {}

  //------------------------------------------------------
  void sendBroadcastMessage({String? message, required MessageType type}) {
    RawDatagramSocket.bind(InternetAddress.anyIPv4, 12345)
        .then((RawDatagramSocket socket) {
      socket.broadcastEnabled = true;

      UdpMessage udpMessage = UdpMessage(
        type: type,
        uuid: uuid,
        createdAt: DateTime.now(),
      );

      // Convert the UDP message to JSON
      Map<String, dynamic> messageMap = udpMessage.toJson();
      String messageMapStringified = json.encode(messageMap);

      // Convert the message to bytes
      List<int> messageBytes = utf8.encode(messageMapStringified);

      // Set the broadcast address and port
      InternetAddress broadcastAddress = InternetAddress('255.255.255.255');
      int port = 12345;

      // Send the broadcast message
      socket.send(messageBytes, broadcastAddress, port);
      socket.close();
    });
  }

  Future<void> listenForMessages() async {
    // Get the local machine's IP addresses
    List<InternetAddress> localAddresses = await NetworkInterface.list().then(
        (interfaces) => interfaces
            .where((interface) => interface.name == 'wlan0')
            .expand((interface) => interface.addresses)
            .toList());

    // Get the local machine's port
    int localPort = 12345;

    // Create a UDP socket
    RawDatagramSocket.bind(InternetAddress.anyIPv4, localPort)
        .then((RawDatagramSocket socket) {
      // Enable broadcast option
      socket.broadcastEnabled = true;

      // Listen for broadcast messages
      socket.listen((RawSocketEvent event) {
        if (event == RawSocketEvent.read) {
          Datagram? datagram = socket.receive();
          if (datagram != null) {
            // Check if the datagram is from the local machine
            bool isLocalAddress = localAddresses.contains(datagram.address);
            // Process the received broadcast message
            String message = String.fromCharCodes(datagram.data);
            Map<String, dynamic> messageDecoded = json.decode(message);
            String currentMessageCreationTime = messageDecoded['created_at'];
            bool isMessageDuplicated =
                lastMessageCreationTime == currentMessageCreationTime;
            lastMessageCreationTime = messageDecoded['created_at'];

            if (isLocalAddress) {
              print('Received message from self. Skipping...');
              return; // Skip processing the message
            } else if (isMessageDuplicated) {
              print('duplicated message');
            } else {
              UdpMessage udpMessage = UdpMessage.fromJson(messageDecoded);
              // Emit the messageObject to the stream
              messagesStreamController.add(udpMessage);
            }
          }
        }
      });
    });

    // messagesStreamController.stream.listen(
    //   (udpMessage) {
    //     // Handle the received message object

    //     if (udpMessage is GameInitiationRequest) {
    //       print('received game initiation request from ${messageObject.uuid}');
    //     }
    //     if (udpMessage is ChatMessage) {
    //       print('received chat message from ${messageObject.uuid}');
    //     }
    //     // Perform any additional processing or actions here
    //   },
    //   onError: (error) {
    //     // Handle any stream errors
    //     print('Error: $error');
    //   },
    //   onDone: () {
    //     // Handle when the stream is done (closed)
    //     print('Stream closed');
    //   },
    // );
  }

  // Object messageToObject(
  //     {required MessageType type, required Map<String, dynamic> message}) {
  //   Object object = 'unknown';

  //   switch (type) {
  //     case MessageType.gameInitiationRequest:
  //       object = GameInitiationRequest(uuid: message['uuid']);
  //       break;
  //     case MessageType.chatMessage:
  //       object = ChatMessage(uuid: message['uuid']);
  //       break;
  //     case MessageType.unknown:
  //       object = ChatMessage(uuid: message['uuid']);
  //       break;

  //     default:
  //   }
  //   return object;
  // }

  // MessageType messageTypeToEnum({required String messageType}) {
  //   late MessageType type;

  //   switch (messageType) {
  //     case 'initiation_request':
  //       type = MessageType.gameInitiationRequest;
  //       break;
  //     case 'chat_message':
  //       type = MessageType.chatMessage;
  //       break;
  //     default:
  //       type = MessageType.unknown;
  //   }
  //   return type;
  // }
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
