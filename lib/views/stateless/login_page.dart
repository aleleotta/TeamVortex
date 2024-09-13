import 'package:flutter/material.dart';
import 'package:teamvortex/views/widgets/inputs.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

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
        body: Center(
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
                inputField("Username/Email"),
                const SizedBox(height: 20),
                inputField("Password", isPassword: true),
                const SizedBox(height: 30),
                ElevatedButton(
                  onPressed: () {
                    Navigator.pushNamed(context, "/homeView");
                  },
                  style: ButtonStyle(
                    backgroundColor: WidgetStateProperty.all(Colors.blue[800]),
                    shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                      RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5.0),
                      ),
                    ),
                  ),
                  child: const Text("Login",
                      style: TextStyle(fontSize: 20, color: Colors.white)),
                )
              ],
            ),
          ),
        )
      );
  }
}
