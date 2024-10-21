import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teamvortex/models/entities/Project.dart';

class FirestoreProjects {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<int> createProject(Project project) async {
    int statusCode = 0;
    try {
      await _firestore.collection("projects").add({
        "title": project.title,
        "description": project.description,
        "creatorRef": project.creatorRef,
        "creationDate": project.creationDate
      });
    }
    catch (err) {
      statusCode = -1;
    }
    return statusCode;
  }

  Future<List<Project>> getProjects() async {
    List<Project> projects = [];
    QuerySnapshot<Map<String, dynamic>>? querySnapshot;
    try {
      querySnapshot = await _firestore.collection("projects").get();
      for (var doc in querySnapshot.docs) {
        projects.add(
          Project(
            docId: doc.id,
            title: doc.data()["title"],
            description: doc.data()["description"],
            creatorRef: doc.data()["creatorRef"],
            creatorUsername: doc.data()["creatorUsername"],
            creationDate: doc.data()["creationDate"],
          )
        );
      }
    }
    catch (err) {
      return [];
    }
    return projects;
  }
}