import 'package:cloud_firestore/cloud_firestore.dart';

class FirestoreAuth {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ///Returns the email of the user with the given username.
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

  ///Registers a new user into Firestore while also registering in Firabase Auth.
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

  ///Deletes the user with the given email from Firestore.
  Future<int> deleteUser(String email) async {
    int statusCode = 0;
    try {
      await _firestore.collection("users").where("email", isEqualTo: email).get()
      .then(
        (querySnapshot) {
          for (var doc in querySnapshot.docs) {
            _firestore.collection("users").doc(doc.reference.id).delete();
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