import '../models/profile_model.dart';

class ProfileService {
  ProfileService() {
    _profile = ProfileModel(
      name: 'Nguyễn Văn Demo',
      username: 'demo.user',
      avatar: 'D',
      bio: 'Yêu thích chia sẻ khoảnh khắc đẹp với bạn bè 📸',
      friendCount: 4,
      postCount: 12,
      streakDays: 7,
      joinedAt: DateTime(2025, 9, 1),
    );
  }

  late ProfileModel _profile;

  Future<ProfileModel> getProfile() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return _profile;
  }

  Future<ProfileModel> updateProfile({
    String? name,
    String? bio,
  }) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _profile = _profile.copyWith(name: name, bio: bio);
    return _profile;
  }
}
