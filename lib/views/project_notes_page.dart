import 'package:flutter/material.dart';
import 'package:teamvortex/views/widgets/inputs.dart';

class ProjectNotesPage extends StatelessWidget {
  ProjectNotesPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return _projectNotesView(context, constraints.maxWidth, constraints.maxHeight);
        },
      ),
    );
  }

  Widget _projectNotesView(BuildContext context, double screenWidth, double screenHeight) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Project Notes"),
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: Stack(
          children: <Widget>[
            const Center(
              // Add project notes here
            ),
            Positioned(
              right: 10,
              bottom: 25,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/createProjectView');
                },
                style: ElevatedButton.styleFrom(
                  shape: const CircleBorder(),
                  padding: const EdgeInsets.all(13),
                ),
                child: const Icon(Icons.add, size: 40),
              )
            )
          ]
        )
      ),
      bottomNavigationBar: navigationBarInsideProject(context),
    );
  }
}