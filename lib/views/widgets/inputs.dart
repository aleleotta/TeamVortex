import 'package:flutter/material.dart';
import 'package:teamvortex/models/entities/Project.dart';

Widget inputField(String? labelName, {bool isPassword = false, TextEditingController? controller, double maxWidth = 200}) {
  return SizedBox(
    width: maxWidth,
    child: Center(
      child: TextField(
        controller: controller,
        decoration: InputDecoration(
          labelText: labelName,
          border: const OutlineInputBorder(),
        ),
        obscureText: isPassword,
      ),
    )
  );
}

Text errorMessage(String message) {
  return Text(
    message,
    style: const TextStyle(
      color: Colors.red,
      fontWeight: FontWeight.bold
    ),
  );
}

Drawer drawerOptions(BuildContext context) {
  return Drawer(
    child: ListView(
      children: [
        ListTile(
          title: const Text("Item 1"),
          onTap: () {
            // Handle item 1 tap
          },
        ),
        ListTile(
          title: const Text("Item 2"),
          onTap: () {
            // Handle item 2 tap
          },
        ),
        ListTile(
          title: const Text("Logout"),
          onTap: () {
            Navigator.pushReplacementNamed(context, "/welcomeView");
          },
        ),
      ],
    ),
  );
}

NavigationBar navigationBar(BuildContext context) {
  return NavigationBar(
    destinations: const [
      NavigationDestination(
        icon: Icon(Icons.account_tree_rounded),
        label: "Projects",
      ),
      NavigationDestination(
        icon: Icon(Icons.message),
        label: "Chats",
      ),
    ],
    onDestinationSelected: (int index) {
      if (index == 0) {
        Navigator.pushReplacementNamed(context, "/projectsView");
      } /*else if (index == 1) {
        Navigator.pushReplacementNamed(context, "/chatsView");
      }*/
    },
  );
}

Widget projectCard(String title, String description, String creatorRef, int day, int month, int year) {
  return SizedBox(
    height: 120,
    child: Card(
      color: Colors.grey[350],
      elevation: 5,
      child: Stack(
        children: <Positioned>[
          Positioned(
            top: 10,
            left: 10,
            child: Text(
              title,
              style: const TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.bold
              ),
            ),
          ),
          Positioned(
            top: 55,
            left: 10,
            child: Text(
              description
            ),
          ),
          Positioned(
            top: 10,
            right: 10,
            child: Row(
              children: [
                const Text(
                  "Created by:",
                  style: TextStyle(
                    fontStyle: FontStyle.italic
                  )
                ),
                const SizedBox(width: 5),
                Text(
                  creatorRef,
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                  ),
                )
              ]
            ),
          ),
          Positioned(
            bottom: 10,
            right: 10,
            child: Text(
              "$day/$month/$year"
            ),
          ),
        ],
      )
    ),
  );
}