import 'package:flutter/material.dart';
import 'package:teamvortex/models/entities/Project.dart';
import 'package:teamvortex/models/services/firestore_extensions/firestore_projects.dart';

class ProjectsViewModel extends ChangeNotifier {
  List<Project> _projects = [];
  bool _showAddButton = true;

  List<Project> get projects => _projects;
  bool get showAddButton => _showAddButton;

  set showAddButton(bool value) {
    _showAddButton = value;
    notifyListeners();
  }

  Future<List<Project>?> getProjects() async {
    List<Project> projects = [];
    try {
      projects = await FirestoreProjects().getProjects();
    } catch (err) {
      return null;
    }
    return projects;
  }

  Future<int> createProject(Project project) async {
    int statusCode = 0;
    try {
      statusCode = await FirestoreProjects().createProject(project);
    } catch (err) {
      statusCode = -1;
      return statusCode;
    }
    return statusCode;
  }
}