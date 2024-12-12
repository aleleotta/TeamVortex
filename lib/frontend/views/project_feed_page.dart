  import 'package:cloud_firestore/cloud_firestore.dart';
  import 'package:flutter/foundation.dart';
  import 'package:flutter/material.dart';
  import 'package:provider/provider.dart';
  import 'package:teamvortex/backend/models/entities/Message.dart';
  import 'package:teamvortex/frontend/viewmodels/project_feed_vm.dart';
  import 'package:teamvortex/frontend/viewmodels/projects_vm.dart';
  import 'package:teamvortex/frontend/views/widgets/inputs.dart';
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
    
    /// This widget displays the project feed, where users can post messages to share
    /// with other project members. The widget is scrollable and has a text field at
    /// the bottom for users to input their messages.
    Widget _projectFeedView(BuildContext context, double screenWidth, double screenHeight) {
      return Scaffold(
        appBar: AppBar(
          title: Text(context.watch<ProjectFeedViewModel>().selectedProject?.title ?? "Project Overview"),
          backgroundColor: Colors.blue,
          automaticallyImplyLeading: true,
          actions: [
            _projectOptions(context)
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

    /// Creates a widget that displays a message within a card.
    ///
    /// The card contains:
    /// - The sender's username at the top-left, styled in bold.
    /// - The message content in the center-left.
    /// - The timestamp of the message at the bottom-right, formatted based on the
    ///   message date:
    ///   - "hh:mm a" if the message was sent today.
    ///   - "dd/MM hh:mm a" if sent within the current year.
    ///   - "dd/MM/yyyy hh:mm a" if sent in a previous year.
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

    /// Creates a widget containing an input field and a send button for sending messages.
    /// 
    /// The widget consists of:
    /// - An expandable text field where the user can type a message. 
    ///   Upon pressing enter, the message is sent if the field is not empty.
    /// - A send button to the right of the text field, which sends the message 
    ///   when pressed, provided the input is not empty. After sending, the input
    ///   field is cleared and the view scrolls down to the latest message.
    /// 
    /// The [context] parameter is used to access the widget tree, 
    /// allowing interaction with the view model for sending messages and controlling the scroll position.
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

    /// Scrolls down to the bottom of the scroll view with an animation.
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

    /// A button that shows a menu with options related to the project.
    ///
    /// If the user is an administrator, the menu contains the following options:
    /// - View members: opens a dialog with a list of all members of the project.
    /// - Add member: opens a dialog to add a new member to the project.
    /// - Delete project: opens a dialog to confirm the deletion of the project.
    ///
    /// If the user is not an administrator, the menu only contains the option
    /// "View members".
    PopupMenuButton _projectOptions(BuildContext context) {
      bool checkAdmin = context.read<ProjectFeedViewModel>().isAdmin;
      if (checkAdmin) {
        return PopupMenuButton(
          icon: const Icon(Icons.more_vert),
          itemBuilder: (context) => [
            PopupMenuItem(
              child: const Text("View members"),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Members"),
                      content: SizedBox(
                        height: 300,
                        width: 300,
                        child: SingleChildScrollView(
                          child: ListBody(
                            children: context.watch<ProjectFeedViewModel>().members.map((member) {
                              return ListTile(
                                title: Container(
                                  decoration: const BoxDecoration(
                                    border: Border.symmetric(horizontal: BorderSide(width: 0.5, color: Colors.black)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Text(member),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      actions: [
                        TextButton(
                          child: const Text("Close"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          }
                        ),
                      ],
                    );
                  }
                );
              }
            ),
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
      } else {
        return PopupMenuButton(
          icon: const Icon(Icons.more_vert),
          itemBuilder: (context) => [
            PopupMenuItem(
              child: const Text("View members"),
              onTap: () {
                showDialog(
                  context: context,
                  builder: (context) {
                    return AlertDialog(
                      title: const Text("Members"),
                      content: SizedBox(
                        height: 300,
                        width: 300,
                        child: SingleChildScrollView(
                          child: ListBody(
                            children: context.watch<ProjectFeedViewModel>().members.map((member) {
                              return ListTile(
                                title: Container(
                                  decoration: const BoxDecoration(
                                    border: Border.symmetric(horizontal: BorderSide(width: 0.5, color: Colors.black)),
                                  ),
                                  child: Padding(
                                    padding: const EdgeInsets.all(5),
                                    child: Text(member),
                                  ),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                      actions: [
                        TextButton(
                          child: const Text("Close"),
                          onPressed: () {
                            Navigator.of(context).pop();
                          }
                        ),
                      ],
                    );
                  }
                );
              }
            ),
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
            )
          ]
        );
      }
    }

  }