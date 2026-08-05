import '../models/app_user.dart';

class FakeUserRepository {
  static final FakeUserRepository _instance = FakeUserRepository._internal();
  factory FakeUserRepository() => _instance;
  FakeUserRepository._internal();

  final List<AppUser> _users = [
    AppUser(
      id: 'user_1',
      username: 'Demo User',
      email: 'demo@locket.gold',
      createdAt: DateTime.now().subtract(const Duration(days: 30)),
    ),
    AppUser(
      id: 'user_2',
      username: 'Tân',
      email: 'tan@locket.gold',
      createdAt: DateTime.now().subtract(const Duration(days: 20)),
    ),
    AppUser(
      id: 'user_3',
      username: 'Nam',
      email: 'nam@locket.gold',
      createdAt: DateTime.now().subtract(const Duration(days: 15)),
    ),
  ];

  AppUser? _currentUser;
  AppUser? get currentUser => _currentUser;

  Future<AppUser> login({
    required String email,
    required String password,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final matchingUser = _users.firstWhere(
      (user) => user.email.toLowerCase() == email.trim().toLowerCase(),
      orElse: () {
        final newUser = AppUser(
          id: 'user_${DateTime.now().millisecondsSinceEpoch}',
          username: email.split('@').first,
          email: email.trim(),
          password: password,
          createdAt: DateTime.now(),
        );
        _users.add(newUser);
        return newUser;
      },
    );
    _currentUser = matchingUser;
    return matchingUser;
  }

  Future<AppUser> register({
    required String username,
    required String email,
    required String password,
    String? avatarUrl,
  }) async {
    await Future.delayed(const Duration(milliseconds: 500));
    final newUser = AppUser(
      id: 'user_${DateTime.now().millisecondsSinceEpoch}',
      username: username.trim(),
      email: email.trim(),
      password: password,
      avatarUrl: avatarUrl,
      createdAt: DateTime.now(),
    );
    _users.add(newUser);
    _currentUser = newUser;
    return newUser;
  }

  Future<void> logout() async {
    await Future.delayed(const Duration(milliseconds: 200));
    _currentUser = null;
  }
}
