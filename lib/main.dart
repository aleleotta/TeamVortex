import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamvortex/firebase_options.dart';
import 'package:teamvortex/viewmodels/chats_vm.dart';
import 'package:teamvortex/viewmodels/create_project_vm.dart';
import 'package:teamvortex/viewmodels/login_register_vm.dart';
import 'package:teamvortex/viewmodels/nav_bar_vm.dart';
import 'package:teamvortex/viewmodels/project_overview_vm.dart';
import 'package:teamvortex/viewmodels/projects_vm.dart';
import 'package:teamvortex/views/create_project_page.dart';
import 'package:teamvortex/views/chats_page.dart';
import 'package:teamvortex/views/project_overview_page.dart';
import 'package:teamvortex/views/projects_page.dart';
import 'package:teamvortex/views/login_page.dart';
import 'package:teamvortex/views/register_page.dart';
import 'package:teamvortex/views/welcome_page.dart';

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
        ChangeNotifierProvider(create: (context) => LoginRegisterViewModel()),
        ChangeNotifierProvider(create: (context) => ProjectsViewModel()),
        ChangeNotifierProvider(create: (context) => ChatsViewModel()),
        ChangeNotifierProvider(create: (context) => NavBarViewModel()),
        ChangeNotifierProvider(create: (context) => CreateProjectViewModel()),
        ChangeNotifierProvider(create: (context) => ProjectOverviewViewModel()),
      ],
      child: MaterialApp(
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
        "/projectOverviewView": (context) => ProjectOverviewPage(),
        "/loginView": (context) => LoginPage(),
        "/registerView": (context) => RegisterPage(),
        "/chatsView": (context) => ChatsView(),
      },

      )
    );
  }
}