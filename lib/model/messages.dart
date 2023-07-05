import 'package:chess/controller/online_game_controller.dart';

class UdpMessage {
  final MessageType type;
  final String uuid;
  final DateTime createdAt;

  UdpMessage({
    required this.type,
    required this.uuid,
    required this.createdAt,
  });

  factory UdpMessage.fromJson(Map<String, dynamic> json) {
    final MessageType type = MessageType.values.firstWhere(
      (type) => type.toString() == 'MessageType.${json['type']}',
    );

    switch (type) {
      case MessageType.chatMessage:
        return ChatMessage.fromJson(json);
      case MessageType.gameInitiationRequest:
        return GameInitiationRequest.fromJson(json);
      default:
        throw ArgumentError('Invalid message type');
    }
  }

  Map<String, dynamic> toJson() {
    return {
      'type': type.toString().split('.').last,
      'uuid': uuid,
      'createdAt': createdAt.toIso8601String(),
    };
  }
}

class GameInitiationRequest extends UdpMessage {
  final String text;

  GameInitiationRequest({
    required String uuid,
    required DateTime createdAt,
    required this.text,
  }) : super(
          type: MessageType.gameInitiationRequest,
          uuid: uuid,
          createdAt: createdAt,
        );

  factory GameInitiationRequest.fromJson(Map<String, dynamic> json) {
    return GameInitiationRequest(
      uuid: json['uuid'],
      createdAt: DateTime.parse(json['createdAt']),
      text: json['text'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = super.toJson();
    json['text'] = text;
    return json;
  }
}

class ChatMessage extends UdpMessage {
  final String imageUrl;

  ChatMessage({
    required String uuid,
    required DateTime createdAt,
    required this.imageUrl,
  }) : super(
          type: MessageType.chatMessage,
          uuid: uuid,
          createdAt: createdAt,
        );

  factory ChatMessage.fromJson(Map<String, dynamic> json) {
    return ChatMessage(
      uuid: json['uuid'],
      createdAt: DateTime.parse(json['createdAt']),
      imageUrl: json['imageUrl'],
    );
  }

  @override
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = super.toJson();
    json['imageUrl'] = imageUrl;
    return json;
  }
}
