import '../models/app_user.dart';

class AuthRepository {
  static final AuthRepository instance = AuthRepository._internal();
  factory AuthRepository() => instance;
  AuthRepository._internal() {
    _seedUsers();
  }

  final Map<String, AppUser> _users = {};

  void _seedUsers() {
    final seedUsers = [
      AppUser(
        email: 'test@locket.com',
        password: '12345678',
        createdAt: DateTime.now().subtract(const Duration(days: 30)),
      ),
      AppUser(
        email: 'admin@gmail.com',
        password: '12345678',
        createdAt: DateTime.now().subtract(const Duration(days: 20)),
      ),
      AppUser(
        email: 'user@gmail.com',
        password: '12345678',
        createdAt: DateTime.now().subtract(const Duration(days: 15)),
      ),
      AppUser(
        email: 'nam@gmail.com',
        password: '12345678',
        createdAt: DateTime.now().subtract(const Duration(days: 10)),
      ),
      AppUser(
        email: 'vuphuong@gmail.com',
        password: '12345678',
        createdAt: DateTime.now().subtract(const Duration(days: 5)),
      ),
    ];

    for (final user in seedUsers) {
      _users[user.email.toLowerCase()] = user;
    }
  }

  Future<bool> emailExists(String email) async {
    await Future.delayed(const Duration(milliseconds: 400));
    return _users.containsKey(email.trim().toLowerCase());
  }

  Future<AppUser> register(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final normalizedEmail = email.trim().toLowerCase();
    if (_users.containsKey(normalizedEmail)) {
      throw Exception('Email đã tồn tại trong hệ thống');
    }
    final newUser = AppUser(
      email: email.trim(),
      password: password,
      createdAt: DateTime.now(),
    );
    _users[normalizedEmail] = newUser;
    return newUser;
  }

  Future<bool> validatePassword(String email, String password) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final normalizedEmail = email.trim().toLowerCase();
    final user = _users[normalizedEmail];
    if (user == null) return false;
    return user.password == password;
  }

  Future<void> resetPassword(String email, String newPassword) async {
    await Future.delayed(const Duration(milliseconds: 400));
    final normalizedEmail = email.trim().toLowerCase();
    final user = _users[normalizedEmail];
    if (user == null) {
      throw Exception('Email không tồn tại trong hệ thống');
    }
    _users[normalizedEmail] = AppUser(
      email: user.email,
      password: newPassword,
      createdAt: user.createdAt,
      id: user.id,
      username: user.username,
      avatarUrl: user.avatarUrl,
    );
  }
}
