import 'package:flutter/material.dart';

import '../../../repositories/auth_repository.dart';
import '../widgets/auth_button.dart';
import '../widgets/auth_text_field.dart';

class ResetPasswordScreen extends StatefulWidget {
  final String email;

  const ResetPasswordScreen({
    super.key,
    required this.email,
  });

  @override
  State<ResetPasswordScreen> createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final _passCtrl = TextEditingController();
  final _confirmPassCtrl = TextEditingController();

  bool _obscurePass = true;
  bool _obscureConfirm = true;
  bool _isLoading = false;

  @override
  void dispose() {
    _passCtrl.dispose();
    _confirmPassCtrl.dispose();
    super.dispose();
  }

  void _onResetPassword() async {
    final pass = _passCtrl.text;
    final confirm = _confirmPassCtrl.text;

    if (pass.isEmpty || pass.length < 8) {
      _showSnackBar('Mật khẩu phải có ít nhất 8 ký tự');
      return;
    }

    if (pass != confirm) {
      _showSnackBar('Mật khẩu nhập lại không khớp');
      return;
    }

    setState(() => _isLoading = true);
    try {
      await AuthRepository().resetPassword(widget.email, pass);
      if (!mounted) return;
      setState(() => _isLoading = false);
      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;
      setState(() => _isLoading = false);
      _showSnackBar('Đặt lại mật khẩu thất bại. Vui lòng thử lại.');
    }
  }

  void _showSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: const Color(0xFF7F77DD),
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
        title: const Text(
          'Mật khẩu mới',
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
                  'Tạo mật khẩu mới',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24,
                    fontWeight: FontWeight.w800,
                  ),
                ),
                const SizedBox(height: 6),
                Text(
                  'Nhập mật khẩu mới cho tài khoản ${widget.email}',
                  style: const TextStyle(color: Color(0x99FFFFFF), fontSize: 14),
                ),

                const SizedBox(height: 28),

                AuthTextField(
                  controller: _passCtrl,
                  hintText: 'Mật khẩu mới',
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

                const SizedBox(height: 4),
                const Padding(
                  padding: EdgeInsets.only(left: 4),
                  child: Text(
                    'Tối thiểu 8 ký tự',
                    style: TextStyle(color: Color(0x99FFFFFF), fontSize: 12),
                  ),
                ),

                const SizedBox(height: 16),

                AuthTextField(
                  controller: _confirmPassCtrl,
                  hintText: 'Nhập lại mật khẩu mới',
                  icon: Icons.lock_outline_rounded,
                  obscureText: _obscureConfirm,
                  suffix: IconButton(
                    icon: Icon(
                      _obscureConfirm
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined,
                      color: Colors.grey[500],
                    ),
                    onPressed: () {
                      setState(() => _obscureConfirm = !_obscureConfirm);
                    },
                  ),
                ),

                const SizedBox(height: 28),

                AuthButton(
                  label: 'Đặt lại mật khẩu',
                  isPrimary: true,
                  isLoading: _isLoading,
                  onPressed: _onResetPassword,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
