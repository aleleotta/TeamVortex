import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teamvortex/models/entities/ProjectNote.dart';

class FirestoreProjectNotes {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Uploads a new note in Firestore.
  Future<int> addNote(String projectId, ProjectNote note) async {
    int statusCode = 0;
    try {
      await _firestore
      .collection("project_notes")
      .add(note.toMap());
    }
    catch (err) {
      statusCode = -1;
    }
    return statusCode;
  }

  /// Returns a list of all notes in Firestore based on project ID.
  Future<List<ProjectNote>> getNotes(String projectId) async {
    List<ProjectNote> notes = [];
    QuerySnapshot<Map<String, dynamic>>? querySnapshot;
    try {
      querySnapshot = await _firestore
      .collection("project_notes")
      .where("projectRef", isEqualTo: projectId)
      .get();
      for (var doc in querySnapshot.docs) {
        notes.add(ProjectNote.fromMap(doc.data(), doc.id));
      }
    }
    catch (err) {
      return notes = [];
    }
    return notes;
  }
}