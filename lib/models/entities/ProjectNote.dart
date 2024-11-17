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

  // Getters
  String get getDocId => docId;
  String get getTitle => title;
  String get getContent => content;
  String get getProjectRef => projectRef;
  String get getCreatorUsername => creatorUsername;
  Timestamp get getCreationDate => creationDate;

  // Setters
  set setTitle(String title) => this.title = title;
  set setContent(String content) => this.content = content;

  // Constructor
  ProjectNote({
    required this.docId,
    required this.title,
    required this.content,
    required this.projectRef,
    required this.creatorUsername,
    required this.creationDate,
  });

  // Methods
  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'content': content,
      'projectRef': projectRef,
      'creatorUsername': creatorUsername,
      'creationDate': creationDate,
    };
  }

  static ProjectNote fromMap(Map<String, dynamic> map, String docId) {
    return ProjectNote(
      docId: docId,
      title: map['title'],
      content: map['content'],
      projectRef: map['projectRef'],
      creatorUsername: map['creatorUsername'],
      creationDate: map['creationDate'],
    );
  }
}