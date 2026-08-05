import 'package:flutter/material.dart';

import '../../../routes/app_routes.dart';
import '../models/settings_model.dart';
import '../services/settings_service.dart';
import '../../home_widget/screens/home_widget_screen.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  final SettingsService _service = SettingsService();
  AppSettingsModel? _settings;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadSettings();
  }

  Future<void> _loadSettings() async {
    setState(() => _isLoading = true);
    final s = await _service.getSettings();
    if (!mounted) return;
    setState(() {
      _settings = s;
      _isLoading = false;
    });
  }

  Future<void> _toggle(Future<AppSettingsModel> Function() action) async {
    final updated = await action();
    if (!mounted) return;
    setState(() => _settings = updated);
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF13132A),
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Đăng xuất?',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w700)),
        content: const Text(
          'Bạn có chắc muốn đăng xuất không?',
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
                    color: Colors.redAccent,
                    fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 20, 0, 8),
      child: Text(
        title,
        style: const TextStyle(
          color: Color(0xFFFFB800),
          fontSize: 13,
          fontWeight: FontWeight.w700,
          letterSpacing: 0.5,
        ),
      ),
    );
  }

  Widget _buildSwitch({
    required String title,
    required String? subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF13132A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A2A44)),
      ),
      child: SwitchListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        title: Text(title,
            style: const TextStyle(
                color: Colors.white, fontSize: 15, fontWeight: FontWeight.w500)),
        subtitle: subtitle != null
            ? Text(subtitle,
                style: const TextStyle(
                    color: Color(0x99FFFFFF), fontSize: 12))
            : null,
        value: value,
        onChanged: onChanged,
        activeThumbColor: const Color(0xFFFFB800),
        inactiveThumbColor: Colors.white38,
        inactiveTrackColor: const Color(0xFF2A2A44),
      ),
    );
  }

  Widget _buildTile({
    required String title,
    String? subtitle,
    required VoidCallback onTap,
    Widget? trailing,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF13132A),
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFF2A2A44)),
      ),
      child: ListTile(
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        title: Text(title,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 15,
                fontWeight: FontWeight.w500)),
        subtitle: subtitle != null
            ? Text(subtitle,
                style: const TextStyle(
                    color: Color(0x99FFFFFF), fontSize: 12))
            : null,
        trailing:
            trailing ?? const Icon(Icons.arrow_forward_ios_rounded,
                color: Colors.white38, size: 16),
        onTap: onTap,
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
        title: const Text('Cài đặt',
            style: TextStyle(
                color: Colors.white, fontWeight: FontWeight.w700)),
      ),
      body: _isLoading || _settings == null
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFFFB800)))
          : ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                // ── Thông báo ──
                _buildSectionHeader('Thông báo'),
                _buildSwitch(
                  title: 'Thông báo đẩy',
                  subtitle: 'Nhận thông báo khi bạn bè đăng ảnh mới',
                  value: _settings!.pushNotifications,
                  onChanged: (v) => _toggle(
                      () => _service.togglePushNotifications(v)),
                ),
                _buildSwitch(
                  title: 'Âm thanh',
                  subtitle: 'Phát âm khi nhận thông báo',
                  value: _settings!.soundEnabled,
                  onChanged: (v) =>
                      _toggle(() => _service.toggleSound(v)),
                ),
                _buildSwitch(
                  title: 'Rung',
                  subtitle: 'Rung khi nhận thông báo',
                  value: _settings!.vibrationEnabled,
                  onChanged: (v) =>
                      _toggle(() => _service.toggleVibration(v)),
                ),

                // ── Quyền riêng tư ──
                _buildSectionHeader('Quyền riêng tư'),
                _buildSwitch(
                  title: 'Tài khoản riêng tư',
                  subtitle:
                      'Chỉ bạn bè được chấp nhận mới thấy ảnh của bạn',
                  value: _settings!.privateAccount,
                  onChanged: (v) =>
                      _toggle(() => _service.togglePrivateAccount(v)),
                ),

                // ── Khác ──
                _buildSectionHeader('Khác'),
                _buildSwitch(
                  title: 'Lưu ảnh vào thư viện máy',
                  subtitle: 'Tự động lưu ảnh khi chụp và gửi',
                  value: _settings!.saveToGallery,
                  onChanged: (v) =>
                      _toggle(() => _service.toggleSaveToGallery(v)),
                ),
                _buildTile(
                  title: 'Widget màn hình chính',
                  subtitle: 'Cấu hình widget hiển thị ảnh trên màn hình',
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (_) => const HomeWidgetScreen()),
                    );
                  },
                ),
                _buildTile(
                  title: 'Phiên bản ứng dụng',
                  subtitle: null,
                  onTap: () {},
                  trailing: const Text(
                    '1.0.0+1',
                    style: TextStyle(color: Color(0x99FFFFFF), fontSize: 13),
                  ),
                ),

                const SizedBox(height: 16),

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
                    label: const Text('Đăng xuất',
                        style: TextStyle(
                            fontWeight: FontWeight.w700, fontSize: 16)),
                  ),
                ),

                const SizedBox(height: 32),
              ],
            ),
    );
  }
}
