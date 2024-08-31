import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: true,
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            ListTile(
              title: const Text("Item 1"),
              onTap: () {
                // Handle item 1 tap
              },
            ),
            ListTile(
              title: const Text("Item 2"),
              onTap: () {
                // Handle item 2 tap
              },
            ),
          ],
        ),
      ),
      body: const Center(
        child: Text("Home Page"),
      ),
    );
  }
}