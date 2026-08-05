import 'dart:io';

import 'package:flutter/material.dart';

import '../models/history_photo.dart';
import '../screens/history_detail_screen.dart';

class HistoryItem extends StatelessWidget {
  final HistoryPhoto photo;

  const HistoryItem({
    super.key,
    required this.photo,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => HistoryDetailScreen(photo: photo),
          ),
        );
      },
      child: Hero(
        tag: photo.id,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(16),
          child: AspectRatio(
            aspectRatio: 1,
            child: _buildImage(photo.imagePath),
          ),
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
      color: Colors.grey.shade900,
      child: const Icon(
        Icons.image_not_supported,
        color: Colors.white54,
      ),
    );
  }
}