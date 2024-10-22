import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamvortex/viewmodels/projects_vm.dart';
import 'package:teamvortex/views/widgets/inputs.dart';

class ProjectsPage extends StatelessWidget {
  const ProjectsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return _projectsView(context, constraints.maxWidth, constraints.maxHeight);
        },
      ),
    );
  }

  Widget _projectsView(BuildContext context, double screenWidth, double screenHeight) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Projects"),
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: true,
      ),
      drawer: drawerOptions(context),
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: Stack(
          children: <Widget>[
            Center(
              child: ListView(
                children: <Widget>[
                  projectCard("Project 1", "Description 1", "Creator 1", DateTime.now().day, DateTime.now().month, DateTime.now().year),
                  projectCard("Project 2", "Description 2", "Creator 2", DateTime.now().day, DateTime.now().month, DateTime.now().year),
                  projectCard("Project 3", "Description 3", "Creator 3", DateTime.now().day, DateTime.now().month, DateTime.now().year),
                  projectCard("Project 4", "Description 4", "Creator 4", DateTime.now().day, DateTime.now().month, DateTime.now().year),
                  projectCard("Project 5", "Description 5", "Creator 5", DateTime.now().day, DateTime.now().month, DateTime.now().year),
                  projectCard("Project 6", "Description 6", "Creator 6", DateTime.now().day, DateTime.now().month, DateTime.now().year),
                  projectCard("Project 7", "Description 7", "Creator 7", DateTime.now().day, DateTime.now().month, DateTime.now().year),
                  projectCard("Project 8", "Description 8", "Creator 8", DateTime.now().day, DateTime.now().month, DateTime.now().year),
                ]
              ),
            ),
            Visibility(
              visible: context.watch<ProjectsViewModel>().showAddButton,
              child: Positioned(
                right: 10,
                bottom: 25,
                child: ElevatedButton(
                  onPressed: () {
                    
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(13),
                  ),
                  child: const Icon(Icons.add, size: 40),
                )
              )
            ),
          ]
        )
      ),
      bottomNavigationBar: navigationBar(context),
    );
  }

}