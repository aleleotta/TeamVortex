import 'package:flutter/material.dart';
import 'package:teamvortex/models/entities/Account.dart';

class LoginRegisterViewModel extends ChangeNotifier {
  late Account account;
  String username = "";
  String password = "";
  String email = "";
  String confirmPassword = "";
  String errorString = "";

  // This function will check if the account information is correct.
  // If it returns true then it proceeds to register the account into Firebase.
  bool checkInfo() {
    return false;
  }

  // It will be called into checkInfo() once the information has been validated to call Firebase and register the account information.
  void _registerAccountIntoFirebase() {}
}