import 'package:flutter/material.dart';
import 'package:teamvortex/models/entities/ChatRoom.dart';
import 'package:provider/provider.dart';
import 'package:teamvortex/viewmodels/chats_vm.dart';
import 'package:teamvortex/views/widgets/inputs.dart';

class ChatsView extends StatelessWidget {
  const ChatsView({super.key});

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
                          onPressed: () {}, // Add new chat
                        )
                      )
                    ]
                  ),
                ),
                const Divider(),
                const SizedBox(height: 10),
                SizedBox(
                  height: screenHeight - 202,
                  width: firstViewWidth,
                  child: ListView.builder(
                    itemCount: context.watch<ChatsViewModel>().chatRooms.length,
                    itemBuilder: (context, index) {
                      if (context.watch<ChatsViewModel>().chatRooms.isNotEmpty)
                      {
                        return ListTile(
                          title: Text(context.watch<ChatsViewModel>().chatRooms[index].getTitle)
                        );
                      } else {
                        return const Text("No chats");
                      }
                    }
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

}