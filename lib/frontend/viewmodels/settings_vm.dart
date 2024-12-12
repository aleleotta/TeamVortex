import 'package:flutter/material.dart';
import 'package:teamvortex/backend/models/services/firebase_auth_services.dart';

class SettingsViewModel extends ChangeNotifier {
  String errorMessage = "";

  /// Sets the error message in the Delete Account dialog.
  void setError(String errorString) {
    errorMessage = errorString;
    notifyListeners();
  }

  /// Deletes the account.
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