import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teamvortex/models/entities/ChatRoom.dart';
import 'package:teamvortex/models/entities/Message.dart';

class FirestoreUserChats {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ///Creates a new ChatRoom in Firestore including two users as members.
  ///
  ///The purpose of a ChatRoom is to hold messages between two users.
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

  ///Returns a list of ChatRooms that the user is a member of.
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

  ///Uploads a new message to Firestore with the ChatRoom ID as the receiverID (FK).
  Future<int> sendMessage(Message message) async {
    int statusCode = 0;
    try {
      await _firestore.collection("private_messages").add(message.toMap());
    } catch (err) {
      statusCode = -1;
    }
    return statusCode;
  }

  ///Returns all messages of a ChatRoom from Firestore by using a stream and returning it.
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

  ///Deletes a ChatRoom from Firestore.
  Future<int> deleteChatRoom(String docId) async {
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

  ///Deletes all ChatRooms of a user from Firestore.
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