class HistoryPhoto {
  final String id;
  final String imagePath;
  final String caption;
  final DateTime createdAt;
  final List<String> recipients;
  final bool isMine;

  const HistoryPhoto({
    required this.id,
    required this.imagePath,
    required this.caption,
    required this.createdAt,
    required this.recipients,
    this.isMine = true,
  });

  HistoryPhoto copyWith({
    String? id,
    String? imagePath,
    String? caption,
    DateTime? createdAt,
    List<String>? recipients,
    bool? isMine,
  }) {
    return HistoryPhoto(
      id: id ?? this.id,
      imagePath: imagePath ?? this.imagePath,
      caption: caption ?? this.caption,
      createdAt: createdAt ?? this.createdAt,
      recipients: recipients ?? this.recipients,
      isMine: isMine ?? this.isMine,
    );
  }
}