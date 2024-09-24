// ignore_for_file: file_names

class Account {
  //Attributes
  String _username = "";
  String _email = "";
  String _password = "";

  //Properties
  String get username => _username;
  String get email => _email;
  String get password => _password;

  //Constructor
  Account(String email, String username, String password) {
    _email = email;
    _username = username;
    _password = password;
  }
}