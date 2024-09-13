import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  const WelcomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[800],
      body: LayoutBuilder(
        builder: (context, constraints) {
          return _welcomeView(context, constraints.maxWidth, constraints.maxHeight);
        }
      )
    );
  }

  Widget _welcomeView(BuildContext context, double screenWidth, double screenHeight) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              "Welcome to TeamVortex!\nWe're glad to have you here!",
              style: TextStyle(
                // First value: fontSize reset limit.
                // second value: fontSize value for exceeding limit.
                // third value: fontSize value.
                fontSize:
                MediaQuery.of(context).size.width > 840 ? 42
                :
                MediaQuery.of(context).size.width * 0.05,
                fontWeight: FontWeight.bold,
                fontStyle: FontStyle.italic,
                color: Colors.white,
                shadows: const [
                  Shadow(
                    blurRadius: 25.0,
                    color: Colors.black,
                    offset: Offset(5, 5),
                  ),
                ],
              ),
            ),
            SizedBox(height: screenHeight > 650 ? 400 : screenHeight > 480 ? 200 : 100),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/loginView");
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.cyan[100]),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
              child: const Text("Login",
                  style: TextStyle(fontSize: 20, color: Colors.black)),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                Navigator.pushNamed(context, "/registerView");
              },
              style: ButtonStyle(
                backgroundColor: WidgetStateProperty.all(Colors.cyan[100]),
                shape: WidgetStateProperty.all<RoundedRectangleBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5.0),
                  ),
                ),
              ),
              child: const Text(
                "Get Started",
                style: TextStyle(fontSize: 20, color: Colors.black)
              ),
            ),
          ],
        ),
      ),
    );
  }

}