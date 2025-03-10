// ignore_for_file: file_names, unnecessary_getters_setters

class Project {
  // Attributes
  String _docId = "";
  String _title = "";
  String _description = "";
  String _creatorRef = "";
  String _creatorUsername = "";
  DateTime _creationDate = DateTime.now();
  List<dynamic> _members = [];

  // Getters
  String get docId => _docId;
  String get title => _title;
  String get description => _description;
  String get creatorRef => _creatorRef;
  String get creatorUsername => _creatorUsername;
  DateTime get creationDate => _creationDate;
  List<dynamic> get members => _members;

  // Setters
  set title(String title) {
    _title = title;
  }
  set description(String description) => _description = description;

  // Constructors
  Project({docId = "", required title, description = "",
  required creatorRef, required creatorUsername, required creationDate, required members}) {
    _docId = docId;
    if (title.length >= 3) {
      _title = title;
    }
    _description = description;
    _creatorRef = creatorRef;
    _creatorUsername = creatorUsername;
    _creationDate = creationDate;
    _members = members;
  }
}