import 'package:flutter/material.dart';
import 'package:figgy_app/screens/onboarding_screen.dart';
import 'package:figgy_app/screens/main_wrapper.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  final prefs = await SharedPreferences.getInstance();
  final bool hasOnboarded = false; // Always show onboarding for hackathon demo
  
  runApp(MyApp(initialHome: const OnboardingScreen()));
}

class MyApp extends StatelessWidget {
  final Widget initialHome;
  const MyApp({super.key, required this.initialHome});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Figgy',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xFFFF6B35)),
        useMaterial3: true,
      ),
      home: initialHome,
    );
  }
}
