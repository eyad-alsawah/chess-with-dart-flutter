//
// import 'package:flutter/material.dart';
// import 'package:flutter_webrtc/flutter_webrtc.dart';
//
// import 'package:logger/logger.dart';
// import 'package:meta/meta.dart';
// import 'package:uuid/uuid.dart';
//
// class PeerConnectionCubit {
//   PeerConnectionCubit({required this.onMessageReceived, required this.onConnectionDisconnected})
//       : super(PeerConnectionInitial());
//   FirebaseDataSource firebaseDataSource = FirebaseDataSource();
//   var logger = Logger(
//     printer: PrettyPrinter(),
//   );
//   late RTCPeerConnection peerConnection;
//   late RTCSessionDescription sdpOffer;
//   late String roomId;
//   RTCDataChannel? localDataChannel;
//   RTCDataChannel? remoteDataChannel;
//   void Function(String message) onMessageReceived;
//   void Function() onConnectionDisconnected;
//   static const Map<String, dynamic> _configuration = {
//     'iceServers': [
//       {
//         'urls': [
//           'stun:stun1.l.google.com:19302',
//           'stun:stun2.l.google.com:19302',
//         ],
//       },
//     ],
//   };
//
//   Future<void> joinRoom({
//     required String joinedRoomId,
//   }) async {
//     roomId = joinedRoomId;
//     //----------------------------------
//     await _createPeerConnection();
//     _registerPeerConnectionStateListeners();
//     //----------------
//     _registerDataChannelListener();
//     //--------------------------
//     await createDataChannel();
//     //-----------------
//     await trickleIceCandidates();
//     //------------------------------
//     RTCSessionDescription offer =
//     await firebaseDataSource.getOffer(roomId: joinedRoomId);
//     peerConnection.setRemoteDescription(offer);
//     //------------------------
//     RTCSessionDescription answer = await peerConnection.createAnswer();
//     await peerConnection.setLocalDescription(answer);
//     await firebaseDataSource.setAnswer(roomId: joinedRoomId, answer: answer);
//     //-----------------------------
//     await listenForRemoteIceCandidates(roomId: joinedRoomId);
//   }
//
//   Future<void> createRoom() async {
//     String testRoomID = const Uuid().v1().toString();
//     String createdRoomId = testRoomID;
//     roomId = createdRoomId;
//     //----------
//     await _createPeerConnection();
//     _registerPeerConnectionStateListeners();
//     //----------------
//     _registerDataChannelListener();
//     //-----------------------
//     await createDataChannel();
//     //-----------------
//     await trickleIceCandidates();
//     //--------------
//     RTCSessionDescription offer = await peerConnection.createOffer();
//     await peerConnection.setLocalDescription(offer);
//     //----------------
//     await firebaseDataSource.createRoom(offer: offer, roomId: testRoomID);
//
//     //---------------------------
//     //------------------------------
//     waitForAnswerThenSetRemoteDescription(roomId: createdRoomId);
//     await listenForRemoteIceCandidates(roomId: createdRoomId);
//   }
//
//   void deleteRoom({required String roomId}) {
//     firebaseDataSource.deleteRoom(roomId: roomId);
//   }
//
//   /// --------------------------------------------------------------------------
//   Future<void> _createPeerConnection() async {
//     peerConnection = await createPeerConnection(_configuration);
//     peerConnection.setConfiguration(_configuration);
//   }
//
//   /// -------------------------------------Ice Candidates ---------------------------------
//   Future<void> listenForRemoteIceCandidates({required String roomId}) async {
//     firebaseDataSource
//         .listenToRemoteIceCandidates(roomId: roomId)
//         .listen((candidates) {
//       if (candidates.isNotEmpty) {
//         for (var candidate in candidates) {
//           peerConnection.addCandidate(candidate);
//           logger.d('adding a remote candidate to peer connection');
//         }
//       } else {}
//     });
//   }
//
//   /// -----------------------------------Answer/Offer------------------------------------------
//   void waitForAnswerThenSetRemoteDescription({required String roomId}) {
//     firebaseDataSource
//         .listenForAnswer(roomId: roomId)
//         .stream
//         .listen((answer) async {
//       print("got an answer: ${answer.type}");
//       if (answer.type == 'answer') {
//         await peerConnection.setRemoteDescription(answer);
//       } else {}
//     });
//   }
//
//   // -------------------------------------Data Channels-------------------------------------
//   Future<void> createDataChannel() async {
//     final RTCDataChannelInit dataChannelDict = RTCDataChannelInit();
//     localDataChannel = peerConnection.createDataChannel('dataChannel', dataChannelDict);
//     localDataChannel!.onDataChannelState = (state) {
//       logger.w('data channel state: $state');
//
//     };
//     localDataChannel!.onMessage = (RTCDataChannelMessage message) {
//       logger.i('received a message: ${message.text}');
//       onMessageReceived(message.text);
//     };
//   }
//
//   void _registerDataChannelListener() {
//     peerConnection.onDataChannel = (RTCDataChannel channel) {
//       logger.e('onDataChannel was called');
//       remoteDataChannel = channel;
//       remoteDataChannel!.onDataChannelState = (state) {
//         logger.w('data channel state: $state');
//
//       };
//       remoteDataChannel!.onMessage = (RTCDataChannelMessage message) {
//         logger.i('received a message: ${message.text}');
//         onMessageReceived(message.text);
//       };
//     };
//   }
//
//   Future<void> trickleIceCandidates() async {
//     peerConnection.onIceCandidate = (event) async {
//       if (event.candidate != null) {
//         logger.i('received a candidate');
//         // trickling ice instead of sending them at once
//         await firebaseDataSource.addCandidateToRoom(
//             roomId: roomId, candidate: event);
//       } else {
//         logger.w('received a null candidate');
//       }
//     };
//   }
//
//   void _registerPeerConnectionStateListeners() {
//     peerConnection.onSignalingState = (state) {
//       logger.w('signaling state: $state');
//
//     };
//
//     peerConnection.onConnectionState = (state) {
//       logger.w('connection state: $state');
//
//     };
//
//     peerConnection.onIceConnectionState = (state) {
//       logger.w('ice connection state: $state');
//
//       if(state == RTCIceConnectionState.RTCIceConnectionStateDisconnected){
//         onConnectionDisconnected();
//       }
//     };
//
//     peerConnection.onIceGatheringState = (state) {
//       logger.w('ice gathering state: $state');
//
//       //-----------------
//     };
//
//     peerConnection.onRemoveStream = (stream) {
//       logger.w('stream with id: ${stream.id} was removed');
//     };
//   }
//
//   //-------------------------
//
//   void dispose() {
//     localDataChannel?.close();
//     remoteDataChannel?.close();
//     localDataChannel = null;
//     remoteDataChannel = null;
//     peerConnection.dispose();
//   }
// }
