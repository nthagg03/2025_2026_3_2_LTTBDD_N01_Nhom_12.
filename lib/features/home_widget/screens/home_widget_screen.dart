import 'package:flutter/material.dart';

import '../../../core/services/widget_service.dart';

class HomeWidgetScreen extends StatefulWidget {
  const HomeWidgetScreen({super.key});

  @override
  State<HomeWidgetScreen> createState() => _HomeWidgetScreenState();
}

class _HomeWidgetScreenState extends State<HomeWidgetScreen> {
  final WidgetService _service = WidgetService();
  String _latestPhoto = 'Đang tải...';
  bool _isLoading = true;
  bool _isRefreshing = false;

  @override
  void initState() {
    super.initState();
    _loadWidgetData();
  }

  Future<void> _loadWidgetData() async {
    setState(() => _isLoading = true);
    final value = await _service.getLatestPhoto();
    if (!mounted) return;
    setState(() {
      _latestPhoto = value;
      _isLoading = false;
    });
  }

  Future<void> _refreshWidgetData() async {
    setState(() => _isRefreshing = true);
    final success = await _service.refreshWidget();
    if (!mounted) return;
    setState(() {
      _isRefreshing = false;
      if (success) _latestPhoto = 'Ảnh mới nhất: Vừa cập nhật';
    });
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(success
            ? '✅ Widget đã được làm mới thành công'
            : '⚠️ Không thể cập nhật widget (chưa cấu hình native)'),
        behavior: SnackBarBehavior.floating,
        backgroundColor:
            success ? const Color(0xFF7F77DD) : const Color(0xFF2A2A44),
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
        title: const Text(
          'Widget màn hình chính',
          style: TextStyle(
              color: Colors.white, fontWeight: FontWeight.w700),
        ),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(color: Color(0xFFFFB800)))
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Widget Preview Card
                    Container(
                      width: double.infinity,
                      height: 200,
                      decoration: BoxDecoration(
                        color: const Color(0xFF13132A),
                        borderRadius: BorderRadius.circular(24),
                        border: Border.all(color: const Color(0xFF2A2A44)),
                      ),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 72,
                            height: 72,
                            decoration: BoxDecoration(
                              color: const Color(0xFF7F77DD)
                                  .withValues(alpha: 0.2),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.photo_camera_rounded,
                              size: 36,
                              color: Color(0xFF7F77DD),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            _latestPhoto,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 6),
                          const Text(
                            'Xem trước widget',
                            style: TextStyle(
                                color: Color(0x99FFFFFF), fontSize: 12),
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 24),

                    // Info card
                    Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFF13132A),
                        borderRadius: BorderRadius.circular(16),
                        border: Border.all(color: const Color(0xFF2A2A44)),
                      ),
                      child: const Row(
                        children: [
                          Icon(Icons.info_outline_rounded,
                              color: Color(0xFFFFB800), size: 20),
                          SizedBox(width: 12),
                          Expanded(
                            child: Text(
                              'Widget sẽ hiển thị ảnh mới nhất bạn gửi ngay trên màn hình chính của điện thoại.',
                              style: TextStyle(
                                  color: Color(0x99FFFFFF),
                                  fontSize: 13,
                                  height: 1.4),
                            ),
                          ),
                        ],
                      ),
                    ),

                    const Spacer(),

                    // Refresh button
                    SizedBox(
                      width: double.infinity,
                      height: 54,
                      child: FilledButton.icon(
                        onPressed: _isRefreshing ? null : _refreshWidgetData,
                        style: FilledButton.styleFrom(
                          backgroundColor: const Color(0xFFFFB800),
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(28)),
                        ),
                        icon: _isRefreshing
                            ? const SizedBox(
                                width: 18,
                                height: 18,
                                child: CircularProgressIndicator(
                                    strokeWidth: 2, color: Colors.black),
                              )
                            : const Icon(Icons.refresh_rounded),
                        label: Text(
                          _isRefreshing
                              ? 'Đang làm mới...'
                              : 'Làm mới dữ liệu widget',
                          style: const TextStyle(
                              fontWeight: FontWeight.w700, fontSize: 16),
                        ),
                      ),
                    ),

                    const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
    );
  }
}
