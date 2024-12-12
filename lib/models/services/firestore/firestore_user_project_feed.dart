import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teamvortex/models/entities/Message.dart';

class FirestoreProjectFeed {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ///Uploads a new message to Firestore.
  Future<int> sendMessage(Message message) async {
    int statusCode = 0;
    try {
      await _firestore.collection("feed_messages").add(message.toMap());
    } catch (err) {
      statusCode = -1;
    }
    return statusCode;
  }

  ///Gets all messages of a project from Firestore by using a stream and returning it.
  ///
  ///New messages are returned in real time everytime the stream updates.
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