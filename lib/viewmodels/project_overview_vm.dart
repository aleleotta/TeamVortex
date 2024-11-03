import 'package:flutter/material.dart';
import 'package:teamvortex/models/entities/Project.dart';

class ProjectOverviewViewModel extends ChangeNotifier {
  Project? _selectedProject;

  Project? get selectedProject => _selectedProject;

  void setSelectedProject(Project project) {
    _selectedProject = project;
    notifyListeners();
  }

  void clearSelectedProject() {
    _selectedProject = null;
  }
}