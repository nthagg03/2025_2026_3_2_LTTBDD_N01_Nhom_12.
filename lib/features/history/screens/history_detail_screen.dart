import 'dart:io';

import 'package:flutter/material.dart';

import '../../../core/utils/date_utils.dart';
import '../models/history_photo.dart';
import '../services/history_service.dart';

class HistoryDetailScreen extends StatelessWidget {
  final HistoryPhoto photo;

  const HistoryDetailScreen({
    super.key,
    required this.photo,
  });

  void _confirmDelete(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF13132A),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: const Text(
          'Xóa kỷ niệm?',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        content: const Text(
          'Ảnh này sẽ bị xóa khỏi lịch sử kỷ niệm của bạn.',
          style: TextStyle(color: Colors.white70),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy', style: TextStyle(color: Colors.white54)),
          ),
          TextButton(
            onPressed: () {
              HistoryService.instance.deletePhoto(photo.id);
              Navigator.pop(ctx); // Close dialog
              Navigator.pop(context); // Exit detail screen
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: const Text('Đã xóa kỷ niệm'),
                  backgroundColor: const Color(0xFF7F77DD),
                  behavior: SnackBarBehavior.floating,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14),
                  ),
                ),
              );
            },
            child: const Text(
              'Xóa',
              style: TextStyle(color: Colors.redAccent, fontWeight: FontWeight.w700),
            ),
          ),
        ],
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
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          AppDateUtils.formatDate(photo.createdAt),
          style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
        actions: [
          IconButton(
            onPressed: () => _confirmDelete(context),
            icon: const Icon(Icons.delete_outline_rounded, color: Colors.redAccent),
          ),
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(24),
                  child: Hero(
                    tag: photo.id,
                    child: _buildImage(photo.imagePath),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: const Color(0xFF13132A),
                  borderRadius: BorderRadius.circular(20),
                  border: Border.all(color: const Color(0xFF2A2A44)),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (photo.caption.isNotEmpty) ...[
                      Text(
                        photo.caption,
                        style: const TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                          height: 1.4,
                        ),
                      ),
                      const SizedBox(height: 12),
                    ],
                    Row(
                      children: [
                        const Icon(
                          Icons.access_time_rounded,
                          color: Color(0x99FFFFFF),
                          size: 16,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          AppDateUtils.formatTimestamp(photo.createdAt),
                          style: const TextStyle(
                            color: Color(0x99FFFFFF),
                            fontSize: 13,
                          ),
                        ),
                      ],
                    ),
                    if (photo.recipients.isNotEmpty) ...[
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          const Icon(
                            Icons.send_rounded,
                            color: Color(0xFFFFB800),
                            size: 16,
                          ),
                          const SizedBox(width: 6),
                          Expanded(
                            child: Text(
                              'Đã gửi cho: ${photo.recipients.join(", ")}',
                              style: const TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildImage(String path) {
    if (path.startsWith('/') || path.contains(':\\') || path.contains(':/')) {
      return Image.file(
        File(path),
        width: double.infinity,
        fit: BoxFit.contain,
        errorBuilder: (_, __, ___) => _buildErrorContainer(),
      );
    }
    return Image.asset(
      path,
      width: double.infinity,
      fit: BoxFit.contain,
      errorBuilder: (_, __, ___) => _buildErrorContainer(),
    );
  }

  Widget _buildErrorContainer() {
    return Container(
      color: const Color(0xFF1C1C2E),
      child: const Center(
        child: Icon(
          Icons.image_not_supported_rounded,
          color: Colors.white38,
          size: 48,
        ),
      ),
    );
  }
}