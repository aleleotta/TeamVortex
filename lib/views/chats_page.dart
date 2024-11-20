import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:teamvortex/models/entities/ChatRoom.dart';
import 'package:provider/provider.dart';
import 'package:teamvortex/viewmodels/chats_vm.dart';
import 'package:teamvortex/views/widgets/inputs.dart';

class ChatsView extends StatelessWidget {
  ChatsView({super.key});
  final ScrollController _chatRoomsScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return _messagesViewTabletOrPC(context, constraints.maxWidth, constraints.maxHeight);
        },
      ),
    );
  }

  Widget _messagesViewTabletOrPC(BuildContext context, double screenWidth, double screenHeight) {
    double firstViewWidth = screenWidth * 0.3;
    double secondViewWidth = screenWidth * 0.7;
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
                const SizedBox(height: 10),
                SizedBox(
                  height: 40,
                  width: firstViewWidth,
                  child: Stack(
                    children: <Widget>[
                      const Positioned(
                        left: 10,
                        top: 4,
                        child: Text("Chats", style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))
                      ),
                      Positioned(
                        right: 5,
                        bottom: 0,
                        child: IconButton(
                          icon: const Icon(Icons.add),
                          onPressed: () { // Add new chat
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
                          return _chatItem(context, context.watch<ChatsViewModel>().chatRooms[index]);
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
            )
          )
        ]
      )
    );
  }

  Widget _messagesViewPhone(BuildContext context, double screenWidth, double screenHeight) {
    return const Scaffold();
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

  Widget _chatItem(BuildContext context, ChatRoom chatRoom) {
    String usernameDisplay = "";
    if (chatRoom.members[0] == FirebaseAuth.instance.currentUser!.displayName) {
      usernameDisplay = chatRoom.members[1];
    } else {
      usernameDisplay = chatRoom.members[0];
    }
    return Container(
      decoration: const BoxDecoration(
        border: Border(top: BorderSide(width: 1, color: Colors.grey), bottom: BorderSide(width: 1, color: Colors.grey)),
      ),
      child: ListTile(
        minTileHeight: 60,
        title: Text(usernameDisplay), // If not creator then its the other user.
      )
    );
  }

}