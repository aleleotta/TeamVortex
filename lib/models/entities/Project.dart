// ignore_for_file: file_names

class Project {
  // Attributes
  String _docId = "";
  String _title = "";
  String _description = "";
  String _creatorRef = "";
  String _creatorUsername = "";
  DateTime _creationDate = DateTime.now();

  // Getters
  String get docId => _docId;
  String get title => _title;
  String get description => _description;
  String get creatorRef => _creatorRef;
  String get creatorUsername => _creatorUsername;
  DateTime get creationDate => _creationDate;

  // Setters
  set title(String title) {
    if (title.length >= 3) {
      _title = title;
    }
  }
  set description(String description) => _description = description;

  // Constructors
  Project({String docId = "", required String title, String description = "", required creatorRef, required creatorUsername, required creationDate}) {
    _docId = docId;
    if (title.length >= 3) {
      _title = title;
    }
    _description = description;
    _creatorRef = creatorRef;
    _creationDate = creationDate;
  }
}