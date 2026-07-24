import 'package:flutter/material.dart';
import 'package:locket/features/camera/screens/camera_screen.dart';

class MainShell extends StatelessWidget {
  const MainShell({super.key});

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: Color(0xFF0A0A14),
      body: CameraScreen(),
    );
  }
}
