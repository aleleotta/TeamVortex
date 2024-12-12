import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:teamvortex/backend/models/entities/ProjectNote.dart';
import 'package:teamvortex/frontend/viewmodels/project_notes_vm.dart';

/// Creates a card to let the user create a project note.
Widget projectNoteCardCreate(BuildContext context, String projectRef) {
  double cardHeight = 220;
  TextEditingController titleController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();
  return Column(
    children: <SizedBox>[
      SizedBox(
        height: cardHeight,
        child: Card(
          color: Colors.grey[400],
          elevation: 5,
          child: Stack(
            children: <Positioned>[
              Positioned(
                top: 0,
                left: 10,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.425,
                  child: TextField(
                    controller: titleController,
                    maxLines: 2,
                    maxLength: 30,  
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Introduce title..."
                    ),
                  ),
                ),
              ),
              Positioned(
                top: 75,
                left: 10,
                child: SizedBox(
                  width: MediaQuery.of(context).size.width * 0.425,
                  height: 110,
                  child: TextField(
                    controller: descriptionController,
                    maxLines: 4,
                    maxLength: 200,
                    style: const TextStyle(
                      fontSize: 15,
                      fontWeight: FontWeight.bold
                    ),
                    decoration: const InputDecoration(
                      border: InputBorder.none,
                      hintText: "Introduce description..."
                    ),
                  ),
                )
              ),
              Positioned(
                bottom: 2,
                right: 10,
                child: Row(
                  children: [
                    IconButton(
                      icon: Icon(
                        Icons.close,
                        color: Colors.red[700],
                        size: 28,
                      ),
                      onPressed: () {
                        context.read<ProjectNotesViewModel>().noteFinalized();
                      }
                    ),
                    const SizedBox(width: 10),
                    IconButton(
                      icon: Icon(
                        Icons.check,
                        color: Colors.green[700],
                        size: 28,
                      ),
                      onPressed: () {
                        //Note creation procedure
                        if (titleController.text.isEmpty || descriptionController.text.isEmpty) {
                          showDialog(
                            context: context,
                            builder: (context) {
                              return AlertDialog(
                                title: const Text("Error"),
                                content: const Text("Title and description cannot be empty."),
                                actions: [
                                  TextButton(
                                    child: const Text("OK"),
                                    onPressed: () {
                                      Navigator.pop(context);
                                    }
                                  )
                                ]
                              );
                            }
                          );
                        } else {
                          ProjectNote newNote = ProjectNote(
                          docId: "",
                          title: titleController.text,
                          content: descriptionController.text,
                          projectRef: projectRef,
                          creatorUsername: FirebaseAuth.instance.currentUser!.displayName!,
                          creationDate: Timestamp.now()
                        );
                        context.read<ProjectNotesViewModel>().addNote(projectRef, newNote);
                        context.read<ProjectNotesViewModel>().noteFinalized();
                        }
                      }
                    )
                  ]
                )
              ),
            ]
          )
        ),
      ),
      const SizedBox(height: 10)
    ]
  );
}

/// Creates a card to show a project note.
Widget projectNoteCard(BuildContext context, {required ProjectNote note}) {
  double cardHeight = 175;
  String time = DateFormat("dd/MM/yyyy hh:mm a").format(note.creationDate.toDate());
  return Column(
    children: <SizedBox>[
      SizedBox(
        height: cardHeight,
        child: Card(
          color: Colors.grey[350],
          elevation: 5,
          child: Padding(
            padding: const EdgeInsets.only(top: 5),
            child: Stack(
              children: <Positioned>[
                Positioned(
                  top: 0,
                  left: 10,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.425,
                    child: Text(
                      note.title,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 75,
                  left: 10,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.425,
                    child: Text(
                      note.content,
                      style: const TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold
                      ),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 5,
                  right: 10,
                  child: Text(
                    time
                  ),
                ),
                Positioned(
                  top: 5,
                  right: 10,
                  child: Column(
                    children: [
                      const Text(
                        "Created by:",
                      ),
                      Text(
                        note.creatorUsername,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontStyle: FontStyle.italic
                        ),
                      ),
                    ]
                  )
                ),
                Positioned(
                  bottom: 30,
                  right: 10,
                  child: ElevatedButton(
                    onPressed: () async {
                      showDialog(
                        context: context,
                        builder: (context) {
                          return AlertDialog(
                            title: const Text("Delete note"),
                            content: const Text("Are you sure you want to delete this note?"),
                            actions: [
                              TextButton(
                                child: const Text("Cancel"),
                                onPressed: () {
                                  Navigator.pop(context);
                                }
                              ),
                              TextButton(
                                child: const Text("Delete"),
                                onPressed: () {
                                  context.read<ProjectNotesViewModel>().deleteNote(note);
                                  Navigator.pop(context);
                                }
                              )
                            ]
                          );
                        }
                      );
                    },
                    style: ButtonStyle(
                      backgroundColor:
                          WidgetStateProperty.all(Colors.red),
                      shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5.0),
                        ),
                      ),
                    ),
                    child: const Text(
                      "Delete",
                      style: TextStyle(fontSize: 15, color: Colors.white)
                    ),
                  )
                ),
              ]
            ),
          )
        ),
      ),
      const SizedBox(height: 10)
    ]
  );
}