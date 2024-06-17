import 'package:flutter/material.dart';
import 'package:tomorrow_app/firebase_options.dart';
import 'package:tomorrow_app/pages/auth_page.dart';
import 'package:firebase_core/firebase_core.dart';
import 'pages/settings_screen.dart';


void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
    '/settings': (context) => SettingsScreen(), 
    '/auth': (context) => AuthPage(),
  },
      debugShowCheckedModeBanner: false,
      home: AuthPage(),
    );
  }
}