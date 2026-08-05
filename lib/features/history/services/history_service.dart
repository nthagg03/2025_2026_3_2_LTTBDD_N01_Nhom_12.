import 'package:flutter/foundation.dart';

import '../models/history_photo.dart';

class HistoryService extends ChangeNotifier {
  HistoryService._() {
    _photos.addAll([
      // Tháng 1 2026
      HistoryPhoto(
        id: 'hist_jan_15',
        imagePath: 'lib/assets/imgs/IMG_0016.JPG',
        caption: '',
        createdAt: DateTime(2026, 1, 15),
        recipients: const ['Wxrdie 👹'],
        isMine: false,
      ),
      HistoryPhoto(
        id: 'hist_jan_26',
        imagePath: 'lib/assets/imgs/IMG_0357.JPG',
        caption: 'Hết tiền',
        createdAt: DateTime(2026, 1, 26),
        recipients: const ['TLinh 👑'],
        isMine: true,
      ),

      // Tháng 2 2026
      HistoryPhoto(
        id: 'hist_feb_14',
        imagePath: 'lib/assets/imgs/IMG_0460.JPG',
        caption: 'Best duo 💖',
        createdAt: DateTime(2026, 2, 14),
        recipients: const ['VuPhuong'],
        isMine: false,
      ),
      HistoryPhoto(
        id: 'hist_feb_20',
        imagePath: 'lib/assets/imgs/IMG_0473.JPG',
        caption: 'In another life😭',
        createdAt: DateTime(2026, 2, 20),
        recipients: const ['MCK 🎤'],
        isMine: false,
      ),

      // Tháng 3 2026
      HistoryPhoto(
        id: 'hist_mar_3',
        imagePath: 'lib/assets/imgs/IMG_0559.PNG',
        caption: 'SPIDERMANNNNNNNNNNNNNNNN',
        createdAt: DateTime(2026, 3, 3),
        recipients: const ['Nam'],
        isMine: true,
      ),
      HistoryPhoto(
        id: 'hist_mar_8',
        imagePath: 'lib/assets/imgs/XCXS0510.JPG',
        caption: 'Babi dont cry',
        createdAt: DateTime(2026, 3, 8),
        recipients: const ['TLinh 👑'],
        isMine: false,
      ),
      HistoryPhoto(
        id: 'hist_mar_21',
        imagePath: 'lib/assets/imgs/testimg.jpg',
        caption: 'núi phú sĩ',
        createdAt: DateTime(2026, 3, 21),
        recipients: const ['Wxrdie 👹'],
        isMine: true,
      ),

      // Tháng 4 2026
      HistoryPhoto(
        id: 'hist_apr_8',
        imagePath: 'lib/assets/imgs/IMG_0016.JPG',
        caption: 'Làm tách trà chiều 🍵',
        createdAt: DateTime(2026, 4, 8),
        recipients: const ['Nam'],
        isMine: false,
      ),
      HistoryPhoto(
        id: 'hist_apr_30',
        imagePath: 'lib/assets/imgs/IMG_0357.JPG',
        caption: 'Nghỉ lễ 30/4 🎆',
        createdAt: DateTime(2026, 4, 30),
        recipients: const ['VuPhuong', 'MCK 🎤'],
        isMine: true,
      ),

      // Tháng 5 2026
      HistoryPhoto(
        id: 'hist_may_1',
        imagePath: 'lib/assets/imgs/IMG_0460.JPG',
        caption: 'Chào tháng 5 🌿',
        createdAt: DateTime(2026, 5, 1),
        recipients: const ['TLinh 👑'],
        isMine: false,
      ),
      HistoryPhoto(
        id: 'hist_may_19',
        imagePath: 'lib/assets/imgs/IMG_0473.JPG',
        caption: 'Hồ Tây chiều lộng gió 🌅',
        createdAt: DateTime(2026, 5, 19),
        recipients: const ['Wxrdie 👹'],
        isMine: false,
      ),

      // Tháng 6 2026
      HistoryPhoto(
        id: 'hist_jun_4',
        imagePath: 'lib/assets/imgs/IMG_0559.PNG',
        caption: 'Bắt đầu mùa hè ☀️',
        createdAt: DateTime(2026, 6, 4),
        recipients: const ['Nam'],
        isMine: true,
      ),
      HistoryPhoto(
        id: 'hist_jun_22',
        imagePath: 'lib/assets/imgs/XCXS0510.JPG',
        caption: 'Du lịch biển 🏖️',
        createdAt: DateTime(2026, 6, 22),
        recipients: const ['MCK 🎤', 'VuPhuong'],
        isMine: false,
      ),

      // Tháng 7 2026
      HistoryPhoto(
        id: 'hist_jul_5',
        imagePath: 'lib/assets/imgs/IMG_0016.JPG',
        caption: 'Đồ nướng đêm 🍡',
        createdAt: DateTime(2026, 7, 5),
        recipients: const ['Wxrdie 👹'],
        isMine: false,
      ),
      HistoryPhoto(
        id: 'hist_jul_12',
        imagePath: 'lib/assets/imgs/IMG_0357.JPG',
        caption: 'Chiều mưa hò hẹn 🌧️',
        createdAt: DateTime(2026, 7, 12),
        recipients: const ['TLinh 👑'],
        isMine: true,
      ),
      HistoryPhoto(
        id: 'hist_jul_20',
        imagePath: 'lib/assets/imgs/IMG_0460.JPG',
        caption: 'Vịt quay lá móc mật 🍗',
        createdAt: DateTime(2026, 7, 20),
        recipients: const ['MCK 🎤'],
        isMine: false,
      ),

      // Tháng 8 2026
      HistoryPhoto(
        id: 'hist_aug_2',
        imagePath: 'lib/assets/imgs/IMG_0473.JPG',
        caption: 'Hôm nay lướt phố 🛵',
        createdAt: DateTime(2026, 8, 2),
        recipients: const ['Nam', 'VuPhuong'],
        isMine: false,
      ),
      HistoryPhoto(
        id: 'hist_aug_3',
        imagePath: 'lib/assets/imgs/IMG_0559.PNG',
        caption: 'Cùng ăn lẩu nấm 🍲',
        createdAt: DateTime(2026, 8, 3),
        recipients: const ['Wxrdie 👹'],
        isMine: false,
      ),
      HistoryPhoto(
        id: 'hist_aug_4',
        imagePath: 'lib/assets/imgs/XCXS0510.JPG',
        caption: 'Lên xe đi dạo 🚲',
        createdAt: DateTime(2026, 8, 4),
        recipients: const ['Nam'],
        isMine: true,
      ),
    ]);


  }

  static final HistoryService instance = HistoryService._();

  final List<HistoryPhoto> _photos = [];

  int get appDays => 359;
  int get streakDays => 0;

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