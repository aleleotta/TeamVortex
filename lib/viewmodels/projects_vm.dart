import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:teamvortex/models/entities/Project.dart';
import 'package:teamvortex/models/services/firebase_auth_services.dart';
import 'package:teamvortex/models/services/firestore_extensions/firestore_projects.dart';

class ProjectsViewModel extends ChangeNotifier {
  List<Project> _projects = [];

  List<Project> get projects => _projects;

  void getProjects() async {
    try {
      _projects = await FirestoreProjects().getProjects();
    } catch (err) {
      return null;
    }
  }

  /*Future<int> createProject(Project project) async {
    int statusCode = 0;
    try {
      statusCode = await FirestoreProjects().createProject(project);
    } catch (err) {
      statusCode = -1;
      return statusCode;
    }
    return statusCode;
  }*/

  ProjectsViewModel() {
    getProjects();
  }
}