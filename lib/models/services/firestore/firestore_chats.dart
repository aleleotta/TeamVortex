import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teamvortex/models/entities/ChatRoom.dart';
import 'package:teamvortex/models/entities/Message.dart';

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

  Future<int> sendMessage(Message message) async {
    int statusCode = 0;
    try {
      await _firestore.collection("private_messages").add(message.toMap());
    } catch (err) {
      statusCode = -1;
    }
    return statusCode;
  }

  Stream<QuerySnapshot> getMessages(String chatRoomId) {
    try {
      return _firestore
        .collection("private_messages")
        .where("receiverId", isEqualTo: chatRoomId)
        .orderBy("timestamp")
        .snapshots();
    }
    catch (err) {
      return const Stream.empty();
    }
  }

  Future<int> deleteChatRoom(String docId) async { //Will be implemented later.
    int statusCode = 0;
    try {
      _firestore.collection("chat_rooms").doc(docId).delete();
      _firestore.collection("private_messages").where("receiverId", isEqualTo: docId).get()
      .then(
        (querySnapshot) {
          for (var doc in querySnapshot.docs) {
            _firestore.collection("private_messages").doc(doc.reference.id).delete();
          }
        }
      );
    }
    catch (err) {
      statusCode = -1;
    }
    return statusCode;
  }

  Future<int> deleteAllChatRoomsFromUser(String username) async {
    int statusCode = 0;
    try {
      await _firestore.collection("chat_rooms").where("members", arrayContains: username).get()
      .then(
        (querySnapshot) {
          for (var doc in querySnapshot.docs) {
            _firestore.collection("chat_rooms").doc(doc.reference.id).delete();
          }
        }
      );
      await _firestore.collection("private_messages").where("receiverId", isEqualTo: username).get()
      .then(
        (querySnapshot) {
          for (var doc in querySnapshot.docs) {
            _firestore.collection("private_messages").doc(doc.reference.id).delete();
          }
        }
      );
    }
    catch (err) {
      statusCode = -1;
    }
    return statusCode;
  }
}