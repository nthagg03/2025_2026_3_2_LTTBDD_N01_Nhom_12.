import 'package:flutter_test/flutter_test.dart';
import 'package:locket/features/history/models/history_photo.dart';
import 'package:locket/features/history/repositories/fake_history_repository.dart';
import 'package:locket/features/history/services/history_service.dart';

void main() {
  group('FakeHistoryRepository & HistoryService', () {
    final repo = FakeHistoryRepository.instance;
    final service = HistoryService.instance;

    test('service contains initial seed photos', () {
      final photos = repo.photos;
      expect(photos, isNotEmpty);
      expect(photos.first.id, isNotEmpty);
    });

    test('addPhoto adds new photo and findById returns it', () {
      final newPhoto = HistoryPhoto(
        id: 'hist_test_999',
        imagePath: 'lib/assets/imgs/testimg.jpg',
        caption: 'Test Memory Caption',
        createdAt: DateTime.now(),
        recipients: ['Tân'],
      );

      repo.addPhoto(newPhoto);

      final found = repo.findById('hist_test_999');
      expect(found, isNotNull);
      expect(found?.caption, equals('Test Memory Caption'));
      expect(found?.recipients, contains('Tân'));
    });

    test('removePhoto deletes target photo', () {
      repo.removePhoto('hist_test_999');
      final found = repo.findById('hist_test_999');
      expect(found, isNull);
    });
  });
}
