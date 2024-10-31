// ignore_for_file: file_names

import 'package:firebase_auth/firebase_auth.dart';

class Account {
  //Attributes
  String _firstName = "";
  String _lastNames = "";
  User? _user;

  //Properties
  String get firstName => _firstName;
  String get lastNames => _lastNames;
  User? get user => _user;

  //Constructors
  Account();

  Account.defineAttributesWithNames(String firstName, String lastNames, User? user) {
    _user = user;
    _firstName = firstName;
    _lastNames = lastNames;
  }

  Account.defineUserOnly(User? user) {
    _user = user;
  }

  Account.copyAttributes(Account account) {
    _user = account.user;
    _firstName = account.firstName;
    _lastNames = account.lastNames;
  }
}