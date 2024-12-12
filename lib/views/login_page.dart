import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamvortex/viewmodels/login_register_vm.dart';
import 'package:teamvortex/viewmodels/projects_vm.dart';
import 'package:teamvortex/views/widgets/inputs.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final TextEditingController _usernameEmailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(builder: (context, constraints) {
        return _loginView(context, constraints.maxWidth, constraints.maxHeight);
    }
    ));
  }

  /// This widget represents the login view of the application.
  /// 
  /// This view features a text field for the user's username or email, a password field, an error message field,
  /// and a submit button. The user types their username or email and password into the respective text fields,
  /// and upon submitting, the application checks the information against the database. If the information is
  /// correct, the user is logged in and the application navigates to the projects view. If the information is
  /// incorrect, an error message is displayed to the user.
  Widget _loginView(BuildContext context, double screenWidth, double screenHeight) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Center(
          child: Container(
            padding: const EdgeInsets.all(16),
            width: 350,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.cyan[200],
            ),
            child: SingleChildScrollView(
              child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text("Login",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)
                ),
                const SizedBox(height: 40),
                inputFieldWithHoveringLabel("Username/Email", controller: _usernameEmailController, maxWidth: 250),
                const SizedBox(height: 20),
                Stack(
              children: <Widget>[
                inputFieldWithHoveringLabel("Password", maxWidth: 250, controller: _passwordController, isPassword: !context.watch<LoginRegisterViewModel>().passwordVisible),
                Positioned(
                  right: 2,
                  top: 5,
                  child: IconButton(
                  onPressed: () {
                    context.read<LoginRegisterViewModel>().passwordVisible = !context.read<LoginRegisterViewModel>().passwordVisible;
                  },
                  icon: context.watch<LoginRegisterViewModel>().passwordIcon)
                ),
              ]
            ),
                const SizedBox(height: 20),
                errorMessage(context.watch<LoginRegisterViewModel>().errorString), //The error string value comes from the provider.
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () async {
                    await context.read<LoginRegisterViewModel>().checkInfoLogin(
                      _usernameEmailController.text, _passwordController.text
                    ).then((resultCode) {
                      if (resultCode == 0) {
                        context.read<ProjectsViewModel>().getProjects();
                        Navigator.pushNamed(context, "/projectsView");
                      }
                    });
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.blue[800]),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                  child: const Text(
                    "Submit",
                    style: TextStyle(fontSize: 20, color: Colors.white)),
                )
              ],
            )
            ),
          ),
        ),
        )
      );
  }
}
