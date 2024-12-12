import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamvortex/frontend/viewmodels/create_project_vm.dart';
import 'package:teamvortex/frontend/viewmodels/projects_vm.dart';
import 'package:teamvortex/frontend/views/widgets/inputs.dart';

class CreateProjectPage extends StatelessWidget {
  CreateProjectPage({super.key});
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return _createProjectView(context, constraints.maxWidth, constraints.maxHeight);
        },
      ),
    );
  }
  
/// Creates a view for adding a new project with input fields for title and 
/// description, and a button to submit the project creation request.
/// 
/// The view is presented with a centered layout, containing a form with 
/// labeled input fields and displays an error message if project creation 
/// fails. Upon successful creation, it navigates back to the previous screen.
/// 
/// Parameters:
/// - `context`: BuildContext to access the widget tree.
/// - `screenWidth`: The width of the screen.
/// - `screenHeight`: The height of the screen.
/// 
/// Returns a Scaffold widget containing the project creation form.
  Widget _createProjectView(BuildContext context, double screenWidth, double screenHeight) {
    double fieldLength = 300;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: true,
      ),
      body: Container(
        color: Colors.cyan[100],
        child: Center(
          child: Container(
            color: Colors.cyan[200],
            width: 500,
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  const Text("Add Project", style: TextStyle(fontWeight: FontWeight.bold, fontSize: 25)),
                  const SizedBox(height: 30),
                  inputFieldWithLabel("Title:", maxWidth: fieldLength, controller: _titleController),
                  const SizedBox(height: 20),
                  inputFieldWithLabel("Description:", maxWidth: fieldLength, maxLines: 3, controller: _descriptionController),
                  const SizedBox(height: 20),
                  errorMessage(context.watch<CreateProjectViewModel>().errorMessage),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: () async {
                      await context.read<CreateProjectViewModel>().createNewProject(_titleController.text, _descriptionController.text)
                      .then((resultCode) {
                        if (resultCode == 0) {
                          context.read<ProjectsViewModel>().getProjects();
                          Navigator.pop(context);
                        }
                      });
                    },
                    child: const Text("Create"),
                  ),
                ],
              ),
            ),
          ),
        ),
      )
    );
  }
}