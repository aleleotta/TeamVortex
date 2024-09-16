// ignore_for_file: file_names
import 'dart:ffi';

class Account {
  Long _id = 0 as Long;
  String _username = "";
  String _email = "";
  String _password = "";

  Long get id => _id;
  String get username => _username;
  String get email => _email;
  String get password => _password;

  Account(Long id, String username, String email, String password) {
    _id = id;
    _username = username;
    _email = email;
    _password = password;
  }
}