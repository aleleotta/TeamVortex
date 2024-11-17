import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamvortex/viewmodels/project_feed_vm.dart';
import 'package:teamvortex/viewmodels/project_notes_vm.dart';
import 'package:teamvortex/views/widgets/inputs.dart';
import 'package:teamvortex/views/widgets/note_templates.dart';

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
                        if (index >= context.watch<ProjectNotesViewModel>().notesList.length) {
                          return projectNoteCard(context, note: context.watch<ProjectNotesViewModel>().notesList[index-1]);
                        }
                        return projectNoteCard(context, note: context.watch<ProjectNotesViewModel>().notesList[index]);
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