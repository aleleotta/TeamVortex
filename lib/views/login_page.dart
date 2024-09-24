import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamvortex/viewmodels/login_register_vm.dart';
import 'package:teamvortex/views/widgets/inputs.dart';

class LoginPage extends StatelessWidget {
  LoginPage({super.key});
  final TextEditingController _usernameEmailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LayoutBuilder(builder: (context, constraints) {
      return _loginView(context, constraints.maxWidth, constraints.maxHeight);
    }));
  }

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
            height: 320,
            width: 280,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(10),
              color: Colors.cyan[200],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Text("Login",
                style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)
                ),
                const SizedBox(height: 20),
                inputField("Username/Email", controller: _usernameEmailController),
                const SizedBox(height: 20),
                Stack(
              children: <Widget>[
                inputField("Password", controller: _passwordController, isPassword: !context.watch<LoginRegisterViewModel>().passwordVisible),
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
                  onPressed: () {
                    Navigator.pushNamed(context, "/homeView"); //This will change soon. Backend will be added.
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
            ),
          ),
        ),
        )
      );
  }
}
