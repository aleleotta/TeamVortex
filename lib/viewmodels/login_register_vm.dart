import 'package:flutter/material.dart';
import 'package:teamvortex/models/entities/Account.dart';

class LoginRegisterViewModel extends ChangeNotifier {
  String username = "";
  String password = "";
  String email = "";
  String confirmPassword = "";
  String errorString = "";
}