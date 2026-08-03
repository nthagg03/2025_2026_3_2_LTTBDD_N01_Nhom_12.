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
                  colors: [
                    Color(0xFF1E1744),
                    Color(0xFF0A0A14),
                  ],
                ),
              ),
            ),
          ),

          SafeArea(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 28),
              child: Column(
                children: [
                  const Spacer(flex: 2),

                  // Locket Gold Logo Icon
                  Container(
                    width: 96,
                    height: 96,
                    decoration: BoxDecoration(
                      color: const Color(0xFF13132A),
                      borderRadius: BorderRadius.circular(28),
                      border: Border.all(
                        color: const Color(0xFFFFB800).withValues(alpha: 0.6),
                        width: 2,
                      ),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFFFB800).withValues(alpha: 0.25),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons.photo_camera_rounded,
                      color: Color(0xFFFFB800),
                      size: 48,
                    ),
                  ),

                  const SizedBox(height: 28),

                  const Text(
                    'Locket Gold',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 32,
                      fontWeight: FontWeight.w800,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 10),
                  const Text(
                    'Gửi ảnh trực tiếp tới màn hình chính\ncủa bạn bè thân thiết',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Color(0x99FFFFFF),
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),

                  const Spacer(flex: 3),

                  // Menu Action Buttons (No Forms per spec)
                  AuthButton(
                    label: 'Đăng ký tài khoản',
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

                  const SizedBox(height: 40),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
