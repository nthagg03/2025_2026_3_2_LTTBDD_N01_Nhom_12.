import 'dart:io';

class CaptureResult {
  final File image;
  final String? caption;
  final List<String> recipients;

  CaptureResult({
    required this.image,
    this.caption,
    this.recipients = const [],
  });
}