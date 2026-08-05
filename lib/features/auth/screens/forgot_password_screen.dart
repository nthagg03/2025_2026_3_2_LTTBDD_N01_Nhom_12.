import 'package:flutter/material.dart';

import '../widgets/auth_button.dart';
import '../widgets/auth_text_field.dart';
import 'reset_password_screen.dart';

class ForgotPasswordScreen extends StatelessWidget {
  final String email;

  const ForgotPasswordScreen({
    super.key,
    required this.email,
  });

  @override
  Widget build(BuildContext context) {
    final emailCtrl = TextEditingController(text: email);

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A14),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A14),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Quên mật khẩu',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Đặt lại mật khẩu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                const Text(
                  'Chúng tôi sẽ giúp bạn đặt lại mật khẩu cho tài khoản này',
                  style: TextStyle(color: Color(0x99FFFFFF), fontSize: 14),
                ),

                const SizedBox(height: 28),

                AuthTextField(
                  controller: emailCtrl,
                  hintText: 'Email',
                  icon: Icons.email_outlined,
                  enabled: false,
                ),

                const SizedBox(height: 24),

                AuthButton(
                  label: 'Tiếp tục',
                  isPrimary: true,
                  onPressed: () async {
                    final success = await Navigator.push<bool>(
                      context,
                      MaterialPageRoute(
                        builder: (_) => ResetPasswordScreen(email: email),
                      ),
                    );
                    if (success == true && context.mounted) {
                      Navigator.pop(context, true);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
