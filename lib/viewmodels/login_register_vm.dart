import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:teamvortex/models/entities/Account.dart';

import '../models/services/firebase_auth_services.dart';

class LoginRegisterViewModel extends ChangeNotifier {
  late Account _account;
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
  void checkInfoLogin(String emailOrUsername, String password) {}

  // This function will check if the account information is correct.
  // If all data is valid, _registerAccountIntoFirebase() will be called.
  void checkInfoRegister(BuildContext context, String firstName, String lastName, String email, String username, String password, String repeatPassword) {
    if (firstName.isEmpty || lastName.isEmpty || email.isEmpty || username.isEmpty || password.isEmpty || repeatPassword.isEmpty) {
      errorString = "All fields need to be filled in.";
    } else if (!RegExp(r'^[a-z0-9.-]{3,}@[a-z0-9-]{2,}\.[a-z]{2,}$').hasMatch(email)) {
      errorString = "The email is not valid.";
    } else if (!RegExp(r'^[a-zA-Z0-9]{4,20}$').hasMatch(username)) {
      errorString = "The username length should be between 4 and 20 characters.";
    } else if (!RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@$!%*?&])[A-Za-z\d@$!%*?&]{6,20}$').hasMatch(password)) {
      errorString = "The password must contain at least:\none uppercase letter,\none lowercase letter,\none number,\nand one special character.";
    } else if (password != repeatPassword) {
      errorString = "The passwords do not match.";
    } else {
      errorString = "";
      _account = Account.defineAttributesWithNames(firstName, lastName, email, username, password);
      // Authentication begins.
      FirebaseAuthServices().signUpWithEmailAndPassword(email, password, username);
      Navigator.pushNamed(context, '/homeView');
    }
    notifyListeners();
  }
}