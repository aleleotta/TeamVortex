import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamvortex/models/entities/Project.dart';
import 'package:teamvortex/models/services/firebase_auth_services.dart';
import 'package:teamvortex/viewmodels/nav_bar_vm.dart';
import 'package:teamvortex/viewmodels/project_overview_vm.dart';
import 'package:teamvortex/viewmodels/projects_vm.dart';

Widget inputFieldWithHoveringLabel(String? labelName, {bool isPassword = false,
TextEditingController? controller, double maxWidth = 200, int maxLines = 1}) {
  return SizedBox(
    width: maxWidth,
    child: Center(
      child: TextField(
        maxLines: maxLines,
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

Widget inputFieldWithLabel(String labelName, {bool isPassword = false,
TextEditingController? controller, double maxWidth = 200, int maxLines = 1}) {
  return Column(
    children: <Widget>[
      Text(labelName, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 17)),
      const SizedBox(height: 5),
      SizedBox(
        width: maxWidth,
        child: TextField(
          maxLines: maxLines,
          obscureText: isPassword,
          controller: controller,
          decoration: const InputDecoration(
            border: OutlineInputBorder(),
          ),
        )
      )
    ]
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
            FirebaseAuthServices().signOut();
            context.read<NavBarViewModel>().selectedIndex = 0;
            context.read<ProjectsViewModel>().clearProjectsList();
            context.read<ProjectOverviewViewModel>().clearSelectedProject();
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

Widget projectCard(BuildContext context, {required Project project}) {
  int day = project.creationDate.day;
  int month = project.creationDate.month;
  int year = project.creationDate.year;
  return Column(
    children: <SizedBox>[
      SizedBox(
        height: 150,
        child: GestureDetector(
          onTap: () {
            context.read<ProjectOverviewViewModel>().setSelectedProject(project);
            Navigator.pushNamed(context, "/projectOverviewView");
          },
          child: Card(
            color: Colors.grey[350],
            elevation: 5,
            child: Stack(
              children: <Positioned>[
                Positioned(
                  top: 10,
                  left: 10,
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Text(
                      project.title,
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
                    width: MediaQuery.of(context).size.width * 0.6,
                    child: Text(
                      project.description
                    ),
                  )
                ),
                Positioned(
                  top: 10,
                  right: 10,
                  child: Column(
                    children: [
                      const Text(
                        "Created by:",
                        style: TextStyle(
                          fontStyle: FontStyle.italic
                        )
                      ),
                      const SizedBox(width: 5),
                      Text(
                        project.creatorUsername,
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
          )
        ),
      ),
      const SizedBox(height: 10)
    ]
  );
}