class MemoryModel {
  final String id;
  final String imageUrl;
  final String caption;
  final DateTime date;
  final List<String> recipients;

  const MemoryModel({
    required this.id,
    required this.imageUrl,
    required this.caption,
    required this.date,
    required this.recipients,
  });
}
