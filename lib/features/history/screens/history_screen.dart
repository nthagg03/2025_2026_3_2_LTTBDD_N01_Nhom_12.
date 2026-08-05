import 'dart:io';

import 'package:flutter/material.dart';

import '../../../routes/app_routes.dart';
import '../models/history_photo.dart';
import '../services/history_service.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => _HistoryScreenState();
}

class _HistoryScreenState extends State<HistoryScreen> {
  final history = HistoryService.instance;
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    history.addListener(_refresh);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.jumpTo(_scrollController.position.maxScrollExtent);
      }
    });
  }

  @override
  void dispose() {
    history.removeListener(_refresh);
    _scrollController.dispose();
    super.dispose();
  }

  void _refresh() {
    if (mounted) setState(() {});
  }

  Widget _buildPhotoThumbnail(HistoryPhoto photo, {double size = 44}) {
    final path = photo.imagePath;
    Widget img;
    bool exists = false;
    if (path.isNotEmpty) {
      try {
        exists = File(path).existsSync();
      } catch (_) {}
    }

    if (path.startsWith('lib/') || path.startsWith('assets/')) {
      img = Image.asset(
        path,
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            _buildPlaceholderSquare(size),
      );
    } else if (exists) {
      img = Image.file(
        File(path),
        fit: BoxFit.cover,
        errorBuilder: (context, error, stackTrace) =>
            _buildPlaceholderSquare(size),
      );
    } else {
      img = _buildPlaceholderSquare(size);
    }

    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(width: size, height: size, child: img),
    );
  }


  Widget _buildPlaceholderSquare(double size) {
    return Container(
      width: size,
      height: size,
      color: const Color(0xFF1B3828),
      child: const Icon(Icons.photo_rounded, color: Colors.white24, size: 16),
    );
  }

  // Wavy connector line "⌇"
  Widget _buildWavyConnector() {
    return const Padding(
      padding: EdgeInsets.symmetric(vertical: 8),
      child: Center(
        child: Text(
          '⌇',
          style: TextStyle(
            color: Color(0x66FFFFFF),
            fontSize: 22,
            fontWeight: FontWeight.w300,
            letterSpacing: 2,
          ),
        ),
      ),
    );
  }

  // Section 2: Month Calendar Card (Dynamic Month & Year)
  Widget _buildCalendarCard(
    List<HistoryPhoto> allPhotos, {
    required int month,
    required int year,
  }) {
    final monthPhotos = allPhotos
        .where((p) => p.createdAt.year == year && p.createdAt.month == month)
        .toList();
    final totalDays = DateTime(year, month + 1, 0).day;
    final now = DateTime.now();
    final isCurrentMonth = (year == now.year && month == now.month);
    final today = now.day;

    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: const Color(0xFF0F2218),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: Colors.white.withValues(alpha: 0.05)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(18, 16, 18, 14),
            child: Text(
              'tháng $month $year',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 17,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 18),
            child: LayoutBuilder(
              builder: (context, constraints) {
                final itemSize = (constraints.maxWidth - (6 * 8)) / 7;

                return Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: List.generate(totalDays, (index) {
                    final day = index + 1;

                    // 1. Strictly NO photos after current day (Today)
                    final bool isFuture =
                        (year > now.year) ||
                        (year == now.year && month > now.month) ||
                        (isCurrentMonth && day > today);

                    if (isFuture) {
                      return Container(
                        width: itemSize,
                        height: itemSize,
                        decoration: BoxDecoration(
                          color: const Color(0xFF162D1F),
                          borderRadius: BorderRadius.circular(10),
                        ),
                      );
                    }

                    // 2. Check for photo on this day
                    final dayPhoto = monthPhotos.firstWhere(
                      (p) => p.createdAt.day == day,
                      orElse: () => HistoryPhoto(
                        id: '',
                        imagePath: '',
                        caption: '',
                        createdAt: DateTime(1970),
                        recipients: const [],
                      ),
                    );

                    // 3. Photo exists -> display photo thumbnail (replaces yellow + box if today)
                    if (dayPhoto.id.isNotEmpty) {
                      return _buildPhotoThumbnail(dayPhoto, size: itemSize);
                    }

                    // 4. Current day with NO photo -> display Yellow + box
                    if (isCurrentMonth && day == today) {
                      return GestureDetector(
                        onTap: () => Navigator.pop(context),
                        child: Container(
                          width: itemSize,
                          height: itemSize,
                          decoration: BoxDecoration(
                            color: const Color(0xFF173322),
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: const Color(0xFFFFB800),
                              width: 2,
                            ),
                          ),
                          child: const Icon(
                            Icons.add_rounded,
                            color: Color(0xFFFFB800),
                            size: 20,
                          ),
                        ),
                      );
                    }

                    // 5. Past day with no photo
                    return Container(
                      width: itemSize,
                      height: itemSize,
                      decoration: BoxDecoration(
                        color: const Color(0xFF162D1F),
                        borderRadius: BorderRadius.circular(10),
                      ),
                    );
                  }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }


  // Section 3: Engagement & Streak Stats Badge
  Widget _buildStatsPill() {
    return Center(
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF13281C),
          borderRadius: BorderRadius.circular(24),
          border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text('💛 ', style: TextStyle(fontSize: 14)),
            Text(
              '${history.appDays} Locket',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                '|',
                style: TextStyle(color: Colors.white24, fontSize: 14),
              ),
            ),
            const Text('🔥 ', style: TextStyle(fontSize: 14)),
            Text(
              '${history.streakDays}d chuỗi',
              style: const TextStyle(
                color: Colors.white,
                fontSize: 14,
                fontWeight: FontWeight.w700,
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Section 4: Bottom Navigation Dock
  Widget _buildBottomDock() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF1E1E24),
        borderRadius: BorderRadius.circular(30),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Icon(
              Icons.grid_view_rounded,
              color: Colors.white,
              size: 22,
            ),
          ),
          const SizedBox(width: 6),
          IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.home_rounded,
              color: Colors.white60,
              size: 22,
            ),
          ),
          const SizedBox(width: 6),
          IconButton(
            onPressed: () => Navigator.pushNamed(context, AppRoutes.feed),
            icon: const Icon(
              Icons.chat_bubble_rounded,
              color: Colors.white60,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final allPhotos = history.photos;

    return Scaffold(
      backgroundColor: const Color(0xFF07140B),
      body: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onHorizontalDragEnd: (details) {
          if (details.primaryVelocity != null &&
              details.primaryVelocity! < -150) {
            // Swipe LEFT on HistoryScreen -> return to CameraScreen
            Navigator.pop(context);
          }
        },
        child: SafeArea(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 10),
                child: Row(
                  children: [
                    const SizedBox(width: 38),
                    const Spacer(),
                    const Text(
                      'Kỷ niệm',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 18,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                    const Spacer(),
                    GestureDetector(
                      onTap: () =>
                          Navigator.pushNamed(context, AppRoutes.profile),
                      child: Container(
                        width: 38,
                        height: 38,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white30, width: 2),
                          color: const Color(0xFF1E3A2B),
                        ),
                        child: const ClipOval(
                          child: Icon(
                            Icons.person_rounded,
                            color: Colors.white,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: ListView(
                  controller: _scrollController,
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  children: [
                    const SizedBox(height: 8),

                    // Calendar cards for months 1 up to 8
                    ...List.generate(8, (i) {
                      final m = i + 1; // 1 up to 8 (older to newest)
                      return Column(
                        children: [
                          _buildCalendarCard(allPhotos, month: m, year: 2026),
                          _buildWavyConnector(),
                        ],
                      );
                    }),

                    _buildStatsPill(),
                    const SizedBox(height: 16),
                  ],
                ),
              ),

              _buildBottomDock(),
              const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
