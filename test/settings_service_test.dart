import 'package:flutter_test/flutter_test.dart';
import 'package:locket/features/settings/services/settings_service.dart';

void main() {
  group('SettingsService', () {
    late SettingsService service;

    setUp(() {
      service = SettingsService();
    });

    test('togglePushNotifications chỉ đổi đúng field đó', () async {
      final before = await service.getSettings();
      final after =
          await service.togglePushNotifications(!before.pushNotifications);
      expect(after.pushNotifications, equals(!before.pushNotifications));
      expect(after.soundEnabled, equals(before.soundEnabled));
      expect(after.vibrationEnabled, equals(before.vibrationEnabled));
      expect(after.privateAccount, equals(before.privateAccount));
      expect(after.saveToGallery, equals(before.saveToGallery));
    });

    test('toggleSound chỉ đổi soundEnabled, giữ nguyên các field khác',
        () async {
      final before = await service.getSettings();
      final after = await service.toggleSound(!before.soundEnabled);
      expect(after.soundEnabled, equals(!before.soundEnabled));
      expect(after.pushNotifications, equals(before.pushNotifications));
      expect(after.vibrationEnabled, equals(before.vibrationEnabled));
    });

    test('toggleVibration chỉ đổi vibrationEnabled', () async {
      final before = await service.getSettings();
      final after = await service.toggleVibration(!before.vibrationEnabled);
      expect(after.vibrationEnabled, equals(!before.vibrationEnabled));
      expect(after.soundEnabled, equals(before.soundEnabled));
    });

    test('togglePrivateAccount chỉ đổi privateAccount', () async {
      final before = await service.getSettings();
      final after =
          await service.togglePrivateAccount(!before.privateAccount);
      expect(after.privateAccount, equals(!before.privateAccount));
      expect(after.pushNotifications, equals(before.pushNotifications));
    });

    test('toggleSaveToGallery chỉ đổi saveToGallery', () async {
      final before = await service.getSettings();
      final after =
          await service.toggleSaveToGallery(!before.saveToGallery);
      expect(after.saveToGallery, equals(!before.saveToGallery));
      expect(after.vibrationEnabled, equals(before.vibrationEnabled));
    });
  });
}
