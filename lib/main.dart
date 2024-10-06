import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:teamvortex/firebase_options.dart';
import 'package:teamvortex/models/services/firebase_auth_services.dart';
import 'package:teamvortex/viewmodels/login_register_vm.dart';
import 'package:teamvortex/views/home_page.dart';
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
      ],
      child: MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const WelcomePage(),
      
      // View router for navigation
      routes: {
        "/welcomeView": (context) => const WelcomePage(),
        "/homeView": (context) => const HomePage(),
        "/loginView": (context) => LoginPage(),
        "/registerView": (context) => RegisterPage(),
      },

      )
    );
  }
}