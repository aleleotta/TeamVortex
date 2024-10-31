import 'package:cloud_firestore/cloud_firestore.dart';

class FirebaseFirestoreServices {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<String?> loginWithUsername(String username) async {
    QuerySnapshot<Map<String, dynamic>>? querySnapshot;
    try {
      querySnapshot = await _firestore.collection("users").where("username", isEqualTo: username).limit(1).get();
      if (querySnapshot.docs.isEmpty) {
        return null;
      } else {
        return querySnapshot.docs[0].data()["email"];
      }
    }
    catch (err) {
      return null;
    }
  }

  Future<int> registerCredentials(String email, String username, String firstName, String lastNames) async {
    int statusCode = 0;
    try {
      await _firestore.collection("users").add(<String, dynamic>{
        "email": email,
        "username": username,
        "firstName": firstName,
        "lastNames": lastNames
      });
    }
    catch (err) {
      statusCode = -1;
    }
    return statusCode;
  }

  Future<String> getUserReference(String username) async {
    QuerySnapshot<Map<String, dynamic>>? querySnapshot;
    try {
      querySnapshot = await _firestore.collection("users").where("username", isEqualTo: username).limit(1).get();
      if (querySnapshot.docs.isEmpty) {
        return "";
      } else {
        return querySnapshot.docs[0].id;
      }
    }
    catch (err) {
      return "";
    }
  }
}