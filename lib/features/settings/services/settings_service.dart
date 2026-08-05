import '../models/settings_model.dart';

class SettingsService {
  SettingsService() {
    _settings = const AppSettingsModel();
  }

  late AppSettingsModel _settings;

  Future<AppSettingsModel> getSettings() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _settings;
  }

  Future<AppSettingsModel> togglePushNotifications(bool value) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _settings = _settings.copyWith(pushNotifications: value);
    return _settings;
  }

  Future<AppSettingsModel> toggleSound(bool value) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _settings = _settings.copyWith(soundEnabled: value);
    return _settings;
  }

  Future<AppSettingsModel> toggleVibration(bool value) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _settings = _settings.copyWith(vibrationEnabled: value);
    return _settings;
  }

  Future<AppSettingsModel> togglePrivateAccount(bool value) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _settings = _settings.copyWith(privateAccount: value);
    return _settings;
  }

  Future<AppSettingsModel> toggleSaveToGallery(bool value) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _settings = _settings.copyWith(saveToGallery: value);
    return _settings;
  }
}
