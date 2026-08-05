import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../routes/app_routes.dart';
import '../../friends/screens/friends_screen.dart';
import '../../friends/services/friend_service.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  void _copyLink() {
    Clipboard.setData(const ClipboardData(text: 'locket.cam/nthagg.03'));
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Đã sao chép liên kết profile!'),
        backgroundColor: const Color(0xFF1E3A2B),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _shareLink() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: const Text('Mở menu chia sẻ liên kết Locket!'),
        backgroundColor: const Color(0xFF1E3A2B),
        behavior: SnackBarBehavior.floating,
        duration: const Duration(seconds: 2),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _showLogoutDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF2C2C2E),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text('Đăng xuất', style: TextStyle(color: Colors.white)),
        content: const Text(
          'Bạn có chắc chắn muốn đăng xuất khỏi tài khoản?',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy', style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(ctx);
              Navigator.pushNamedAndRemoveUntil(
                context,
                AppRoutes.login,
                (route) => false,
              );
            },
            child: const Text(
              'Đăng xuất',
              style: TextStyle(
                color: Color(0xFFFF4B4B),
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSectionHeader(String title, {Widget? trailing}) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 8, top: 18),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white70,
              fontSize: 14,
              fontWeight: FontWeight.w600,
            ),
          ),
          if (trailing != null) trailing,
        ],
      ),
    );
  }


  Widget _buildCardContainer({required List<Widget> children}) {
    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF2B2B2E),
        borderRadius: BorderRadius.circular(22),
      ),
      child: Column(
        children: List.generate(children.length, (index) {
          return Column(
            children: [
              children[index],
              if (index < children.length - 1)
                const Divider(
                  height: 1,
                  thickness: 0.6,
                  color: Colors.white10,
                  indent: 16,
                  endIndent: 16,
                ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildTileItem({
    required IconData icon,
    required String title,
    String? badgeText,
    Color? textColor,
    Color? iconColor,
    VoidCallback? onTap,
  }) {
    return InkWell(
      onTap: onTap ?? () {},
      borderRadius: BorderRadius.circular(22),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        child: Row(
          children: [
            Icon(
              icon,
              color: iconColor ?? Colors.white70,
              size: 20,
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                title,
                style: TextStyle(
                  color: textColor ?? Colors.white,
                  fontSize: 15,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
            if (badgeText != null) ...[
              const Text('💛 ', style: TextStyle(fontSize: 12)),
              Text(
                badgeText,
                style: const TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.w600,
                ),
              ),
              const SizedBox(width: 4),
            ],
            const Icon(
              Icons.chevron_right_rounded,
              color: Colors.white38,
              size: 20,
            ),
          ],
        ),
      ),
    );
  }


  bool _isPopping = false;

  void _popToCamera() {
    if (_isPopping) return;
    _isPopping = true;
    if (Navigator.canPop(context)) {
      Navigator.pop(context);
    } else {
      Navigator.pushReplacementNamed(context, AppRoutes.home);
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF1C1C1E),
      body: NotificationListener<ScrollNotification>(
        onNotification: (scrollNotification) {
          if (scrollNotification.metrics.pixels < -15 ||
              (scrollNotification is OverscrollNotification &&
                  scrollNotification.overscroll < -5)) {
            _popToCamera();
            return true;
          }
          return false;
        },
        child: GestureDetector(
          behavior: HitTestBehavior.translucent,
          onVerticalDragEnd: (details) {
            if ((details.primaryVelocity ?? 0) > 80) {
              _popToCamera();
            }
          },
          child: SafeArea(
            child: Column(
              children: [
                // Top Drag Handle Bar (Tap or drag down to return to camera)
                GestureDetector(
                  onTap: _popToCamera,
                  onVerticalDragEnd: (details) {
                    if ((details.primaryVelocity ?? 0) > 50) {
                      _popToCamera();
                    }
                  },
                  child: Container(
                    width: double.infinity,
                    color: Colors.transparent,
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    child: Center(
                      child: Container(
                        width: 38,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.white24,
                          borderRadius: BorderRadius.circular(2.5),
                        ),
                      ),
                    ),
                  ),
                ),


              // Main Scrollable Content
              Expanded(
                child: ListView(
                  physics: const BouncingScrollPhysics(
                    parent: AlwaysScrollableScrollPhysics(),
                  ),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    // Profile Header (Avatar + Name + Username)
                    Center(
                      child: Column(
                        children: [

                          Container(
                            width: 104,
                            height: 104,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              border: Border.all(
                                color: const Color(0xFFFFB800),
                                width: 3.5,
                              ),
                            ),
                            child: ClipOval(
                              child: Image.asset(
                                'lib/assets/imgs/XCXS0510.JPG',
                                fit: BoxFit.cover,
                                errorBuilder: (_, __, ___) => Container(
                                  color: const Color(0xFF3B3C40),
                                  child: const Icon(
                                    Icons.person_rounded,
                                    color: Colors.white,
                                    size: 48,
                                  ),
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 12),
                          const Text(
                            'Nguyễn Xuân Thắng',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w800,
                              letterSpacing: 0.3,
                            ),
                          ),
                          const SizedBox(height: 4),
                          GestureDetector(
                            onTap: _copyLink,
                            child: const Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  'locket.cam/nthagg.03',
                                  style: TextStyle(
                                    color: Colors.white54,
                                    fontSize: 13,
                                  ),
                                ),
                                SizedBox(width: 4),
                                Icon(
                                  Icons.link_rounded,
                                  color: Colors.white54,
                                  size: 14,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 20),

                    // Action Buttons Row (Friends, Copy Link, Share Link)
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        // Friends button
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const FriendsScreen(),
                              ),
                            );
                          },
                          child: Column(
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF2C2C2E),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.people_rounded,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(height: 8),
                              AnimatedBuilder(
                                animation: FriendService.instance,
                                builder: (context, _) {
                                  return Text(
                                    '${FriendService.instance.friendCount} người bạn',
                                    style: const TextStyle(
                                      color: Colors.white70,
                                      fontSize: 12,
                                    ),
                                  );
                                },
                              ),
                            ],
                          ),
                        ),

                        // Copy Link button
                        GestureDetector(
                          onTap: _copyLink,
                          child: Column(
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF2C2C2E),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.link_rounded,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Sao chép liên kết',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),

                        // Share Link button
                        GestureDetector(
                          onTap: _shareLink,
                          child: Column(
                            children: [
                              Container(
                                width: 56,
                                height: 56,
                                decoration: const BoxDecoration(
                                  color: Color(0xFF2C2C2E),
                                  shape: BoxShape.circle,
                                ),
                                child: const Icon(
                                  Icons.ios_share_rounded,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(height: 8),
                              const Text(
                                'Chia sẻ liên kết',
                                style: TextStyle(
                                  color: Colors.white70,
                                  fontSize: 12,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 20),

                    // Section: Tổng quát

                    _buildSectionHeader('Tổng quát'),
                    _buildCardContainer(
                      children: [
                        _buildTileItem(
                          icon: Icons.notifications_none_rounded,
                          title: 'Notifications',
                        ),
                        _buildTileItem(
                          icon: Icons.cake_outlined,
                          title: 'Sửa ngày sinh',
                        ),
                        _buildTileItem(
                          icon: Icons.text_fields_rounded,
                          title: 'Sửa tên',
                        ),
                        _buildTileItem(
                          icon: Icons.account_circle_outlined,
                          title: 'Edit profile photo',
                        ),
                        _buildTileItem(
                          icon: Icons.phone_outlined,
                          title: 'Phone number',
                        ),
                      ],
                    ),

                    // Section: Hỗ trợ
                    // Section: Quyền riêng tư và dữ liệu
                    _buildSectionHeader('Quyền riêng tư'),
                    _buildCardContainer(
                      children: [
                        _buildTileItem(
                          icon: Icons.back_hand_outlined,
                          title: 'Quyền riêng tư và dữ liệu',
                        ),
                      ],
                    ),

                    // Section: Vùng nguy hiểm
                    _buildSectionHeader('Vùng nguy hiểm'),
                    _buildCardContainer(
                      children: [
                        _buildTileItem(
                          icon: Icons.delete_outline_rounded,
                          title: 'Xóa tài khoản',
                          textColor: const Color(0xFFFF4B4B),
                          iconColor: const Color(0xFFFF4B4B),
                        ),
                        _buildTileItem(
                          icon: Icons.back_hand_outlined,
                          title: 'Đăng xuất',
                          onTap: _showLogoutDialog,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    ),
  );
}
}



