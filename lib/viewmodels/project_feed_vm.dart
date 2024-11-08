import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:teamvortex/models/entities/Message.dart';
import 'package:teamvortex/models/entities/Project.dart';
import 'package:teamvortex/models/services/firestore/firestore_projects.dart';
import 'package:teamvortex/models/services/firestore/firestore_user_project_feed.dart';
import 'package:teamvortex/viewmodels/projects_vm.dart';

class ProjectFeedViewModel extends ChangeNotifier {
  Project? _selectedProject;
  Stream<QuerySnapshot>? _messages;

  Project? get selectedProject => _selectedProject;
  Stream<QuerySnapshot>? get messages => _messages;

  void setSelectedProject(Project project) {
    _selectedProject = project;
    _messages = FirestoreProjectFeed().getMessages(project.docId);
    notifyListeners();
  }

  void clearSelectedProject() {
    _selectedProject = null;
  }

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
      //A Toast will appear in the UI
      statusCode = -1;
    }
    return statusCode;
  }

}