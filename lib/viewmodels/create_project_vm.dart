import 'package:flutter/material.dart';
import 'package:teamvortex/models/entities/Project.dart';
import 'package:teamvortex/models/services/firebase_auth_services.dart';
import 'package:teamvortex/models/services/firebase_firestore_services.dart';
import 'package:teamvortex/models/services/firestore_extensions/firestore_projects.dart';

class CreateProjectViewModel extends ChangeNotifier {
  Project? _project;
  String errorMessage = "";

  Future<int> createNewProject(String title, String description) async {
    int statusCode = 0;
    try {
      if (title.isEmpty || description.isEmpty) {
        errorMessage = "All fields need to be filled in.";
        statusCode = -1;
      } else {
        String? username = await FirebaseAuthServices().getCurrentUsername();
        String? userReference = await FirebaseFirestoreServices().getUserReference(username!);
        if (username.isNotEmpty && userReference.isNotEmpty) {
          _project = Project(
            title: title,
            description: description,
            creatorRef: userReference,
            creatorUsername: username,
            creationDate: DateTime.now(),
            members: [username]
          );
        }
        if (_project == null) {
          errorMessage = "An internal error has occured.";
          statusCode = -1;
        } else {
          statusCode = await FirestoreProjects().createProject(_project!);
        }
      }
    }
    catch (err) {
      errorMessage = "An internal error has occured.";
      statusCode = -1;
    }
    if (statusCode == 0) {
      errorMessage = "";
    }
    notifyListeners();
    return statusCode;
  }
}