import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamvortex/viewmodels/chats_vm.dart';
import 'package:teamvortex/viewmodels/nav_bar_vm.dart';
import 'package:teamvortex/viewmodels/project_feed_vm.dart';
import 'package:teamvortex/viewmodels/projects_vm.dart';
import 'package:teamvortex/viewmodels/settings_vm.dart';
import 'package:teamvortex/views/widgets/inputs.dart';

class SettingsView extends StatelessWidget {
  const SettingsView({super.key});
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Settings"),
        backgroundColor: Colors.blue,
        automaticallyImplyLeading: true,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return _settingsView(context, constraints.maxWidth, constraints.maxHeight);
        }
      ),
    );
  }
  
  Widget _settingsView(BuildContext context, double screenWidth, double screenHeight) {
    return Scaffold(
      body: Center(
        child: ListView(
          children: <Widget>[
            GestureDetector(
              onTap: () async {
                showDialog(
                  context: context,
                  builder: (context) {
                    TextEditingController confirmController = TextEditingController();
                    return AlertDialog(
                      title: const Text("Delete Account?"),
                      content: SizedBox(
                        height: 200,
                        child: Column(
                          children: <Widget>[
                            const Text("Are you sure you want to delete your account?\nThis action cannot be undone."),
                            const SizedBox(height: 20),
                            inputFieldWithLabel("Type DELETE to confirm:", controller: confirmController),
                            const SizedBox(height: 10),
                            errorMessage(context.watch<SettingsViewModel>().errorMessage)
                          ],
                        ),
                      ),
                      actions: <Widget>[
                        TextButton(
                          child: const Text("Cancel"),
                          onPressed: () {
                            Navigator.of(context).pop();
                            context.read<SettingsViewModel>().setError("");
                          },
                        ),
                        TextButton(
                          child: const Text("Delete"),
                          onPressed: () async {
                            if (confirmController.text != "DELETE") {
                              context.read<SettingsViewModel>().setError("The typed word doesn't match.");
                            }
                            else {
                              Navigator.of(context).pop();
                              context.read<SettingsViewModel>().setError("");
                              context.read<SettingsViewModel>().deleteAccount();
                              context.read<NavBarViewModel>().selectedIndex = 0;
                              context.read<ProjectsViewModel>().clearProjectsList();
                              context.read<ProjectFeedViewModel>().clearSelectedProject();
                              context.read<ChatsViewModel>().clearChatRoomsList();
                              context.read<ChatsViewModel>().chatViewVisible = false;
                              Navigator.of(context).popUntil((route) => route.isFirst);
                            }
                          },
                        ),
                      ],
                    );
                  }
                );
              },
              child: Container(
                width: screenWidth,
                height: 50,
                decoration: BoxDecoration(
                  border: const Border(bottom: BorderSide(width: 0.5, color: Colors.grey)),
                  color: Colors.cyan[200]
                ),
                child: const Padding(
                  padding: EdgeInsets.all(10),
                  child: Align(
                    alignment: Alignment.centerLeft,
                    child: Text("Delete Account")
                  )
                ),
              ),
            )
          ]
        )
      )
    );
  }
}