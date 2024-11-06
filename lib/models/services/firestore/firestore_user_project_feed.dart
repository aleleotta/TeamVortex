import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teamvortex/models/entities/Message.dart';

class FirestoreProjectFeed {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<int> sendMessage(Message message) async {
    int statusCode = 0;
    try {
      await _firestore.collection("feed_messages").add(message.toMap());
    } catch (err) {
      statusCode = -1;
    }
    return statusCode;
  }

  Stream<QuerySnapshot> getMessages(String projectId) {
    try {
      return _firestore
        .collection("feed_messages")
        .where("receiverId", isEqualTo: projectId)
        .orderBy("timestamp")
        .snapshots();
    }
    catch (err) {
      return const Stream.empty();
    }
  }
}