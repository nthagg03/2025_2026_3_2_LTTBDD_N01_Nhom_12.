import 'dart:io';
import 'package:flutter_test/flutter_test.dart';
import 'package:locket/features/history/models/history_photo.dart';
import 'package:locket/features/history/services/history_service.dart';

void main() {
  group('Camera Upload & Memory History Flow', () {
    test('adding photo to HistoryService updates memories count', () {
      final initialCount = HistoryService.instance.photos.length;

      final photo = HistoryPhoto(
        id: 'test_photo_1',
        imagePath: '/tmp/test.jpg',
        caption: 'Beautiful moment',
        createdAt: DateTime.now(),
        recipients: ['Tân', 'Nam'],
        isMine: true,
      );

      HistoryService.instance.addPhoto(photo);

      expect(HistoryService.instance.photos.length, equals(initialCount + 1));
      expect(HistoryService.instance.photos.first.caption, equals('Beautiful moment'));
      expect(HistoryService.instance.photos.first.recipients, contains('Tân'));
    });
  });
}
