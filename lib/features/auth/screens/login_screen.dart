import 'package:flutter/material.dart';

import '../../../routes/app_routes.dart';
import '../widgets/auth_button.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A14),
      body: Stack(
        children: [
          // Ambient dark background gradient
          Positioned.fill(
            child: Container(
              decoration: const BoxDecoration(
                gradient: RadialGradient(
                  center: Alignment(0, -0.4),
                  radius: 1.2,
                  colors: [Color(0xFF1E1744), Color(0xFF0A0A14)],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 18),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Menu Action Buttons (No Forms per spec)
                  AuthButton(
                    label: 'Đăng ký',
                    isPrimary: true,
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.register);
                    },
                  ),
                  const SizedBox(height: 16),
                  AuthButton(
                    label: 'Đăng nhập',
                    isPrimary: false,
                    onPressed: () {
                      Navigator.pushNamed(context, AppRoutes.signIn);
                    },
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
