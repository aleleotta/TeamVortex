import 'package:flutter/material.dart';
import 'package:teamvortex/models/entities/Project.dart';
import 'package:teamvortex/models/services/firestore/firestore_projects.dart';

class ProjectsViewModel extends ChangeNotifier {
  List<Project> _projects = [];

  List<Project> get projects => _projects;

  /// Get all projects where user is a member.
  void getProjects() async {
    try {
      _projects = await FirestoreProjects().getProjects();
    } catch (err) {
      return null;
    }
    notifyListeners();
  }

  void clearProjectsList() {
    _projects.clear();
  }

  ProjectsViewModel() {
    getProjects();
  }
}