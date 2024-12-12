import 'package:flutter/material.dart';
import 'package:teamvortex/backend/models/entities/Project.dart';
import 'package:teamvortex/backend/models/entities/ProjectNote.dart';
import 'package:teamvortex/backend/models/services/firestore/firestore_project_notes.dart';

class ProjectNotesViewModel extends ChangeNotifier {
  List<ProjectNote> _notesList = [];
  bool _addButtonVisible = true;
  bool _isCreating = false;
  Project? _selectedProject;

  List<ProjectNote> get notesList => _notesList;
  bool get addButtonVisible => _addButtonVisible;
  bool get isCreating => _isCreating;

  /// Notifies listeners that the add note button visibility has changed.
  void setIsCreating(bool isCreating) {
    _isCreating = isCreating;
    _addButtonVisible = !isCreating;
    notifyListeners();
  }

  /// Notifies listeners that the add note button has been pressed.
  void addButtonPressed() {
    _addButtonVisible = false;
    _isCreating = true;
    notifyListeners();
  }

  /// Notifies listeners that the note has been finalized and should be added to the list.
  void noteFinalized() {
    _addButtonVisible = true;
    _isCreating = false;
    notifyListeners();
  }

  /// Notifies listeners that the selected project has changed.
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

  /// Gets the notes for the selected project.
  void getNotes() async {
    try {
      _notesList = await FirestoreProjectNotes().getNotes(_selectedProject!.docId);
    }
    catch (err) {
      _notesList = [];
    }
    notifyListeners();
  }

  /// Adds a new note to the selected project.
  void addNote(String projectId, ProjectNote note) async {
    int statusCode = await FirestoreProjectNotes().addNote(projectId, note);
    if (statusCode == 0) {
      getNotes();
    }
    notifyListeners();
  }

  /// Deletes a note from the selected project.
  Future<int> deleteNote(ProjectNote note) async {
    int statusCode = 0;
    try {
      statusCode = await FirestoreProjectNotes().deleteNote(note.docId);
    }
    catch (err) {
      statusCode = -1;
    }
    if (statusCode == 0) {
      getNotes();
    }
    notifyListeners();
    return statusCode;
  }
}