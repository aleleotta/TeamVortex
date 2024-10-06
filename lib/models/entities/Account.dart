// ignore_for_file: file_names

class Account {
  //Attributes
  String _firstName = "";
  String _lastNames = "";
  String _username = "";
  String _email = "";
  String _password = "";

  //Properties
  String get firstName => _firstName;
  String get lastNames => _lastNames;
  String get username => _username;
  String get email => _email;
  String get password => _password;

  //Constructors
  Account();

  Account.defineAttributesWithNames(String firstName, String lastNames, String email, String username, String password) {
    _firstName = firstName;
    _lastNames = lastNames;
    _email = email;
    _username = username;
    _password = password;
  }

  Account.defineAttributes(String email, String username, String password) {
    _email = email;
    _username = username;
    _password = password;
  }

  Account.copyAttributes(Account account) {
    _email = account.email;
    _username = account.username;
    _password = account.password;
  }
}