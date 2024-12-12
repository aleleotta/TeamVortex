import 'package:flutter/material.dart';
import 'package:teamvortex/models/services/firebase_auth_services.dart';

class SettingsViewModel extends ChangeNotifier {
  String errorMessage = "";

  void setError(String errorString) {
    errorMessage = errorString;
    notifyListeners();
  }

  Future<int> deleteAccount() async {
    int statusCode = 0;
    try {
      statusCode = await FirebaseAuthServices().deleteAccount();
    } catch (err) {
      statusCode = -1;
    }
    return statusCode;
  }
}