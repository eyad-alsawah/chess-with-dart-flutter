import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter_webrtc/flutter_webrtc.dart';

class FirebaseSignaling {

  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String _roomsCollection = 'rooms';
  static const String _candidatesCollection = 'candidates';
  static const String _candidateUidField = 'uid';

  // Current user id, used to identify candidates in Firestore collection
  // You can get it from FirebaseAuth or just generate a random string, it is used just
  // to understand if a candidate belongs to another user or not
  static String userId = DateTime.now().toString();


  /// --------------------------------------------Rooms Management-------------------------------
  Future<void> createRoom({required RTCSessionDescription offer, required String roomId}) async {
    final roomRef = _db.collection(_roomsCollection).doc(roomId);
    final roomWithOffer = <String, dynamic>{'offer': offer.toMap()};

    await roomRef.set(roomWithOffer);

  }

  Future<void> deleteRoom({required String roomId})async{
    await _db.collection(_roomsCollection).doc(roomId).delete();
  }
  ///---------------------------------------------Candidates Exchanging---------------------------

  Future<void> addCandidateToRoom({
    required String roomId,
    required RTCIceCandidate candidate,
  }) async {
    final roomRef = _db.collection(_roomsCollection).doc(roomId);
    final candidatesCollection = roomRef.collection(_candidatesCollection);
    await candidatesCollection
        .add(candidate.toMap()..[_candidateUidField] = userId);
  }

  Stream<RTCSessionDescription?> getRoomDataStream({required String roomId}) {
    final snapshots = _db.collection(_roomsCollection).doc(roomId).snapshots();
    final filteredStream = snapshots.map((snapshot) => snapshot.data());
    return filteredStream.map(
          (data) {
        if (data != null && data['answer'] != null) {
          return RTCSessionDescription(
            data['answer']['sdp'],
            data['answer']['type'],
          );
        } else {
          return null;
        }
      },
    );
  }


  Future<List<String>> getAvailableRoomsIDs() async {
    QuerySnapshot querySnapshot = await _db.collection(_roomsCollection).get();
    final List<Object?> snapshotData =
    querySnapshot.docs.map((doc) => doc.id).toList();
    List<String> roomsIDs = [];

    for (var data in snapshotData) {
      if (data is String) {
        print(data);
        roomsIDs.add(data);
      }
    }
    return Future.value(roomsIDs);
  }
  /// -------------------------------Offer/Answer-------------------------------------------
  Future<RTCSessionDescription> getOffer({required String roomId}) async {
    late RTCSessionDescription offer;
    await _db.collection(_roomsCollection).doc(roomId).get().then((data) {
      offer = RTCSessionDescription(data.get('offer')['sdp'],data.get('offer')['type']);
    });
    return Future.value(offer);
  }

  StreamController<RTCSessionDescription> listenForAnswer({required String roomId})  {

    final streamController = StreamController<RTCSessionDescription>();
    _db.collection(_roomsCollection).doc(roomId).snapshots().listen((docSnapShot) {
      Map<String,dynamic> data =docSnapShot.data() ?? {};
      if(data.containsKey('answer')){
        RTCSessionDescription answer = RTCSessionDescription(data['answer']['sdp'],data['answer']['type']);
        streamController.add(answer);
      }

    });
    return streamController;
  }




  Future<RTCSessionDescription?> getRoomOfferIfExists(
      {required String roomId}) async {
    final roomDoc = await _db.collection(_roomsCollection).doc(roomId).get();
    if (!roomDoc.exists) {
      return null;
    } else {
      final data = roomDoc.data() as Map<String, dynamic>;
      final offer = data['offer'];
      return RTCSessionDescription(offer['sdp'], offer['type']);
    }
  }


  Future<List<RTCSessionDescription>> getAvailableOffers() async {
    QuerySnapshot querySnapshot = await _db.collection(_roomsCollection).get();
    final List<Object?> snapshotData =
    querySnapshot.docs.map((doc) => doc.data()).toList();
    List<RTCSessionDescription> rooms = [];

    for (var data in snapshotData) {
      if (data is Map<String, dynamic>) {
        print(data['offer']['sdp']);
        String sdp = data['offer']['sdp'] ?? '';
        String type = data['offer']['type'] ?? '';

        RTCSessionDescription description = RTCSessionDescription(sdp, type);
        rooms.add(description);
      }
    }

    return rooms;
  }

  Future<void> setAnswer({
    required String roomId,
    required RTCSessionDescription answer,
  }) async {
    final roomRef = _db.collection(_roomsCollection).doc(roomId);
    final answerMap = <String, dynamic>{
      'answer': {'type': answer.type, 'sdp': answer.sdp}
    };
    await roomRef.update(answerMap);
  }
  /// --------------------------------------------------Ice Candidates-----------------------------

  Stream<List<RTCIceCandidate>> listenToRemoteIceCandidates({required String roomId}){
    final snapshots = _db
        .collection(_roomsCollection)
        .doc(roomId)
        .collection(_candidatesCollection).where(_candidateUidField, isNotEqualTo: userId)
        .snapshots();
    final streamController = StreamController<List<RTCIceCandidate>>();


    snapshots.listen((snapshot) {
      print("ice candidates where added");
      final docChangesList =  snapshot.docChanges
          .where((change) => change.type == DocumentChangeType.added);


      final List<RTCIceCandidate> candidatesList = docChangesList.map((change) {
        final data = change.doc.data() as Map<String, dynamic>;
        return RTCIceCandidate(
          data['candidate'],
          data['sdpMid'],
          data['sdpMLineIndex'],
        );
      }).toList();
      streamController.add(candidatesList);
    }
    );



    return streamController.stream;
  }

  Future<List<RTCIceCandidate>> getRemoteIceCandidates({required String roomId})async{
    QuerySnapshot querySnapshot = await _db.collection(_roomsCollection).doc(roomId)
        .collection(_candidatesCollection).get();

    final List<Object?> snapshotData =
    querySnapshot.docs.map((doc) => doc.data()).toList();
    List<RTCIceCandidate> candidates = [];

    for (var data in snapshotData) {
      if (data is Map<String, dynamic>) {
        print(data['candidate']['sdp']);
        String candidate = data['offer']['sdp'] ?? '';
        String sdpMid = data['offer']['type'] ?? '';
        int sdpMLineIndex = data[''];
        RTCIceCandidate rtcCandidate = RTCIceCandidate(candidate,sdpMid,sdpMLineIndex );
        candidates.add(rtcCandidate);
      }
    }

    return Future.value(candidates);
  }
  Future<void> clearRemoteCandidates({required String roomId })async{
    QuerySnapshot snapshot =  await _db
        .collection(_roomsCollection)
        .doc(roomId)
        .collection(_candidatesCollection).where(_candidateUidField, isNotEqualTo: userId).get();
    for (DocumentSnapshot ds in snapshot.docs){
      await ds.reference.delete();
    }

  }
  Stream<List<RTCIceCandidate>> getCandidatesAddedToRoomStream({
    required String roomId,
    required bool listenCaller,
  }) {
    final snapshots = _db
        .collection(_roomsCollection)
        .doc(roomId)
        .collection(_candidatesCollection)
        .where(_candidateUidField, isNotEqualTo: userId)
        .snapshots();

    final convertedStream = snapshots.map(
          (snapshot) {
        final docChangesList = listenCaller
            ? snapshot.docChanges
            : snapshot.docChanges
            .where((change) => change.type == DocumentChangeType.added);
        return docChangesList.map((change) {
          final data = change.doc.data() as Map<String, dynamic>;
          return RTCIceCandidate(
            data['candidate'],
            data['sdpMid'],
            data['sdpMLineIndex'],
          );
        }).toList();
      },
    );

    return convertedStream;
  }





}
