import 'package:flutter/foundation.dart';
import '../models/app_user.dart';
import '../repositories/fake_user_repository.dart';

class AuthProvider extends ChangeNotifier {
  final FakeUserRepository _repository = FakeUserRepository();

  AppUser? get currentUser => _repository.currentUser;
  bool get isAuthenticated => _repository.currentUser != null;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<bool> login(String email, String password) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _repository.login(email: email, password: password);
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (_) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<bool> register({
    required String username,
    required String email,
    required String password,
    String? avatarUrl,
  }) async {
    _isLoading = true;
    notifyListeners();
    try {
      await _repository.register(
        username: username,
        email: email,
        password: password,
        avatarUrl: avatarUrl,
      );
      _isLoading = false;
      notifyListeners();
      return true;
    } catch (_) {
      _isLoading = false;
      notifyListeners();
      return false;
    }
  }

  Future<void> logout() async {
    await _repository.logout();
    notifyListeners();
  }
}
