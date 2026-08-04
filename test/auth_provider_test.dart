import 'package:flutter_test/flutter_test.dart';
import 'package:locket/providers/auth_provider.dart';
import 'package:locket/repositories/fake_user_repository.dart';

void main() {
  group('AuthProvider & FakeUserRepository', () {
    final repo = FakeUserRepository();
    final authProvider = AuthProvider();

    test('login with valid credentials updates user state', () async {
      final success = await authProvider.login('demo@locket.gold', '123456');
      expect(success, isTrue);
      expect(authProvider.isAuthenticated, isTrue);
      expect(authProvider.currentUser?.email, 'demo@locket.gold');
    });

    test('register creates a new user and sets current user', () async {
      final success = await authProvider.register(
        username: 'Test User',
        email: 'testuser@locket.gold',
        password: 'password123',
      );
      expect(success, isTrue);
      expect(authProvider.isAuthenticated, isTrue);
      expect(authProvider.currentUser?.username, 'Test User');
      expect(authProvider.currentUser?.email, 'testuser@locket.gold');
    });

    test('logout clears user state', () async {
      await authProvider.logout();
      expect(authProvider.isAuthenticated, isFalse);
      expect(authProvider.currentUser, isNull);
    });
  });
}
