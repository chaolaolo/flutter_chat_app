import 'package:chat_app/auth/auht_gate.dart';
import 'package:chat_app/auth/login_or_register.dart';
import 'package:chat_app/firebase_options.dart';
import 'package:chat_app/screens/login_page.dart';
import 'package:chat_app/screens/register_page.dart';
import 'package:chat_app/themes/dark_mode.dart';
import 'package:chat_app/themes/light_mode.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: AuhtGate(),
      theme: darkMode,
    );
  }
}
