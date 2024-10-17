import 'package:firebase_auth/firebase_auth.dart';
import 'package:teamvortex/models/services/firebase_firestore_services.dart';
import 'package:flutter/material.dart';
import 'package:teamvortex/models/services/firebase_auth_services.dart';

class LoginRegisterViewModel extends ChangeNotifier {
  String _errorString = "";
  bool _passwordVisible = false;
  Icon _passwordIcon = const Icon(Icons.remove_red_eye_outlined);

  String get errorString => _errorString;
  bool get passwordVisible => _passwordVisible;
  Icon get passwordIcon => _passwordIcon;

  set errorString(String value) {
    _errorString = value;
    notifyListeners();
  }
  set passwordVisible(bool value) {
    _passwordVisible = value;
    _passwordIcon = !_passwordVisible ? const Icon(Icons.remove_red_eye_outlined) : const Icon(Icons.visibility_off_outlined);
    notifyListeners();
  }

  // This function will check if the account information is correct.
  Future<int> checkInfoLogin(String emailOrUsername, String password) async {
    int resultCode = 0; // 0 for success, -1 for failure
    bool isEmail = RegExp(r'^[a-z0-9.-]{3,}@[a-z0-9-]{2,}\.[a-z]{2,}$').hasMatch(emailOrUsername);
    bool isUsername = RegExp(r'^[a-zA-Z0-9]{4,20}$').hasMatch(emailOrUsername);
    if (emailOrUsername.isEmpty || password.isEmpty) {
      errorString = "All fields need to be filled in.";
      resultCode = -1;
    }
    else if (!isEmail && !isUsername) {
      errorString = "The email or username is not valid.";
      resultCode = -1;
    }
    // Authentication
    else if (isEmail) {
      User? user = await FirebaseAuthServices().signInWithEmailAndPassword(emailOrUsername, password);
      if (user == null) {
        errorString = "The email was not found.";
        resultCode = -1;
      } else {
        errorString = "";
      }
    }
    else if (isUsername) {
      String? receivedEmail = await FirebaseFirestoreServices().loginWithUsername(emailOrUsername);
      if (receivedEmail == null) {
        errorString = "The username was not found.";
        resultCode = -1;
      }
      else {
        User? user = await FirebaseAuthServices().signInWithEmailAndPassword(receivedEmail, password);
        if (user == null) {
          errorString = "An internal error has occured.";
          resultCode = -1;
        } 
      }
    }
    if (resultCode == 0) {
      errorString = "";
    }
    notifyListeners();
    return resultCode; // Gets returned to the UI to know whether to nagivate to the home menu or not.
  }

  // This function will check if the account information is correct.
  // If all data is valid, _registerAccountIntoFirebase() will be called.
  Future<int> checkInfoRegister(String firstName, String lastName, String email, String username, String password, String repeatPassword) async {
    int resultCode = 0;
    if (firstName.isEmpty || lastName.isEmpty || email.isEmpty || username.isEmpty || password.isEmpty || repeatPassword.isEmpty) {
      errorString = "All fields need to be filled in.";
      resultCode = -1;
    } else if (!RegExp(r'^[a-z0-9.-]{3,}@[a-z0-9-]{2,}\.[a-z]{2,}$').hasMatch(email)) {
      errorString = "The email is not valid.";
      resultCode = -1;
    } else if (!RegExp(r'^[a-zA-Z0-9]{4,20}$').hasMatch(username)) {
      errorString = "The username length should be between 4 and 20 characters.";
      resultCode = -1;
    } else if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{6,25}$').hasMatch(password)) {
      errorString = "The password must contain at least:\none uppercase letter,\none lowercase letter,\none number,\nand one special character.";
      resultCode = -1;
    } else if (password != repeatPassword) {
      errorString = "The passwords do not match.";
      resultCode = -1;
    } else {
      // Authentication
      User? user = await FirebaseAuthServices().signUpWithEmailAndPassword(email, password, username);
      if (user == null) {
        errorString = "An internal error has occured.";
        resultCode = -1;
      } else {
        resultCode = await FirebaseFirestoreServices().registerCredentials(email, username, firstName, lastName);
      }
    }
    if (resultCode == 0) {
      errorString = "";
    }
    notifyListeners();
    return resultCode;
  }
}