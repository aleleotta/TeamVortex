// ignore_for_file: file_names

import 'package:cloud_firestore/cloud_firestore.dart';

class ChatRoom {
  // Attributes
  final String id;
  final Timestamp creationDate;
  final List members;

  // Getters
  String get getId => id;
  Timestamp get getCreationDate => creationDate;
  List get getMembers => members;

  // Constructor
  ChatRoom({
    required this.id,
    required this.creationDate,
    required this.members
  });

  // Methods
  Map<String, dynamic> toMap() {
    return {
      "creationDate": creationDate,
      "members": members
    };
  }

  static ChatRoom fromMap(Map<String, dynamic> map, String docId) {
    return ChatRoom(
      id: docId,
      creationDate: map["creationDate"],
      members: map["members"]
    );
  }
}