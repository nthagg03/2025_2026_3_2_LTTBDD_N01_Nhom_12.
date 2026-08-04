import 'package:flutter/material.dart';

import '../../../core/widgets/app_button.dart';
import '../../../routes/app_routes.dart';
import '../models/profile_model.dart';
import '../services/profile_service.dart';
import '../../settings/screens/settings_screen.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final ProfileService _service = ProfileService();
  ProfileModel? _profile;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  Future<void> _loadProfile() async {
    setState(() => _isLoading = true);
    final profile = await _service.getProfile();
    if (!mounted) return;
    setState(() {
      _profile = profile;
      _isLoading = false;
    });
  }

  void _showEditSheet() {
    final nameCtrl = TextEditingController(text: _profile?.name ?? '');
    final bioCtrl = TextEditingController(text: _profile?.bio ?? '');

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF13132A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (ctx) => Padding(
        padding: EdgeInsets.only(
          left: 20,
          right: 20,
          top: 20,
          bottom: MediaQuery.of(ctx).viewInsets.bottom + 24,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.white24,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 20),
            const Text(
              'Chỉnh sửa hồ sơ',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 18,
                  fontWeight: FontWeight.w700),
            ),
            const SizedBox(height: 16),
            _buildTextField(nameCtrl, 'Tên hiển thị', Icons.person_rounded),
            const SizedBox(height: 12),
            _buildTextField(bioCtrl, 'Bio', Icons.edit_note_rounded,
                maxLines: 2),
            const SizedBox(height: 20),
            AppButton(
              label: 'Lưu thay đổi',
              onPressed: () async {
                Navigator.pop(ctx);
                final updated = await _service.updateProfile(
                  name: nameCtrl.text.trim().isEmpty
                      ? null
                      : nameCtrl.text.trim(),
                  bio: bioCtrl.text.trim().isEmpty
                      ? null
                      : bioCtrl.text.trim(),
                );
                if (!mounted) return;
                setState(() => _profile = updated);
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
    TextEditingController ctrl,
    String label,
    IconData icon, {
    int maxLines = 1,
  }) {
    return TextField(
      controller: ctrl,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: const TextStyle(color: Color(0x99FFFFFF)),
        prefixIcon: Icon(icon, color: const Color(0xFF7F77DD), size: 20),
        filled: true,
        fillColor: const Color(0xFF0A0A14),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFF2A2A44)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFFFB800), width: 1.5),
        ),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF13132A),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Đăng xuất?',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700)),
        content: const Text(
          'Bạn có chắc muốn đăng xuất khỏi tài khoản không?',
          style: TextStyle(color: Color(0x99FFFFFF)),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy',
                style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushNamedAndRemoveUntil(
                  context, AppRoutes.splash, (route) => false);
            },
            child: const Text('Đăng xuất',
                style: TextStyle(
                    color: Colors.redAccent, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(String value, String label, IconData icon,
      Color iconColor) {
    return Expanded(
      child: Container(
        padding:
            const EdgeInsets.symmetric(vertical: 14, horizontal: 8),
        decoration: BoxDecoration(
          color: const Color(0xFF13132A),
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: const Color(0xFF2A2A44)),
        ),
        child: Column(
          children: [
            Icon(icon, color: iconColor, size: 20),
            const SizedBox(height: 6),
            Text(value,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.w800)),
            const SizedBox(height: 2),
            Text(label,
                style: const TextStyle(
                    color: Color(0x99FFFFFF), fontSize: 11),
                textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A0A14),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A14),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Trang cá nhân',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w700)),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFFFB800)))
          : SafeArea(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(20),
                child: Column(
                  children: [
                    const SizedBox(height: 8),

                    // Avatar
                    Container(
                      width: 90,
                      height: 90,
                      padding: const EdgeInsets.all(3),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                            color: const Color(0xFFFFB800), width: 2.5),
                      ),
                      child: CircleAvatar(
                        backgroundColor: const Color(0xFF7F77DD),
                        child: Text(
                          _profile!.avatar,
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.w800),
                        ),
                      ),
                    ),
                    const SizedBox(height: 14),

                    // Name
                    Text(
                      _profile!.name,
                      style: const TextStyle(
                          color: Colors.white,
                          fontSize: 22,
                          fontWeight: FontWeight.w800),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '@${_profile!.username}',
                      style: const TextStyle(
                          color: Color(0x99FFFFFF), fontSize: 14),
                    ),
                    const SizedBox(height: 8),
                    if (_profile!.bio.isNotEmpty)
                      Text(
                        _profile!.bio,
                        textAlign: TextAlign.center,
                        style: const TextStyle(
                            color: Colors.white70, fontSize: 14, height: 1.4),
                      ),

                    const SizedBox(height: 24),

                    // Stats row
                    Row(
                      children: [
                        _buildStatCard(
                          '${_profile!.friendCount}',
                          'Bạn bè',
                          Icons.people_alt_rounded,
                          const Color(0xFF7F77DD),
                        ),
                        const SizedBox(width: 10),
                        _buildStatCard(
                          '${_profile!.postCount}',
                          'Bài đăng',
                          Icons.photo_library_rounded,
                          const Color(0xFFFFB800),
                        ),
                        const SizedBox(width: 10),
                        _buildStatCard(
                          '${_profile!.streakDays}',
                          'Ngày streak',
                          Icons.local_fire_department_rounded,
                          Colors.deepOrangeAccent,
                        ),
                      ],
                    ),

                    const SizedBox(height: 28),

                    // Edit profile
                    AppButton(
                      label: 'Chỉnh sửa hồ sơ',
                      variant: AppButtonVariant.outline,
                      icon: Icons.edit_rounded,
                      onPressed: _showEditSheet,
                    ),

                    const SizedBox(height: 12),

                    // Settings
                    AppButton(
                      label: 'Cài đặt',
                      variant: AppButtonVariant.secondary,
                      icon: Icons.settings_rounded,
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (_) => const SettingsScreen()),
                        );
                      },
                    ),

                    const SizedBox(height: 12),

                    // Logout
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: OutlinedButton.icon(
                        onPressed: _showLogoutDialog,
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.redAccent,
                          side: const BorderSide(color: Colors.redAccent),
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28)),
                        ),
                        icon: const Icon(Icons.logout_rounded),
                        label: const Text(
                          'Đăng xuất',
                          style: TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 16),
                        ),
                      ),
                    ),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),
    );
  }
}
