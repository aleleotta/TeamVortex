import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamvortex/viewmodels/login_register_vm.dart';
import 'package:teamvortex/views/widgets/inputs.dart';

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
    return Scaffold(body: LayoutBuilder(
      builder: (context, constraints) {
        return _registerView(context, constraints.maxWidth, constraints.maxHeight);
      }
      )
    );
  }

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

  Widget _registerForm(BuildContext context, double screenWidth, double screenHeight) {
    return Container(
    padding: const EdgeInsets.all(16),
    //height: 430,
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
            inputField("First name", controller: _firstNameController, maxWidth: 250),
            const SizedBox(height: 20),
            inputField("Last names", controller: _lastNamesController, maxWidth: 250),
            const SizedBox(height: 20),
            inputField("Email", controller: _emailController, maxWidth: 250),
            const SizedBox(height: 20),
            inputField("Username", controller: _usernameController, maxWidth: 250),
            const SizedBox(height: 20),
            Stack(
              children: <Widget>[
                inputField("Password", maxWidth: 250, controller: _passwordController, isPassword: !context.watch<LoginRegisterViewModel>().passwordVisible),
                Positioned(
                  right: 0,
                  child: IconButton(
                  onPressed: () {
                    context.read<LoginRegisterViewModel>().passwordVisible = !context.read<LoginRegisterViewModel>().passwordVisible;
                  },
                  icon: context.watch<LoginRegisterViewModel>().passwordIcon)
                ),
              ]
            ),
            const SizedBox(height: 20),
            Stack(
              children: <Widget>[
                inputField("Repeat password", maxWidth: 250, controller: _repeatPasswordController, isPassword: !context.watch<LoginRegisterViewModel>().passwordVisible),
                Positioned(
                  right: 0,
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
                    Navigator.pushNamed(context, "/homeView");
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