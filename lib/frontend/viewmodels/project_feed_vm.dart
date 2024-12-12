import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:teamvortex/backend/models/entities/Message.dart';
import 'package:teamvortex/backend/models/entities/Project.dart';
import 'package:teamvortex/backend/models/services/firestore/firestore_projects.dart';
import 'package:teamvortex/backend/models/services/firestore/firestore_user_project_feed.dart';

class ProjectFeedViewModel extends ChangeNotifier {
  Project? _selectedProject;
  List<String> _members = [];
  Stream<QuerySnapshot>? _messages;
  bool firstTimeExecution = true;
  bool isAdmin = false;

  Project? get selectedProject => _selectedProject;
  List<String> get members => _members;
  Stream<QuerySnapshot>? get messages => _messages;

  /// Notifies listeners that the selected project has changed.
  void setSelectedProject(Project project) async {
    isAdmin = project.creatorRef == FirebaseAuth.instance.currentUser!.uid;
    _selectedProject = project;
    _members = await FirestoreProjects().getProjectMembers(project.docId);
    _messages = FirestoreProjectFeed().getMessages(project.docId);
    notifyListeners();
  }

  void clearSelectedProject() {
    _selectedProject = null;
  }

  /// Adds user to indicated project
  Future<int> addUserToProject(String username) async {
    int statusCode = 0;
    try {
      statusCode = await FirestoreProjects().addUserToProject(_selectedProject!.docId, username);
    } catch (err) {
      statusCode = -1;
    }
    return statusCode;
  }

  /// Deletes user from indicated project
  Future<int> deleteProject(context) async {
    int statusCode = 0;
    try {
      statusCode = await FirestoreProjects().deleteProject(_selectedProject!.docId);
      _selectedProject = null;
    } catch (err) {
      statusCode = -1;
    }
    return statusCode;
  }

  /// Uploads a new message to Firestore.
  Future<int> sendMessage(String messageString) async {
    int statusCode = 0;
    try {
      Message message = Message(
        senderId: FirebaseAuth.instance.currentUser!.uid,
        senderUsername: FirebaseAuth.instance.currentUser!.displayName!,
        receiverId: _selectedProject!.docId,
        messageString: messageString,
        timestamp: Timestamp.now(),
      );
      statusCode = await FirestoreProjectFeed().sendMessage(message);
    } catch (err) {
      statusCode = -1;
    }
    return statusCode;
  }

}