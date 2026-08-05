import 'package:flutter/material.dart';

import '../../../repositories/auth_repository.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_text_field.dart';
import 'create_password_screen.dart';
import 'password_login_screen.dart';

class EmailEntryScreen extends StatefulWidget {
  final bool isSignUp;

  const EmailEntryScreen({
    super.key,
    this.isSignUp = false,
  });

  @override
  State<EmailEntryScreen> createState() => _EmailEntryScreenState();
}

class _EmailEntryScreenState extends State<EmailEntryScreen> {
  final _emailCtrl = TextEditingController();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    super.dispose();
  }

  Future<void> _onContinue() async {
    final email = _emailCtrl.text.trim();

    if (email.isEmpty || !email.contains('@') || !email.contains('.')) {
      _showSnackBar('Vui lòng nhập email hợp lệ', isError: true);
      return;
    }

    setState(() => _isLoading = true);

    final exists = await AuthRepository().emailExists(email);

    if (!mounted) return;

    setState(() => _isLoading = false);

    if (exists) {
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => PasswordLoginScreen(email: email),
        ),
      );
    } else {
      if (widget.isSignUp) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => CreatePasswordScreen(email: email),
          ),
        );
      } else {
        _showSnackBar(
          'Tài khoản không tồn tại',
          isError: true,
        );
      }
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : const Color(0xFF7F77DD),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
        ),
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A14),
      resizeToAvoidBottomInset: true,

      appBar: AppBar(
        elevation: 0,
        backgroundColor: const Color(0xFF0A0A14),
        leading: IconButton(
          icon: const Icon(
            Icons.arrow_back_ios_new_rounded,
            color: Colors.white,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: ConstrainedBox(
            constraints: BoxConstraints(
              minHeight:
              MediaQuery.of(context).size.height -
                  kToolbarHeight -
                  MediaQuery.of(context).padding.top,
            ),
            child: IntrinsicHeight(
              child: Column(
                children: [
                  const Spacer(),

                  const Text(
                    'Email của bạn là gì?',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 32),

                  AuthTextField(
                    controller: _emailCtrl,
                    hintText: 'Địa chỉ email',
                    icon: Icons.email_outlined,
                    keyboardType: TextInputType.emailAddress,
                  ),

                  const Spacer(),
                ],
              ),
            ),
          ),
        ),
      ),

      bottomNavigationBar: AnimatedPadding(
        duration: const Duration(milliseconds: 250),
        curve: Curves.easeOut,
        padding: EdgeInsets.only(
          left: 24,
          right: 24,
          top: 12,
          bottom:
          MediaQuery.of(context).viewInsets.bottom +
              MediaQuery.of(context).padding.bottom +
              16,
        ),
        child: AuthButton(
          label: 'Tiếp tục',
          isPrimary: true,
          isLoading: _isLoading,
          onPressed: _onContinue,
        ),
      ),
    );
  }
}