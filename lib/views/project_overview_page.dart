import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamvortex/viewmodels/project_overview_vm.dart';
import 'package:teamvortex/views/widgets/inputs.dart';

class ProjectOverviewPage extends StatelessWidget {
  const ProjectOverviewPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return _projectOverviewView(context, constraints.maxWidth, constraints.maxHeight);
        },
      ),
    );
  }
  
  Widget _projectOverviewView(BuildContext context, double screenWidth, double screenHeight) {
    return Scaffold(
      appBar: AppBar(
        title: Text(context.watch<ProjectOverviewViewModel>().selectedProject?.title ?? "Project Overview"),
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(5),
        child: Center(
          child: Column(
            children: <Widget>[
              Text("Overview", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25))
            ]
          )
        ),
      ),
    );
  }
  
}