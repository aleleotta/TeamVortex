// ignore_for_file: file_names
import 'dart:ffi';

class Account {
  //Attributes
  Long _id = 0 as Long;
  String _username = "";
  String _email = "";
  String _password = "";

  //Properties
  Long get id => _id;
  String get username => _username;
  String get email => _email;
  String get password => _password;

  //Constructor
  Account(Long id, String username, String email, String password) {
    _id = id;
    _username = username;
    _email = email;
    _password = password;
  }
}