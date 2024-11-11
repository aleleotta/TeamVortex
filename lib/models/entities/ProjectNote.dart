// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

class ProjectNote {
  // Attributes
  final String docId;
  String title;
  String content;
  final String projectRef;
  final String creatorUsername;
  final Timestamp creationDate;
  Timestamp? editDate;
  Timestamp? dueDate;

  // Getters
  String get getDocId => docId;
  String get getTitle => title;
  String get getContent => content;
  String get getProjectRef => projectRef;
  String get getCreatorUsername => creatorUsername;
  Timestamp get getCreationDate => creationDate;
  Timestamp? get getEditDate => editDate;
  Timestamp? get getDueDate => dueDate;

  // Setters
  set setTitle(String title) => this.title = title;
  set setContent(String content) => this.content = content;
  set setEditDate(Timestamp? editDate) => this.editDate = editDate;
  set setDueDate(Timestamp? dueDate) => this.dueDate = dueDate;

  // Constructor
  ProjectNote({
    required this.docId,
    required this.title,
    required this.content,
    required this.projectRef,
    required this.creatorUsername,
    required this.creationDate,
    this.editDate,
    this.dueDate
  });

  // Methods
  Map<String, dynamic> toMap() {
    return {
      'docId': docId,
      'title': title,
      'content': content,
      'projectRef': projectRef,
      'creatorUsername': creatorUsername,
      'creationDate': creationDate,
      'editDate': editDate,
      'dueDate': dueDate
    };
  }

  static ProjectNote fromMap(Map<String, dynamic> map) {
    return ProjectNote(
      docId: map['docId'],
      title: map['title'],
      content: map['content'],
      projectRef: map['projectRef'],
      creatorUsername: map['creatorUsername'],
      creationDate: map['creationDate'],
      editDate: map['editDate'] as Timestamp?,
      dueDate: map['dueDate'] as Timestamp?
    );
  }
}