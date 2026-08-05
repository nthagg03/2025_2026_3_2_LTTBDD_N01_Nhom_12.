import 'package:flutter/material.dart';

import '../models/history_photo.dart';
import 'history_item.dart';

class HistoryGrid extends StatelessWidget {
  final List<HistoryPhoto> photos;

  const HistoryGrid({
    super.key,
    required this.photos,
  });

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: photos.length,
      gridDelegate:
          const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemBuilder: (_, index) {
        return HistoryItem(photo: photos[index]);
      },
    );
  }
}