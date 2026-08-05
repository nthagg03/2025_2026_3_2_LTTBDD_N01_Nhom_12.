class AppSettingsModel {
  final bool pushNotifications;
  final bool soundEnabled;
  final bool vibrationEnabled;
  final bool privateAccount;
  final bool saveToGallery;

  const AppSettingsModel({
    this.pushNotifications = true,
    this.soundEnabled = true,
    this.vibrationEnabled = true,
    this.privateAccount = false,
    this.saveToGallery = true,
  });

  AppSettingsModel copyWith({
    bool? pushNotifications,
    bool? soundEnabled,
    bool? vibrationEnabled,
    bool? privateAccount,
    bool? saveToGallery,
  }) {
    return AppSettingsModel(
      pushNotifications: pushNotifications ?? this.pushNotifications,
      soundEnabled: soundEnabled ?? this.soundEnabled,
      vibrationEnabled: vibrationEnabled ?? this.vibrationEnabled,
      privateAccount: privateAccount ?? this.privateAccount,
      saveToGallery: saveToGallery ?? this.saveToGallery,
    );
  }
}
