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

  /// This widget is the main screen for viewing and creating projects.
  ///
  /// This widget is composed of a [Scaffold] with an [AppBar] containing the title
  /// "Projects", a [drawerOptions] (which is a [Drawer] containing a list of the
  /// user's projects), and a [body] containing a [ListView] of [projectCard]s.
  ///
  /// The [ListView] is populated with the projects from the user's
  /// [ProjectsViewModel]. The [projectCard]s are stacked on top of the [ListView]
  /// and are positioned in the center of the screen. Each [projectCard] has an
  /// [onTap] callback that navigates to the project's feed when tapped.
  ///
  /// Additionally, there is an [ElevatedButton] positioned at the bottom right of
  /// the screen that, when pressed, navigates to the create project view.
  ///
  /// Finally, there is a [navigationBar] at the bottom of the screen that allows
  /// the user to navigate to other views.
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
              child: ListView.builder(
                itemCount: context.watch<ProjectsViewModel>().projects.length,
                itemBuilder: (context, index) {
                  // OutOfRange conditional
                  if (index >= context.watch<ProjectsViewModel>().projects.length) {
                    return projectCard(context, project: context.watch<ProjectsViewModel>().projects[index-1]);
                  }
                  return projectCard(context, project: context.watch<ProjectsViewModel>().projects[index]);
                }
              ),
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
      bottomNavigationBar: navigationBar(context),
    );
  }

}