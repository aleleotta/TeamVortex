import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamvortex/firebase_options.dart';
import 'package:teamvortex/frontend/viewmodels/chats_vm.dart';
import 'package:teamvortex/frontend/viewmodels/create_project_vm.dart';
import 'package:teamvortex/frontend/viewmodels/login_register_vm.dart';
import 'package:teamvortex/frontend/viewmodels/nav_bar_vm.dart';
import 'package:teamvortex/frontend/viewmodels/project_feed_vm.dart';
import 'package:teamvortex/frontend/viewmodels/project_notes_vm.dart';
import 'package:teamvortex/frontend/viewmodels/projects_vm.dart';
import 'package:teamvortex/frontend/viewmodels/settings_vm.dart';
import 'package:teamvortex/frontend/views/create_project_page.dart';
import 'package:teamvortex/frontend/views/chats_page.dart';
import 'package:teamvortex/frontend/views/project_feed_page.dart';
import 'package:teamvortex/frontend/views/project_notes_page.dart';
import 'package:teamvortex/frontend/views/projects_page.dart';
import 'package:teamvortex/frontend/views/login_page.dart';
import 'package:teamvortex/frontend/views/register_page.dart';
import 'package:teamvortex/frontend/views/settings_page.dart';
import 'package:teamvortex/frontend/views/welcome_page.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

// This widget is the root of your application.
class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        // ViewModels
        ChangeNotifierProvider(create: (context) => LoginRegisterViewModel()),
        ChangeNotifierProvider(create: (context) => ProjectsViewModel()),
        ChangeNotifierProvider(create: (context) => ChatsViewModel()),
        ChangeNotifierProvider(create: (context) => NavBarViewModel()),
        ChangeNotifierProvider(create: (context) => CreateProjectViewModel()),
        ChangeNotifierProvider(create: (context) => ProjectFeedViewModel()),
        ChangeNotifierProvider(create: (context) => ProjectNotesViewModel()),
        ChangeNotifierProvider(create: (context) => SettingsViewModel()),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const WelcomePage(),
        
        // View router for navigation
        routes: {
          "/welcomeView": (context) => const WelcomePage(),
          "/projectsView": (context) => const ProjectsPage(),
          "/createProjectView": (context) => CreateProjectPage(),
          "/projectFeedView": (context) => ProjectFeedPage(),
          "/projectNotesView": (context) => const ProjectNotesPage(),
          "/settingsView": (context) => const SettingsView(),
          "/loginView": (context) => LoginPage(),
          "/registerView": (context) => RegisterPage(),
          "/chatsView": (context) => ChatsView(),
        },

      )
    );
  }
}