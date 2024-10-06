import 'package:firebase_auth/firebase_auth.dart';

class FirebaseAuthServices {
  final FirebaseAuth _auth = FirebaseAuth.instance;

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
}