import 'package:flutter/material.dart';
import 'package:locket/features/splash/screens/splash_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const LocketPlatiumApp());
}

class LocketPlatiumApp extends StatelessWidget {
  const LocketPlatiumApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'LocketPlatium',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF0A0A14),
        colorScheme: const ColorScheme.dark(
          primary: Color(0xFF7F77DD),
          secondary: Color(0xFFFFB800),
          surface: Color(0xFF13132A),
        ),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
