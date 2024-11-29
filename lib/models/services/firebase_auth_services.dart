import 'package:firebase_auth/firebase_auth.dart';
import 'package:teamvortex/models/services/firestore/firestore_auth.dart';
import 'package:teamvortex/models/services/firestore/firestore_chats.dart';

class FirebaseAuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  get instance => _auth;

  Future<User?> signUpWithEmailAndPassword(String email, String password, String username) async {
    try {
      UserCredential credentials = await _auth.createUserWithEmailAndPassword(email: email, password: password);
      User user = credentials.user!;
      user.updateDisplayName(username);
      return user;
    }
    catch (err) {
      return null;
    }
  }

  Future<User?> signInWithEmailAndPassword(String email, String password) async {
    try {
      UserCredential credentials = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User user = credentials.user!;
      return user;
    }
    catch (err) {
      return null;
    }
  }

  Future<int> signOut() async {
    int resultCode = 0;
    try {
      await _auth.signOut();
    }
    catch (err) {
      resultCode = -1;
    }
    return resultCode;
  }

  Future<int> deleteAccount() async {
    int resultCode = 0;
    try {
      //Delete all related data before deleting account
      FirestoreUserChats().deleteAllChatRoomsFromUser(FirebaseAuth.instance.currentUser!.displayName!);
      FirestoreAuth().deleteUser(FirebaseAuth.instance.currentUser!.email!);
      await _auth.currentUser?.delete();
    }
    catch (err) {
      resultCode = -1;
    }
    return resultCode;
  }

  Future<String?> getCurrentUsername() async => _auth.currentUser?.displayName;
}