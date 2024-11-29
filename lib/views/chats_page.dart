import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:teamvortex/models/entities/ChatRoom.dart';
import 'package:provider/provider.dart';
import 'package:teamvortex/models/entities/Message.dart';
import 'package:teamvortex/viewmodels/chats_vm.dart';
import 'package:teamvortex/views/widgets/inputs.dart';

class ChatsView extends StatelessWidget {
  ChatsView({super.key});
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _chatRoomsScrollController = ScrollController();
  final ScrollController _chatScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) { // This will change the UI based on screen size
          return _messagesViewTabletOrPC(context, constraints.maxWidth, constraints.maxHeight);
        },
      ),
    );
  }

  Widget _messagesViewTabletOrPC(BuildContext context, double screenWidth, double screenHeight) {
    double firstViewWidth = screenWidth * 0.3;
    //double secondViewWidth = screenWidth * 0.7;
    return Scaffold(
      bottomNavigationBar: navigationBar(context),
      appBar: AppBar(
        title: const Text("Chats"),
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: true,
      ),
      drawer: drawerOptions(context),
      body: Row(
        children: <Widget>[
          SizedBox(
            height: screenHeight,
            width: screenWidth * 0.3,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Container(
                  height: 60,
                  width: firstViewWidth,
                  color: Colors.black26,
                  child: Stack(
                    children: <Widget>[
                      const Positioned(
                        left: 10,
                        top: 14,
                        child: Text("Chats", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
                      ),
                      Positioned(
                        right: 5,
                        top: 10,
                        child: IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () {
                            _addChatView(context, screenWidth, screenHeight);
                          },
                        )
                      )
                    ]
                  ),
                ),
                const Divider(height: 0, thickness: 1, color: Colors.grey),
                SingleChildScrollView(
                  controller: _chatRoomsScrollController,
                  child: SizedBox(
                    height: screenHeight - 202,
                    width: firstViewWidth,
                    child: ListView.builder(
                      itemCount: context.watch<ChatsViewModel>().chatRooms.length,
                      itemBuilder: (context, index) {
                        if (context.watch<ChatsViewModel>().chatRooms.isNotEmpty)
                        {
                          if (index >= context.watch<ChatsViewModel>().chatRooms.length) {
                            return _chatRoomItem(context, context.watch<ChatsViewModel>().chatRooms[index-1]);
                          }
                          return _chatRoomItem(context, context.watch<ChatsViewModel>().chatRooms[index]);
                        } else {
                          return const Text("No chats");
                        }
                      }
                    ),
                  ),
                )
              ]
            )
          ),
          SizedBox(
            child: Container(
              height: screenHeight,
              width: screenWidth * 0.7,
              color: Colors.blue[800],
              child: Visibility(
                visible: context.watch<ChatsViewModel>().chatViewVisible,
                child: _chatView(context, screenWidth, screenHeight),
              ),
            )
          )
        ]
      )
    );
  }

  Future _addChatView(BuildContext context, double screenWidth, double screenHeight) {
    TextEditingController usernameController = TextEditingController();
    return showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Add new chat"),
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
                if (usernameController.text.isEmpty) {
                  SnackBar snackBar = const SnackBar(content: Text("Please enter a username."), backgroundColor: Colors.red);
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                } else if (usernameController.text == FirebaseAuth.instance.currentUser!.displayName) {
                  SnackBar snackBar = const SnackBar(content: Text("You cannot add yourself."), backgroundColor: Colors.red);
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
                }
                else {
                  await context.read<ChatsViewModel>().addChatRoom(usernameController.text)
                  .then((statusCode) {
                    if (statusCode == 0) {
                      SnackBar snackBar = const SnackBar(content: Text("Chat created."), backgroundColor: Colors.green);
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      context.read<ChatsViewModel>().getChatRooms(FirebaseAuth.instance.currentUser!.displayName!);
                      Navigator.pop(context);
                    } else if (statusCode == -1) {
                      SnackBar snackBar = const SnackBar(content: Text("An error has occurred and the chat could not be created."), backgroundColor: Colors.red);
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else if (statusCode == -2) {
                      SnackBar snackBar = const SnackBar(content: Text("The user does not exist."), backgroundColor: Colors.red);
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    } else if (statusCode == -3) {
                      SnackBar snackBar = const SnackBar(content: Text("You are already in a chat with this user."), backgroundColor: Colors.red);
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      Navigator.pop(context);
                    }
                  });
                }
              },
            ),
          ]
        );
      }
    );
  }

  Widget _chatRoomItem(BuildContext context, ChatRoom chatRoom) {
    String usernameDisplay = "";
    if (FirebaseAuth.instance.currentUser?.displayName != null) {
      if (chatRoom.members[0] == FirebaseAuth.instance.currentUser!.displayName) {
        usernameDisplay = chatRoom.members[1];
      } else {
        usernameDisplay = chatRoom.members[0];
      }
    }
    return GestureDetector(
      onTap: () {
        context.read<ChatsViewModel>().setChatRoom(chatRoom);
        _scrollDown();
        if (kDebugMode) {
          print("Chat Room pressed: ${chatRoom.members[1]}");
        }
      },
      child: Container(
        decoration: const BoxDecoration(
          color: Colors.black12,
          border: Border(bottom: BorderSide(width: 1, color: Colors.grey)),
        ),
        child: ListTile(
          minTileHeight: 60,
          title: Text(usernameDisplay), // If not creator then its the other user.
        )
      ),
    );
  }

  Widget _chatView(BuildContext context, double screenWidth, double screenHeight) {
    return Column(
      children: <Widget>[
        Container(
          width: screenWidth * 0.7,
          height: 60,
          color: Colors.black26,
          child: Stack(
            children: <Widget>[
              const Positioned(
                top: 15,
                left: 20,
                child: Text("Chat", style: TextStyle(fontSize: 20, color: Colors.white, fontWeight: FontWeight.bold)),
              ),
              Positioned(
                top: 10,
                right: 5,
                child: PopupMenuButton(
                  icon: const Icon(Icons.more_vert, color: Colors.white),
                  itemBuilder: (context) => [
                    PopupMenuItem(
                      onTap: () {
                        showDialog(context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: const Text("Delete chat"),
                              content: const Text("Are you sure you want to delete this chat?"),
                              actions: [
                                TextButton(
                                  child: const Text("Cancel"),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                ),
                                TextButton(
                                  child: const Text("Delete"),
                                  onPressed: () {
                                    context.read<ChatsViewModel>().deleteChatRoom();
                                    Navigator.pop(context);
                                  },
                                ),
                              ],
                            );
                          }
                        );
                      },
                      child: const Text("Delete chat"),
                    )
                  ]
                )
              ),
            ],
          ),
        ),
        Expanded(
          child: Container(
            color: Colors.cyan[200],
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 10),
              child: StreamBuilder<QuerySnapshot>(
                stream: context.read<ChatsViewModel>().chatRoomMessages,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return ListView.builder(
                      itemCount: snapshot.data!.docs.length,
                      itemBuilder: (context, index) {
                        Message message = Message.fromMap(snapshot.data!.docs[index].data() as Map<String, dynamic>);
                        return _messageItem(context, message);
                      },
                    )
                  } else if (snapshot.hasError) {
                    return const Center(
                      child: Text("An error has occurred."),
                    );
                  } else if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator()
                    );
                  } else if (snapshot.connectionState == ConnectionState.none) {
                    return const Center(
                      child: Text("No Internet connection."),
                    );
                  } else if (snapshot.connectionState == ConnectionState.active) {
                    return const Center(
                      child: Text("The connection has been established."),
                    );
                  }
                  else {
                    return const Center(
                      child: Text("No messages yet."),
                    );
                  }
                }
              ),
            )
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.cyan[200]
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(5, 5, 5, 5),
            child: _inputFieldWithSend(context),
          )
        )
      ],
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
    return Expanded(
      child: Card(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(12, 12, 12, 5),
          child: Column(
            children: <Widget>[
              Align(
                alignment: Alignment.topLeft,
                child: Text(message.senderUsername, style: const TextStyle(fontWeight: FontWeight.bold)),
              ),
              Align(
                alignment: Alignment.centerLeft,
                child: Text(message.messageString),
              ),
              Align(
                alignment: Alignment.bottomRight,
                child: Text(time),
              )
            ],
          ),
        ),
      ),
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
                      context.read<ChatsViewModel>().sendMessage(text);
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
                  context.read<ChatsViewModel>().sendMessage(_messageController.text);
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
        _chatScrollController.animateTo(
        _chatScrollController.position.maxScrollExtent,
        duration: const Duration(milliseconds: 500),
        curve: Curves.ease
        );
      } catch (err) {
        if (kDebugMode) {
          print(err);
        }
      }
    }

}