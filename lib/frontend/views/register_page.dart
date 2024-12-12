import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamvortex/frontend/viewmodels/login_register_vm.dart';
import 'package:teamvortex/frontend/views/widgets/inputs.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});
  final ScrollController _scrollController = ScrollController();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNamesController = TextEditingController();
  final TextEditingController _usernameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _repeatPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return _registerView(context, constraints.maxWidth, constraints.maxHeight);
        }
      )
    );
  }

  /// Creates a view for registering a new user with input fields for first name, last names, username, 
  /// email, password and repeat password, and a button to submit the registration request.
  /// 
  /// The view is presented with a centered layout, containing a form with labeled input fields and 
  /// displays an error message if registration fails. Upon successful registration, it navigates back to the 
  /// previous screen.
  /// 
  /// Parameters:
  /// - `context`: BuildContext to access the widget tree.
  /// - `screenWidth`: The width of the screen.
  /// - `screenHeight`: The height of the screen.
  /// 
  /// Returns a Scaffold widget containing the registration form.
  Widget _registerView(BuildContext context, double screenWidth, double screenHeight) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Center(
          child: Stack(children: <Widget>[
            _registerForm(context, screenWidth, screenHeight),
            Positioned(
              bottom: 0,
              left: 0,
              child: Visibility(
                visible: false,
                child: IconButton( // Disabled
                  onPressed: () {
                    _scrollController.animateTo(
                        _scrollController.position.maxScrollExtent,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.fastOutSlowIn
                    );
                  },
                  icon: const Icon(Icons.arrow_downward_rounded, size: 35),
                ),
              )
            ),
            ]
          ),
        ),
      )
    );
  }

  /// Creates a registration form with input fields for user details and a submit button.
  /// 
  /// This form includes input fields for first name, last names, email, username, password,
  /// and repeat password, with each field having a hovering label for guidance. The password
  /// and repeat password fields include a toggle icon to show or hide the password.
  /// 
  /// An error message is displayed if there is an issue with registration input, and a submit
  /// button is provided to initiate the registration process. Upon successful registration,
  /// the user is navigated to the projects view.
  /// 
  /// Parameters:
  /// - `context`: BuildContext to access the widget tree.
  /// - `screenWidth`: The width of the screen for layout calculations.
  /// - `screenHeight`: The height of the screen for layout calculations.
  /// 
  /// Returns a Container widget containing the registration form.
  Widget _registerForm(BuildContext context, double screenWidth, double screenHeight) {
    return Container(
    padding: const EdgeInsets.all(16),
    width: 350,
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: Colors.cyan[200],
    ),
    child: SingleChildScrollView(
        controller: _scrollController,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text(
              "Register",
              style: TextStyle(
                fontSize: 30, fontWeight: FontWeight.bold
              )
            ),
            const SizedBox(height: 20),
            inputFieldWithHoveringLabel("First name", controller: _firstNameController, maxWidth: 250),
            const SizedBox(height: 20),
            inputFieldWithHoveringLabel("Last names", controller: _lastNamesController, maxWidth: 250),
            const SizedBox(height: 20),
            inputFieldWithHoveringLabel("Email", controller: _emailController, maxWidth: 250),
            const SizedBox(height: 20),
            inputFieldWithHoveringLabel("Username", controller: _usernameController, maxWidth: 250),
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
                    icon: context.watch<LoginRegisterViewModel>().passwordIcon
                  )
                ),
              ]
            ),
            const SizedBox(height: 20),
            Stack(
              children: <Widget>[
                inputFieldWithHoveringLabel("Repeat password", maxWidth: 250, controller: _repeatPasswordController, isPassword: !context.watch<LoginRegisterViewModel>().passwordVisible),
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
            const SizedBox(height: 10),
            errorMessage(context.watch<LoginRegisterViewModel>().errorString), //The error string value comes from the provider.
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                await context.read<LoginRegisterViewModel>().checkInfoRegister(
                  _firstNameController.text, _lastNamesController.text, _emailController.text, _usernameController.text, _passwordController.text, _repeatPasswordController.text
                ).then((resultCode) {
                  if (resultCode == 0) {
                    Navigator.pushNamed(context, "/projectsView");
                  }
                });
              },
              style: ButtonStyle(
                backgroundColor:
                    WidgetStateProperty.all(Colors.blue[800]),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
              child: const Text(
                "Submit",
                style: TextStyle(fontSize: 20, color: Colors.white)
              ),
            )
          ],
        )
      )
    );
  }
}