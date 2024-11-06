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
      body: const Center(
        child: Text("Project Notes"),
      ),
      bottomNavigationBar: navigationBarInsideProject(context),
    );
  }
}