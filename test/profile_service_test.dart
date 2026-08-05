import 'package:flutter_test/flutter_test.dart';
import 'package:locket/features/profile/services/profile_service.dart';

void main() {
  group('ProfileService', () {
    late ProfileService service;

    setUp(() {
      service = ProfileService();
    });

    test('updateProfile chỉ đổi name, giữ nguyên các field khác', () async {
      final before = await service.getProfile();
      final after = await service.updateProfile(name: 'Tên Mới');

      expect(after.name, equals('Tên Mới'));
      expect(after.bio, equals(before.bio));
      expect(after.username, equals(before.username));
      expect(after.friendCount, equals(before.friendCount));
      expect(after.streakDays, equals(before.streakDays));
    });

    test('updateProfile chỉ đổi bio, giữ nguyên các field khác', () async {
      final before = await service.getProfile();
      const newBio = 'Bio mới tiếng Việt 🎯';
      final after = await service.updateProfile(bio: newBio);

      expect(after.bio, equals(newBio));
      expect(after.name, equals(before.name));
      expect(after.username, equals(before.username));
    });

    test('updateProfile với null giữ nguyên field', () async {
      final before = await service.getProfile();
      final after = await service.updateProfile();

      expect(after.name, equals(before.name));
      expect(after.bio, equals(before.bio));
    });
  });
}
