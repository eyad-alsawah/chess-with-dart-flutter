import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:uuid/uuid.dart';

import '../model/messages.dart';

class UdpConnection {
  // used to detect duplicate messages
  String lastMessageCreationTime = '';

  final StreamController<UdpMessage> messagesStreamController =
      StreamController<UdpMessage>();

//------------------------------------------------------
  void sendBroadcastMessage({required UdpMessage message}) {
    RawDatagramSocket.bind(InternetAddress.anyIPv4, 12345)
        .then((RawDatagramSocket socket) {
      socket.broadcastEnabled = true;

      // Convert the UDP message to JSON
      Map<String, dynamic> messageMap = message.toJson();
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
          .toList(),
    );

    // Get the local machine's port
    int localPort = 12345;

    // Create a UDP socket
    RawDatagramSocket socket = await RawDatagramSocket.bind(
      InternetAddress.anyIPv4,
      localPort,
      reuseAddress: true,
      reusePort: true,
    );

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
            print('Duplicated message');
          } else {
            UdpMessage udpMessage = UdpMessage.fromJson(messageDecoded);
            // Emit the messageObject to the stream
            messagesStreamController.add(udpMessage);
          }
        }
      }
    });
  }
}
