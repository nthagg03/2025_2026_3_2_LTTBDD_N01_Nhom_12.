class AppUser {
  final String email;
  final String password;
  final DateTime createdAt;
  final String? id;
  final String? username;
  final String? avatarUrl;

  const AppUser({
    required this.email,
    this.password = '',
    required this.createdAt,
    this.id,
    this.username,
    this.avatarUrl,
  });
}
