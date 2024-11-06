import 'package:flutter/material.dart';
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
            child: Container(
              color: Colors.yellow,
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