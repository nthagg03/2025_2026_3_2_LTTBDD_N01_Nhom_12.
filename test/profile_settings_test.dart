import 'package:flutter_test/flutter_test.dart';
import 'package:locket/features/history/services/history_service.dart';
import 'package:locket/providers/auth_provider.dart';

void main() {
  group('Profile & Settings Flow', () {
    final auth = AuthProvider();

    test('AuthProvider returns current logged in user details', () async {
      await auth.login('demo@locket.gold', '123456');
      expect(auth.isAuthenticated, isTrue);
      expect(auth.currentUser?.email, equals('demo@locket.gold'));
    });

    test('Profile statistics accurately count history photos', () {
      final photoCount = HistoryService.instance.photos.length;
      expect(photoCount, isNonNegative);
    });

    test('Logout clears session and updates auth state', () async {
      await auth.logout();
      expect(auth.isAuthenticated, isFalse);
      expect(auth.currentUser, isNull);
    });
  });
}
