import 'package:flutter/material.dart';

import '../../../repositories/auth_repository.dart';
import '../../../routes/app_routes.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_text_field.dart';

class CreatePasswordScreen extends StatefulWidget {
  final String email;

  const CreatePasswordScreen({
    super.key,
    required this.email,
  });

  @override
  State<CreatePasswordScreen> createState() => _CreatePasswordScreenState();
}

class _CreatePasswordScreenState extends State<CreatePasswordScreen> {
  late final TextEditingController _emailCtrl;
  final _passCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();

  bool _obscurePass = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    _emailCtrl = TextEditingController(text: widget.email);
  }

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  void _onCreateAccount() async {
    final pass = _passCtrl.text;
    final confirm = _confirmPassCtrl.text;

    if (pass.isEmpty || pass.length < 8) {
      _showSnackBar('Mật khẩu phải có ít nhất 8 ký tự');
      return;
    }

    setState(() => _isLoading = true);
    try {
      await AuthRepository().register(widget.email, pass);
      if (!mounted) return;
      setState(() => _isLoading = false);
      Navigator.pushNamedAndRemoveUntil(
        context,
        AppRoutes.home,
        (route) => false,
      );
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showSnackBar('Đăng ký thất bại. Email đã được sử dụng.', isError: true);
    }
  }

  void _showSnackBar(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.redAccent : const Color(0xFF7F77DD),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A14),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A14),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const Text(
                  'Chọn một mật khẩu',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),

                const SizedBox(height:28),

                AuthTextField(
                  controller: _passCtrl,
                  hintText: 'Mật khẩu',
                  icon: Icons.lock_outline_rounded,
                  obscureText: _obscurePass,
                  suffix: IconButton(
                    icon: Icon(
                      _obscurePass
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: Colors.grey[500],
                    ),
                    onPressed: () {
                      setState(() => _obscurePass = !_obscurePass);
                    },
                  ),
                ),

                const SizedBox(height: 10),
                const Padding(
                  padding: EdgeInsets.only(left: 4),
                  child: Text(
                    'Mật khẩu của bạn phải dài tối thiểu 8 ký tự',
                    style: TextStyle(color: Color(0x99FFFFFF), fontSize: 12),
                  ),
                ),
              ],
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
          onPressed: _onCreateAccount,
        ),
      ),
    );
  }
}
