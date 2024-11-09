import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamvortex/models/entities/Message.dart';
import 'package:teamvortex/viewmodels/project_feed_vm.dart';
import 'package:teamvortex/viewmodels/projects_vm.dart';
import 'package:teamvortex/views/widgets/inputs.dart';
import 'package:intl/intl.dart';

class ProjectFeedPage extends StatelessWidget {
  ProjectFeedPage({super.key});
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return _projectFeedView(context, constraints.maxWidth, constraints.maxHeight);
        },
      ),
    );
  }
  
  Widget _projectFeedView(BuildContext context, double screenWidth, double screenHeight) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.watch<ProjectFeedViewModel>().selectedProject?.title ?? "Project Overview"),
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: true,
        actions: [
          PopupMenuButton(
            icon: const Icon(Icons.more_vert),
            itemBuilder: (context) => [
              PopupMenuItem(
                child: const Text("Add Member"),
                onTap: () {
                  TextEditingController _usernameController = TextEditingController();
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Add Member"),
                        content: SizedBox(
                          height: 75,
                          child: Column(
                            children: <Widget>[
                              const Text("Specify the username:"),
                              const SizedBox(height: 5),
                              inputFieldWithHoveringLabel("", controller: _usernameController),
                            ],
                          ),
                        ),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10)
                          )
                        ),
                        actions: [
                          TextButton(
                            child: const Text("Cancel"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          TextButton(
                            child: const Text("Add"),
                            onPressed: () async {
                              await context.read<ProjectFeedViewModel>().addUserToProject(_usernameController.text)
                              .then((statusCode) {
                                if (statusCode == 0) {
                                  Navigator.pop(context);
                                  SnackBar snackBar = const SnackBar(content: Text("Member added successfully.",), backgroundColor: Colors.green);
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                } else if (statusCode == -1) {
                                  SnackBar snackBar = const SnackBar(content: Text("Error adding member."), backgroundColor: Colors.red);
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                } else if (statusCode == -2) {
                                  SnackBar snackBar = const SnackBar(content: Text("User does not exist."), backgroundColor: Colors.red);
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                } else if (statusCode == -3) {
                                  SnackBar snackBar = const SnackBar(content: Text("User already forms part of this project."), backgroundColor: Colors.red);
                                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                                }
                              });
                            },
                          ),
                        ]
                      );
                    }
                  );
                }
              ),
              PopupMenuItem(
                child: const Text("Delete Project"),
                onTap: () {
                  showDialog(
                    context: context,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text("Delete Project"),
                        content: const Text("Are you sure you want to delete this project?"),
                        shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.all(
                            Radius.circular(10)
                          )
                        ),
                        actions: [
                          TextButton(
                            child: const Text("Cancel"),
                            onPressed: () {
                              Navigator.pop(context);
                            },
                          ),
                          TextButton(
                            child: const Text("Delete"),
                            onPressed: () async {
                              await context.read<ProjectFeedViewModel>().deleteProject(context)
                              .then((statusCode) {
                                if (statusCode == 0) {
                                  context.read<ProjectsViewModel>().clearProjectsList();
                                  context.read<ProjectsViewModel>().getProjects();
                                  Navigator.pushReplacementNamed(context, "/projectsView");
                                }
                              });
                            },
                          ),
                        ]
                      );
                    }
                  );
                }
              )
            ]
          )
        ]
      ),
      body: Padding(
        padding: const EdgeInsets.all(20),
        child: Center(
          child: Column(
            children: <Widget>[
              Container(
                width: 1000,
                height: screenHeight - 240,
                decoration: BoxDecoration(
                  color: Colors.cyan[200],
                  border: Border.all(
                    color: Colors.black,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.only(top: 5),
                  child: SingleChildScrollView(
                    controller: _scrollController,
                    child: Column(
                      children: <Widget>[
                        const Text("Feed", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
                        const Divider(color: Colors.black),
                        StreamBuilder<QuerySnapshot>(
                          stream: context.watch<ProjectFeedViewModel>().messages,
                          builder: (context, AsyncSnapshot<QuerySnapshot> snapshot) {
                            if (snapshot.hasError) {
                              return const Text("No Connection.");
                            } else if (snapshot.connectionState == ConnectionState.waiting) {
                              return const CircularProgressIndicator();
                            }
                            final documents = snapshot.data?.docs;
                            if (documents?.isEmpty ?? true) {
                              return const Text("No Messages.");
                            }
                            return Column(
                              children: documents!.map(
                                (DocumentSnapshot document) {
                                  final data = document.data() as Map<String, dynamic>;
                                  Message message = Message.fromMap(data);
                                  return _messageItem(context, message);
                                }
                              ).toList()
                            );
                          },
                        )
                      ]
                    )
                  )
                )
              ),
              const SizedBox(height: 20),
              Stack(
                children: <Widget>[
                  Container(
                    width: 1000,
                    height: 40,
                    decoration: BoxDecoration(
                      color: Colors.cyan[200],
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: Colors.black
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.fromLTRB(15, 0, 80, 12),
                      child: TextField(
                        controller: _messageController,
                        maxLines: 1,
                        decoration: const InputDecoration(
                          border: InputBorder.none,
                          hintText: "Send a message",
                        ),
                      ),
                    )
                  ),
                  Positioned(
                    right: 5,
                    bottom: 4,
                    child: ElevatedButton(
                      onPressed: () {
                        if (_messageController.text.isNotEmpty) {
                          context.read<ProjectFeedViewModel>().sendMessage(_messageController.text);
                        }
                        _scrollController.animateTo(
                          _scrollController.position.maxScrollExtent,
                          duration: const Duration(milliseconds: 500),
                          curve: Curves.ease
                        );
                        _messageController.clear();
                      },
                      child: const Icon(Icons.send, size: 20),
                    )
                  )
                ]
              )
            ]
          )
        ),
      ),
      bottomNavigationBar: navigationBarInsideProject(context),
    );
  }

  Widget _messageItem(BuildContext context, Message message) {
    String time = DateFormat("hh:mm a").format(message.timestamp.toDate());
    double messageWidth = MediaQuery.of(context).size.width * 0.7;
    double messageHeight = 50 + (message.messageString.length / 05);
    return Container(
      width: 1000,
      height: messageHeight,
      decoration: const BoxDecoration(
        border: Border(
          bottom: BorderSide(
            color: Colors.black38
          )
        )
      ),
      child: Stack(
        children: <Widget>[
          Positioned(
            left: 7,
            top: 0,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text("${message.senderUsername}:", style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
                const SizedBox(width: 5),
                SizedBox(
                  width: messageWidth,
                  child: Text(message.messageString, style: const TextStyle(fontSize: 17))
                )
              ]
            ),
          ),
          Positioned(
            right: 3,
            bottom: 1,
            child: Text(
              time,
              style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold))
          ),
        ]
      )
    );
  }
}