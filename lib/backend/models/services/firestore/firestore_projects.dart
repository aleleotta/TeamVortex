import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:teamvortex/backend/models/entities/Project.dart';
import 'package:teamvortex/backend/models/services/firebase_auth_services.dart';

class FirestoreProjects {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  ///Creates project
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

  ///Returns a list of all projects that include user as member
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
        DocumentSnapshot<Map<String, dynamic>> project = await _firestore
        .collection("projects")
        .doc(docId)
        .get();
        for (String member in project.data()!["members"]) {
          if (member == username) {
            statusCode = -3;
          }
        }
        if (statusCode == 0) {
          await _firestore
          .collection("projects")
          .doc(docId)
          .update({
            "members": FieldValue.arrayUnion([username])
          });
        } 
      }
    }
    catch (err) {
      statusCode = -1;
    }
    return statusCode;
  }

  ///Get all members of project
  Future<List<String>> getProjectMembers(String docId) async {
    List<String> members = [];
    try {
      DocumentSnapshot<Map<String, dynamic>> project = await _firestore
      .collection("projects")
      .doc(docId)
      .get();
      for (String member in project.data()!["members"]) {
        members.add(member);
      }
    }
    catch (err) {
      return [];
    }
    return members;
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

  ///Deletes user from all projects
  Future<int> deleteUserFromAllProjects(String username) async {
    int statusCode = 0;
    try {
      await _firestore.collection("projects").where("members", arrayContains: username).get()
      .then(
        (querySnapshot) {
          for (var doc in querySnapshot.docs) {
            _firestore.collection("projects").doc(doc.reference.id).update({
              "members": FieldValue.arrayRemove([username])
            });
          }
        }
      );
    }
    catch (err) {
      statusCode = -1;
    }
    return statusCode;
  }

  ///Deletes user from indicated project
  Future<int> deleteUserFromProject(String docId, String username) async {
    int statusCode = 0;
    try {
      await _firestore
      .collection("projects")
      .doc(docId)
      .update({
        "members": FieldValue.arrayRemove([username])
      });
    }
    catch (err) {
      statusCode = -1;
    }
    return statusCode;
  }

  ///Deletes project
  Future<int> deleteProject(String docId) async {
    int statusCode = 0;
    try {
      await _firestore.collection("feed_messages").where("receiverId", isEqualTo: docId).get() //Delete project feed messages
      .then(
        (querySnapshot) {
          for (var doc in querySnapshot.docs) {
            _firestore.collection("feed_messages").doc(doc.reference.id).delete();
          }
        }
      );
      await _firestore.collection("project_notes").where("projectRef", isEqualTo: docId).get() //Delete project notes
      .then(
        (querySnapshot) {
          for (var doc in querySnapshot.docs) {
            _firestore.collection("project_notes").doc(doc.reference.id).delete();
          }
        }
      );
      await _firestore.collection("projects").doc(docId).delete();
    }
    catch (err) {
      statusCode = -1;
    }
    return statusCode;
  }

  
}