import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teamvortex/models/entities/ChatRoom.dart';

class FirestoreUserChats {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<int> addChatRoom(ChatRoom chatRoom) async {
    int statusCode = 0;
    try {
      bool userExists = false;
      await _firestore.collection("users").where("username", isEqualTo: chatRoom.members[1]).limit(1).get()
      .then((querySnapshot) {
        userExists = querySnapshot.docs.isNotEmpty;
      });
      if (!userExists) {
        statusCode = -2;
      }
      await _firestore.collection("chat_rooms")
        .where("members", arrayContains: chatRoom.members[1])
        .get()
        .then((querySnapshot) {
          for (var doc in querySnapshot.docs) {
            if (doc.data()["members"].contains(chatRoom.members[0])) {
              statusCode = -3;
            }
          }
        }
      );
      if (statusCode == 0) {
        await _firestore.collection("chat_rooms").add(chatRoom.toMap());
      }
    } catch (err) {
      statusCode = -1;
    }
    return statusCode;
  }

  Future<List<ChatRoom>> getChatRooms(String username) async {
    List<ChatRoom> chatRooms = [];
    QuerySnapshot<Map<String, dynamic>>? querySnapshot;
    try {
      querySnapshot = await _firestore
          .collection("chat_rooms")
          .where("members", arrayContains: username)
          .orderBy("creationDate")
          .get();
      for (var doc in querySnapshot.docs) {
        chatRooms.add(
          ChatRoom.fromMap(doc.data(), doc.id),
        );
      }
    } catch (err) {
      return chatRooms = [];
    }
    return chatRooms;
  }

  Future<int> deleteChatRoom(String docId) async { //Will be implemented later.
    int statusCode = 0;
    try {
      
    }
    catch (err) {
      statusCode = -1;
    }
    return statusCode;
  }
}