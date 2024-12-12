import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamvortex/frontend/viewmodels/project_feed_vm.dart';
import 'package:teamvortex/frontend/viewmodels/project_notes_vm.dart';
import 'package:teamvortex/frontend/views/widgets/inputs.dart';
import 'package:teamvortex/frontend/views/widgets/note_templates.dart';

class ProjectNotesPage extends StatelessWidget {
  const ProjectNotesPage({super.key});

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

  /// Builds the Project Notes view with a list of project notes and a button to add new notes.
  ///
  /// The view is structured with an AppBar, a ListView displaying project notes,
  /// and a conditional widget for creating new notes. It also includes a button
  /// to add new notes which is visible based on the state in the ProjectNotesViewModel.
  ///
  /// Parameters:
  /// - `context`: The BuildContext to access the widget tree.
  /// - `screenWidth`: The width of the screen for layout calculations.
  /// - `screenHeight`: The height of the screen for layout calculations.
  ///
  /// Returns a Scaffold widget containing the project notes and associated controls.
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
            Center(
              child: Column(
                children: <Widget>[
                  Expanded(
                    child: ListView.builder(
                      itemCount: context.watch<ProjectNotesViewModel>().notesList.length,
                      itemBuilder: (context, index) {
                        try {
                          return projectNoteCard(context, note: context.watch<ProjectNotesViewModel>().notesList[index]);
                        }
                        catch (err) {
                          return null;
                        }
                      },
                    ),
                  ),
                  Visibility(
                    visible: context.watch<ProjectNotesViewModel>().isCreating,
                    child: projectNoteCardCreate(context, context.read<ProjectFeedViewModel>().selectedProject!.docId),
                  )
                ]
              )
            ),
            Visibility(
              visible: context.watch<ProjectNotesViewModel>().addButtonVisible,
              child: Positioned(
                right: 10,
                bottom: 25,
                child: ElevatedButton(
                  onPressed: () {
                    context.read<ProjectNotesViewModel>().addButtonPressed();
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
      bottomNavigationBar: navigationBarInsideProject(context),
    );
  }
}