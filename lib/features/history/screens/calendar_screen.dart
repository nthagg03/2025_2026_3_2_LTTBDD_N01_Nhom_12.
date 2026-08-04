import 'dart:io';

import 'package:flutter/material.dart';

import '../../../core/utils/date_utils.dart';
import '../models/history_photo.dart';
import '../services/history_service.dart';
import 'history_detail_screen.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({super.key});

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();
}

class _CalendarScreenState extends State<CalendarScreen> {
  final history = HistoryService.instance;

  @override
  void initState() {
    super.initState();
    history.addListener(_refresh);
  }

  @override
  void dispose() {
    history.removeListener(_refresh);
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  Map<DateTime, List<HistoryPhoto>> _groupPhotosByDate(List<HistoryPhoto> photos) {
    final Map<DateTime, List<HistoryPhoto>> grouped = {};
    for (final photo in photos) {
      final dateKey = DateTime(
        photo.createdAt.year,
        photo.createdAt.month,
        photo.createdAt.day,
      );
      if (!grouped.containsKey(dateKey)) {
        grouped[dateKey] = [];
      }
      grouped[dateKey]!.add(photo);
    }
    return grouped;
  }

  @override
  Widget build(BuildContext context) {
    final photos = history.photos;
    final groupedMap = _groupPhotosByDate(photos);
    final sortedDates = groupedMap.keys.toList()
      ..sort((a, b) => b.compareTo(a));

    return Scaffold(
      backgroundColor: const Color(0xFF0A0A14),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A0A14),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, color: Colors.white),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'Lịch kỷ niệm',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w700),
        ),
      ),
      body: photos.isEmpty
          ? const Center(
              child: Text(
                'Chưa có kỷ niệm nào',
                style: TextStyle(color: Colors.white54),
              ),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: sortedDates.length,
              itemBuilder: (context, index) {
                final date = sortedDates[index];
                final dayPhotos = groupedMap[date]!;
                return _buildDateGroup(date, dayPhotos);
              },
            ),
    );
  }

  Widget _buildDateGroup(DateTime date, List<HistoryPhoto> dayPhotos) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 12),
          child: Row(
            children: [
              const Icon(
                Icons.calendar_today_rounded,
                color: Color(0xFFFFB800),
                size: 16,
              ),
              const SizedBox(width: 8),
              Text(
                AppDateUtils.formatDate(date),
                style: const TextStyle(
                  color: Color(0xFFFFB800),
                  fontSize: 15,
                  fontWeight: FontWeight.w700,
                ),
              ),
              const SizedBox(width: 8),
              Text(
                '(${dayPhotos.length} ảnh)',
                style: const TextStyle(color: Colors.white54, fontSize: 13),
              ),
            ],
          ),
        ),
        ...dayPhotos.map((photo) => _buildPhotoTile(photo)),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildPhotoTile(HistoryPhoto photo) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => HistoryDetailScreen(photo: photo),
          ),
        );
      },
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF13132A),
          borderRadius: BorderRadius.circular(20),
          border: Border.all(color: const Color(0xFF2A2A44)),
        ),
        child: Row(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(14),
              child: SizedBox(
                width: 72,
                height: 72,
                child: _buildImage(photo.imagePath),
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    photo.caption.isEmpty
                        ? 'Không có chú thích'
                        : photo.caption,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: photo.caption.isEmpty
                          ? Colors.white54
                          : Colors.white,
                      fontSize: 15,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 6),
                  if (photo.recipients.isNotEmpty)
                    Text(
                      'Gửi tới: ${photo.recipients.join(", ")}',
                      style: const TextStyle(
                        color: Color(0x99FFFFFF),
                        fontSize: 12,
                      ),
                    ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Colors.white38,
              size: 16,
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
        fit: BoxFit.cover,
        errorBuilder: (_, __, ___) => _buildErrorContainer(),
      );
    }
    return Image.asset(
      path,
      fit: BoxFit.cover,
      errorBuilder: (_, __, ___) => _buildErrorContainer(),
    );
  }

  Widget _buildErrorContainer() {
    return Container(
      color: const Color(0xFF1C1C2E),
      child: const Icon(
        Icons.image_not_supported_rounded,
        color: Colors.white38,
      ),
    );
  }
}
