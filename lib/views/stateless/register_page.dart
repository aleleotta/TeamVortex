import 'package:flutter/material.dart';
import 'package:teamvortex/views/widgets/inputs.dart';

class RegisterPage extends StatelessWidget {
  RegisterPage({super.key});
  final ScrollController _scrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: LayoutBuilder(builder: (context, constraints) {
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
            child: IconButton(
            onPressed: () {
              _scrollController.animateTo(
                  _scrollController.position.maxScrollExtent,
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.fastOutSlowIn
              );
            },
            icon: const Icon(Icons.arrow_downward_rounded, size: 35),
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
    // Try using a Stack here.
    padding: const EdgeInsets.all(16),
    height: 290,
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
            const Text("Register",
                style: TextStyle(
                    fontSize: 30, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            inputField("Email"),
            const SizedBox(height: 20),
            inputField("Username"),
            const SizedBox(height: 20),
            inputField("Password"),
            const SizedBox(height: 20),
            inputField("Repeat password"),
            const SizedBox(height: 10),
            errorMessage("Passwords don't match"),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/homeView"); //This will change soon. Backend will be added.
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
              child: const Text("Login",
                  style: TextStyle(
                      fontSize: 20, color: Colors.white)),
            )
          ],
        )
      )
    );
  }
}