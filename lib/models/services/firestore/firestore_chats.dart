import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teamvortex/models/entities/ChatRoom.dart';

class FirestoreUserChats {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<List<ChatRoom>> getChats(String username) async {
    List<ChatRoom> chatRooms = [];
    QuerySnapshot<Map<String, dynamic>>? querySnapshot;
    try {
      querySnapshot = await _firestore
          .collection("chats")
          .where("users", arrayContains: username)
          .orderBy("timestamp")
          .get();
      for (var doc in querySnapshot.docs) {
        chatRooms.add(
          ChatRoom.fromMap(doc.data()),
        );
      }
    } catch (err) {
      return chatRooms = [];
    }
    return chatRooms;
  }
}