import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teamvortex/models/entities/Project.dart';
import 'package:teamvortex/models/services/firebase_auth_services.dart';

class FirestoreProjects {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  Future<int> createProject(Project project) async {
    int statusCode = 0;
    try {
      await _firestore.collection("projects").add(<String, dynamic>{
        "title": project.title,
        "description": project.description,
        "creatorRef": project.creatorRef,
        "creatorUsername": project.creatorUsername,
        "creationDate": project.creationDate,
        "members": project.members
      });
    }
    catch (err) {
      statusCode = -1;
    }
    return statusCode;
  }

  Future<List<Project>> getProjects() async { //Get all projects that include user as member.
    List<Project> projects = [];
    QuerySnapshot<Map<String, dynamic>>? querySnapshot;
    try {
      querySnapshot = await _firestore
      .collection("projects")
      .where("members", arrayContains: await FirebaseAuthServices().instance.currentUser!.displayName)
      .get();
      for (var doc in querySnapshot.docs) {
        projects.add(
          Project(
            docId: doc.id, // Document unique ID
            title: doc.data()["title"],
            description: doc.data()["description"],
            creatorRef: doc.data()["creatorRef"],
            creatorUsername: doc.data()["creatorUsername"],
            creationDate: doc.data()["creationDate"].toDate(),
            members: doc.data()["members"],
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