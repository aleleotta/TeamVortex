import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamvortex/models/entities/Project.dart';
import 'package:teamvortex/viewmodels/nav_bar_vm.dart';

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
    width: MediaQuery.of(context).size.width * 0.38,
    child: ListView(
      children: [
        ListTile(
          title: const Text("Settings"),
          onTap: () {
          },
        ),
        ListTile(
          title: const Text("Logout"),
          onTap: () {
            // User in auth should be logged out (null).
            context.read<NavBarViewModel>().selectedIndex = 0;
            Navigator.pushReplacementNamed(context, "/welcomeView");
          },
        ),
      ],
    ),
  );
}

NavigationBar navigationBar(BuildContext context) {
  return NavigationBar(
    backgroundColor: Colors.blue,
    selectedIndex: context.watch<NavBarViewModel>().selectedIndex,
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
      } else if (index == 1) {
        Navigator.pushReplacementNamed(context, "/chatsView");
      }
      context.read<NavBarViewModel>().selectedIndex = index;
    },
  );
}

Widget projectCard(String title, String description, String creatorRef, int day, int month, int year) {
  return Column(
    children: <SizedBox>[
      SizedBox(
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
      ),
      const SizedBox(height: 10)
    ]
  );
}