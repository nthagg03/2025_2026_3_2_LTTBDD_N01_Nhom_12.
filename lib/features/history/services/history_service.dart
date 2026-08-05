import 'package:flutter/foundation.dart';

import '../models/history_photo.dart';

class HistoryService extends ChangeNotifier {
  HistoryService._() {
    _photos.addAll([
      HistoryPhoto(
        id: 'hist_1',
        imagePath: 'lib/assets/imgs/testimg.jpg',
        caption: 'Bãi biển chiều hoàng hôn 🌊',
        createdAt: DateTime.now().subtract(const Duration(hours: 3)),
        recipients: const ['Tân', 'Nam'],
        isMine: true,
      ),
      HistoryPhoto(
        id: 'hist_2',
        imagePath: 'lib/assets/imgs/testimg.jpg',
        caption: 'Cà phê sáng ☕',
        createdAt: DateTime.now().subtract(const Duration(days: 1)),
        recipients: const ['Thắng'],
        isMine: true,
      ),
      HistoryPhoto(
        id: 'hist_3',
        imagePath: 'lib/assets/imgs/testimg.jpg',
        caption: 'Bữa tối cùng gia đình 🍕',
        createdAt: DateTime.now().subtract(const Duration(days: 2)),
        recipients: const ['An Thuyên', 'Tân'],
        isMine: true,
      ),
      HistoryPhoto(
        id: 'hist_4',
        imagePath: 'lib/assets/imgs/testimg.jpg',
        caption: 'Cuối tuần dã ngoại ⛺',
        createdAt: DateTime.now().subtract(const Duration(days: 4)),
        recipients: const ['Nam', 'Thắng'],
        isMine: true,
      ),
    ]);
  }

  static final HistoryService instance = HistoryService._();

  final List<HistoryPhoto> _photos = [];

  List<HistoryPhoto> get photos => List.unmodifiable(_photos.reversed);

  void addPhoto(HistoryPhoto photo) {
    _photos.add(photo);
    notifyListeners();
  }

  void deletePhoto(String id) {
    _photos.removeWhere((e) => e.id == id);
    notifyListeners();
  }

  void clear() {
    _photos.clear();
    notifyListeners();
  }

  HistoryPhoto? getById(String id) {
    try {
      return _photos.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }
}