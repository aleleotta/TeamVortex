import 'package:flutter/material.dart';
import 'package:teamvortex/models/entities/Project.dart';
import 'package:teamvortex/models/entities/ProjectNote.dart';
import 'package:teamvortex/models/services/firestore/firestore_project_notes.dart';

class ProjectNotesViewModel extends ChangeNotifier {
  List<ProjectNote> _notesList = [];
  bool _addButtonVisible = true;
  bool _isCreating = false;
  Project? _selectedProject;

  List<ProjectNote> get notesList => _notesList;
  bool get addButtonVisible => _addButtonVisible;
  bool get isCreating => _isCreating;

  void addButtonPressed() {
    _addButtonVisible = false;
    _isCreating = true;
    notifyListeners();
  }

  void noteFinalized() {
    _addButtonVisible = true;
    _isCreating = false;
    notifyListeners();
  }

  void setSelectedProject(Project project) async {
    _selectedProject = project;
    try {
      _notesList = await FirestoreProjectNotes().getNotes(project.docId);
    }
    catch (err) {
      _notesList = [];
    }
    notifyListeners();
  }

  void getNotes() async {
    try {
      _notesList = await FirestoreProjectNotes().getNotes(_selectedProject!.docId);
    }
    catch (err) {
      _notesList = [];
    }
    notifyListeners();
  }

  void addNote(String projectId, ProjectNote note) async {
    int statusCode = await FirestoreProjectNotes().addNote(projectId, note);
    if (statusCode == 0) {
      getNotes();
    }
    notifyListeners();
  }

}