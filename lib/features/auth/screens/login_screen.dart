import 'package:flutter/material.dart';
import '/main_shell.dart';

// Giả lập danh sách tài khoản có sẵn (sau thay bằng API)
const _existingEmails = {'admin@gmail.com', 'user@gmail.com'};

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  // Bước 1: nhập email
  // Bước 2a: có TK → nhập mật khẩu
  // Bước 2b: chưa có TK → tạo mật khẩu + nhập lại
  int _step = 1;
  bool _hasAccount = false;

  final _emailCtrl      = TextEditingController();
  final _passwordCtrl   = TextEditingController();
  final _confirmCtrl    = TextEditingController();

  bool _obscurePass    = true;
  bool _obscureConfirm = true;
  bool _isLoading      = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passwordCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  // Bước 1: kiểm tra email
  void _checkEmail() {
    final email = _emailCtrl.text.trim();
    if (email.isEmpty || !email.contains('@')) {
      _showError('Vui lòng nhập email hợp lệ');
      return;
    }
    setState(() {
      _hasAccount = _existingEmails.contains(email);
      _step = 2;
    });
  }

  // Bước 2: đăng nhập hoặc đăng ký
  Future<void> _submit() async {
    final pass = _passwordCtrl.text;

    if (pass.length < 6) {
      _showError('Mật khẩu phải có ít nhất 6 ký tự');
      return;
    }

    if (!_hasAccount) {
      // Đăng ký: kiểm tra nhập lại
      if (_confirmCtrl.text != pass) {
        _showError('Mật khẩu nhập lại không khớp');
        return;
      }
    }

    setState(() => _isLoading = true);
    await Future.delayed(const Duration(seconds: 1));
    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => const MainShell()),
    );
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: const Color(0xFFB22222),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _goBack() {
    if (_step == 2) {
      setState(() {
        _step = 1;
        _passwordCtrl.clear();
        _confirmCtrl.clear();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'lib/assets/imgs/testimg.jpg',
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) {
                return Container(
                  decoration: const BoxDecoration(
                    gradient: RadialGradient(
                      center: Alignment(0, -0.2),
                      radius: 1.2,
                      colors: [Color(0xFF1A1040), Colors.black],
                    ),
                  ),
                );
              },
            ),
          ),

          SafeArea(
            child: Column(
              children: [
                // Top bar với nút back
                Padding(
                  padding: const EdgeInsets.fromLTRB(8, 8, 16, 0),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: _step == 2 ? _goBack : () =>
                            Navigator.pop(context),
                        icon: const Icon(Icons.arrow_back_ios_new,
                            color: Colors.white, size: 20),
                      ),
                      const SizedBox(width: 44), // cân đối
                    ],
                  ),
                ),

                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(horizontal: 28),
                    child: AnimatedSwitcher(
                      duration: const Duration(milliseconds: 300),
                      transitionBuilder: (child, anim) => SlideTransition(
                        position: Tween<Offset>(
                          begin: const Offset(0.08, 0),
                          end: Offset.zero,
                        ).animate(anim),
                        child: FadeTransition(opacity: anim, child: child),
                      ),
                      child: _step == 1
                          ? _buildStep1()
                          : _buildStep2(),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // ── BƯỚC 1: Nhập email ──
  Widget _buildStep1() {
    return Column(
      children: [
        const SizedBox(height: 40),

        const SizedBox(height: 24),

        const Text('Chào mừng!',
            style: TextStyle(color: Colors.white,
                fontSize: 28, fontWeight: FontWeight.w700)),
        const SizedBox(height: 8),
        Text('Nhập email để tiếp tục',
            style: TextStyle(color: Colors.grey[500], fontSize: 15)),

        const SizedBox(height: 40),

        _label('Email'),
        const SizedBox(height: 8),
        _textField(
          controller: _emailCtrl,
          hint: 'example@email.com',
          icon: Icons.email_outlined,
          keyboardType: TextInputType.emailAddress,
          onSubmit: _checkEmail,
        ),

        const SizedBox(height: 32),

        _primaryBtn('Tiếp tục', _checkEmail),

        const SizedBox(height: 24),
        const SizedBox(height: 32),
      ],
    );
  }

  // ── BƯỚC 2: Nhập mật khẩu ──
  Widget _buildStep2() {
    return Column(
      key: const ValueKey('step2'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 40),

        // Trạng thái: có TK hay chưa
        Container(
          padding: const EdgeInsets.all(14),
          decoration: BoxDecoration(
            color: const Color(0xFF1C1C2E),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(color: const Color(0xFF2A2A44)),
          ),
          child: Row(
            children: [
              Container(
                width: 36, height: 36,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: _hasAccount
                      ? const Color(0xFF1D9E75).withOpacity(0.2)
                      : const Color(0xFF7F77DD).withOpacity(0.2),
                ),
                child: Center(
                  child: Text(_hasAccount ? '👋' : '✨',
                      style: const TextStyle(fontSize: 18)),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      _hasAccount ? 'Chào mừng trở lại!' : 'Tạo tài khoản mới',
                      style: const TextStyle(color: Colors.white,
                          fontSize: 14, fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 2),
                    Text(_emailCtrl.text.trim(),
                        style: TextStyle(color: Colors.grey[500],
                            fontSize: 12)),
                  ],
                ),
              ),
              // Đổi email
              GestureDetector(
                onTap: _goBack,
                child: Text('Đổi',
                    style: TextStyle(
                        color: const Color(0xFF7F77DD).withOpacity(0.8),
                        fontSize: 13)),
              ),
            ],
          ),
        ),

        const SizedBox(height: 32),

        // Mật khẩu
        _label(_hasAccount ? 'Mật khẩu' : 'Tạo mật khẩu'),
        const SizedBox(height: 8),
        _textField(
          controller: _passwordCtrl,
          hint: '••••••••',
          icon: Icons.lock_outline,
          obscure: _obscurePass,
          onSubmit: _hasAccount ? _submit : null,
          suffix: GestureDetector(
            onTap: () => setState(() => _obscurePass = !_obscurePass),
            child: Icon(
              _obscurePass ? Icons.visibility_outlined
                  : Icons.visibility_off_outlined,
              color: Colors.grey[600], size: 20,
            ),
          ),
        ),

        // Nhập lại (chỉ khi đăng ký)
        if (!_hasAccount) ...[
          const SizedBox(height: 20),
          _label('Nhập lại mật khẩu'),
          const SizedBox(height: 8),
          _textField(
            controller: _confirmCtrl,
            hint: '••••••••',
            icon: Icons.lock_outline,
            obscure: _obscureConfirm,
            onSubmit: _submit,
            suffix: GestureDetector(
              onTap: () => setState(() => _obscureConfirm = !_obscureConfirm),
              child: Icon(
                _obscureConfirm ? Icons.visibility_outlined
                    : Icons.visibility_off_outlined,
                color: Colors.grey[600], size: 20,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Text('Mật khẩu ít nhất 6 ký tự',
              style: TextStyle(color: Colors.grey[700], fontSize: 12)),
        ],

        // Quên mật khẩu (chỉ khi đã có TK)
        if (_hasAccount) ...[
          const SizedBox(height: 10),
          Align(
            alignment: Alignment.centerRight,
            child: Text('Quên mật khẩu?',
                style: TextStyle(
                    color: const Color(0xFF7F77DD).withOpacity(0.8),
                    fontSize: 13)),
          ),
        ],

        const SizedBox(height: 32),

        _isLoading
            ? const Center(child: CircularProgressIndicator(
                color: Color(0xFFFFB800)))
            : _primaryBtn(
                _hasAccount ? 'Đăng nhập' : 'Tạo tài khoản',
                _submit),

        const SizedBox(height: 32),
      ],
    );
  }

  // ── Widgets nhỏ tái sử dụng ──

  Widget _stepDot(int step) {
    final isActive = _step >= step;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      width: isActive ? 24 : 8,
      height: 8,
      decoration: BoxDecoration(
        color: isActive ? const Color(0xFFFFB800) : Colors.grey[800],
        borderRadius: BorderRadius.circular(4),
      ),
    );
  }

  Widget _label(String text) {
    return Text(text,
        style: TextStyle(color: Colors.grey[400], fontSize: 13,
            fontWeight: FontWeight.w500));
  }

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType = TextInputType.text,
    bool obscure = false,
    Widget? suffix,
    VoidCallback? onSubmit,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF13132A),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF2A2A44)),
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        obscureText: obscure,
        onSubmitted: onSubmit != null ? (_) => onSubmit() : null,
        style: const TextStyle(color: Colors.white, fontSize: 15),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey[700], fontSize: 14),
          prefixIcon: Icon(icon, color: Colors.grey[600], size: 20),
          suffixIcon: suffix,
          border: InputBorder.none,
          contentPadding: const EdgeInsets.symmetric(
              horizontal: 16, vertical: 16),
        ),
      ),
    );
  }

  Widget _primaryBtn(String label, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 54,
        decoration: BoxDecoration(
          color: const Color(0xFFFFB800),
          borderRadius: BorderRadius.circular(28),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFFFFB800).withOpacity(0.3),
              blurRadius: 16,
              offset: const Offset(0, 6),
            ),
          ],
        ),
        child: Center(
          child: Text(label,
              style: const TextStyle(color: Colors.black,
                  fontSize: 16, fontWeight: FontWeight.w700)),
        ),
      ),
    );
  }
}