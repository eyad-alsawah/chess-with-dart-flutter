import 'dart:async';

import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseDataSource{
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  static const String _gamesCollection = 'games';
  // -----------------------fields----------------------
  static const String _activeField = 'active';
  static const String _movesField = 'moves';
  static const String _occupiedField = 'occupied';
  // -----------------------------------------------

  Future<void> joinGame({required String gameId}) async {
    final gameRef = _db.collection(_gamesCollection).doc(gameId);

    await gameRef.update({_occupiedField:true});
  }


  Future<void> createGame({required String createdGameId})async{
    final gameRef = _db.collection(_gamesCollection).doc(createdGameId);
    Map<String, dynamic> data = {
      _activeField: true,
      _occupiedField: false,
    };
    await gameRef.set(data);
  }
  Stream<List<String>> getAvailableGamesStream() {
    CollectionReference gamesRef = _db.collection(_gamesCollection);

    return gamesRef
        .where(_activeField, isEqualTo: true)
        .where(_occupiedField, isEqualTo: false)
        .snapshots()
        .map((snapshot) => snapshot.docs.map((doc) => doc.id).toList());
  }

  StreamController<bool> waitForPlayerToJoin({required String roomId})  {

    final streamController = StreamController<bool>();
    _db.collection(_gamesCollection).doc(roomId).snapshots().listen((docSnapShot) {
      Map<String,dynamic> data =docSnapShot.data() ?? {};
      if(data[_occupiedField]){
        streamController.add(true);
      }

    });
    return streamController;
  }
}