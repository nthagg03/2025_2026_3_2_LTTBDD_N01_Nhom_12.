class AppUser {
  final String id;
  final String username;
  final String email;
  final String? avatarUrl;
  final DateTime createdAt;

  const AppUser({
    required this.id,
    required this.username,
    required this.email,
    this.avatarUrl,
    required this.createdAt,
  });
}
