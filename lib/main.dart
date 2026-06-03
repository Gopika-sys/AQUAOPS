import 'package:flutter/material.dart';
import 'splash_screen.dart'; // Ensure this matches your file path

void main() {
  // Ensures that binding is initialized before the app runs,
  // which is required for plugins like shared_preferences to work reliably.
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const AquaOpsApp());
}

class AquaOpsApp extends StatelessWidget {
  const AquaOpsApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'AQUAOPS',
      theme: ThemeData(
        brightness: Brightness.dark,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF020202),
          brightness: Brightness.dark,
        ),
        // Ensures your typography looks consistent across the app
        useMaterial3: true,
      ),
      // Launches your splash screen
      home: const SplashScreen(),
    );
  }
}