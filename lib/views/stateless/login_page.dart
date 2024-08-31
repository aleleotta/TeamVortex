import 'package:flutter/material.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: LayoutBuilder(
        builder: (context, constraints) {
          return _loginView(context, constraints.maxWidth, constraints.maxHeight);
        }
      )
    );
  }

  Widget _loginView(BuildContext context, double screenWidth, double screenHeight) {
    return Scaffold(
      appBar: AppBar(
        //title: const Text("Login"),
        centerTitle: true,
        backgroundColor: Colors.blue,
      ),
      body: Center(
        child: Container(
          padding: const EdgeInsets.all(16),
          height: 280,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
            color: Colors.cyan[200],
          ),
          child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text("Login", style: TextStyle(fontSize: 30, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            const SizedBox(
              width: 200,
              child: Center(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: "Username/Email",
                    border: OutlineInputBorder(),
                  ),
                ),
              )
            ),
            const SizedBox(height: 20),
            const SizedBox(
              width: 200,
              child: Center(
                child: TextField(
                  decoration: InputDecoration(
                    labelText: "Password",
                    border: OutlineInputBorder(),
                  ),
                  obscureText: true,
                ),
              )
            ),
            const SizedBox(height: 30),
            ElevatedButton(
            onPressed: () {
              Navigator.pushNamed(context, "/registerView");
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
              "Login",
              style: TextStyle(fontSize: 20, color: Colors.white)
            ),
          )
          ],
        ),
        ),
      )
    );
  }
  
}