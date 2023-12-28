import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';

import 'welcome.dart';
import 'firebase_options.dart';

/// Main app code
void main() async {
  // Initialize flutter
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Start the app
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'AsyikAja',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        fontFamily: "Alata",
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 255, 199, 0)),
        useMaterial3: true,
      ),
      /// Load the welcome page
      home: const WelcomePage(),
    );
  }
}
