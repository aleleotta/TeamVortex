  import 'package:cloud_firestore/cloud_firestore.dart';
  import 'package:flutter/foundation.dart';
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
            _projectOptions()
          ]
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(20, 15, 20, 0),
          child: Center(
            child: Column(
              children: <Widget>[
                Container(
                  width: 1800,
                  height: screenHeight - 257,
                  decoration: BoxDecoration(
                    color: const Color.fromARGB(255, 88, 124, 230),
                    border: Border.all(
                      color: Colors.black,
                    ),
                  ),
                  child: Column(
                    children: <Widget>[
                      const Padding(
                        padding: EdgeInsets.only(top: 5, bottom: 5),
                        child: Text("Feed", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
                      ),
                      const Divider(color: Colors.black, height: 0),
                      Expanded(
                        child: SingleChildScrollView(
                          controller: _scrollController,
                          child: StreamBuilder<QuerySnapshot>(
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
                              WidgetsBinding.instance.addPostFrameCallback((_) {
                                if (context.read<ProjectFeedViewModel>().firstTimeExecution == true) {
                                  _scrollDown();
                                  context.read<ProjectFeedViewModel>().firstTimeExecution = false;
                                }
                              });
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
                          ),
                        ),
                      )
                    ]
                  )
                ),
                Expanded(
                  child: SizedBox(
                    child: Center(
                      child: _inputFieldWithSend(context)
                    )
                  ),
                ),
              ]
            )
          ),
        ),
        bottomNavigationBar: navigationBarInsideProject(context),
      );
    }

    Widget _messageItem(BuildContext context, Message message) {
      String time;
      if (message.timestamp.toDate().day == DateTime.now().day) {
        time = DateFormat("hh:mm a").format(message.timestamp.toDate());
      } else if (message.timestamp.toDate().day != DateTime.now().day && message.timestamp.toDate().year == DateTime.now().year) {
        time = DateFormat("dd/MM hh:mm a").format(message.timestamp.toDate());
      } else {
        time = DateFormat("dd/MM/yyyy hh:mm a").format(message.timestamp.toDate());
      }
      return Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.black54, width: 0.1),
          color: Colors.blue[300]
        ),
        child: ExpansionTile(
          initiallyExpanded: true,
          title: Text(message.senderUsername),
          trailing: Text(time, style: const TextStyle(fontSize: 13)),
          children: <Widget>[
            Container(
              width: 1800,
              color: Colors.cyan[200],
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Text(message.messageString),
              )
            )
          ]
        )
      );
    }

    Widget _inputFieldWithSend(BuildContext context) {
      double elementHeight = 50;
      return Row(
        children: <Widget>[
          Expanded(
            child: Container(
              height: elementHeight,
              decoration: BoxDecoration(
                border: Border.all(color: Colors.black, width: 0.5),
                borderRadius: BorderRadius.circular(15),
              ),
              child: Padding(
                padding: const EdgeInsets.only(left: 15),
                child: TextField(
                  controller: _messageController,
                  maxLines: 1,
                  decoration: const InputDecoration(
                    border: InputBorder.none,
                    hintText: "Send a message",
                  ),
                  textInputAction: TextInputAction.send,
                  onSubmitted: (text) {
                    if (_messageController.text.isNotEmpty) {
                      context.read<ProjectFeedViewModel>().sendMessage(text);
                      _messageController.clear();
                    }
                  },
                )
              ),
            )
          ),
          const SizedBox(width: 10),
          SizedBox(
            height: elementHeight,
            child: ElevatedButton(
              onPressed: () async {
                if (_messageController.text.isNotEmpty) {
                  context.read<ProjectFeedViewModel>().sendMessage(_messageController.text);
                  _messageController.clear();
                  await Future.delayed(const Duration(milliseconds: 100));
                  _scrollDown();
                }
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue,
              ),
              child: const Icon(Icons.send, color: Colors.white),
            ),
          )
        ]
      );
    }

    void _scrollDown() {
      try {
        _scrollController.animateTo(
        _scrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease
        );
      } catch (err) {
        if (kDebugMode) {
          print(err);
        }
      }
    }

    PopupMenuButton _projectOptions() {
      return PopupMenuButton(
        icon: const Icon(Icons.more_vert),
        itemBuilder: (context) => [
          PopupMenuItem(
            child: const Text("Add Member"),
            onTap: () {
              TextEditingController usernameController = TextEditingController();
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
                          inputFieldWithHoveringLabel("", controller: usernameController),
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
                          await context.read<ProjectFeedViewModel>().addUserToProject(usernameController.text)
                          .then((statusCode) {
                            if (usernameController.text.isEmpty) {
                              SnackBar snackBar = const SnackBar(content: Text("Please enter a username."), backgroundColor: Colors.red);
                              ScaffoldMessenger.of(context).showSnackBar(snackBar);
                            } else {
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
      );
    }

  }