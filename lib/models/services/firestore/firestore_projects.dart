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

  ///Adds user to indicated project
  Future<int> addUserToProject(String docId, String username) async {
    int statusCode = 0;
    try {
      int statusCode2 = await findUser(username);
      if (statusCode2 == -2) {
        statusCode = -2;
      } else {
        await _firestore
        .collection("projects")
        .doc(docId)
        .update({
          "members": FieldValue.arrayUnion([username])
        });
      }
    }
    catch (err) {
      statusCode = -1;
    }
    return statusCode;
  }

  ///Checks if user exists
  Future<int> findUser(String username) async {
    int statusCode = 0;
    QuerySnapshot<Map<String, dynamic>>? querySnapshot;
    try {
      querySnapshot = await _firestore
      .collection("users")
      .where("username", isEqualTo: username)
      .get();
      if (querySnapshot.docs.isEmpty) {
        statusCode = -2;
      }
    }
    catch (err) {
      statusCode = -1;
    }
    return statusCode;
  }

  Future<int> deleteProject(String docId) async {
    int statusCode = 0;
    try {
      await _firestore.collection("projects").doc(docId).delete();
    }
    catch (err) {
      statusCode = -1;
    }
    return statusCode;
  }

  
}