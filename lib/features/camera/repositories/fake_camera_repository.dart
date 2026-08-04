import '../models/capture_result.dart';

class FakeCameraRepository {
  final List<CaptureResult> uploads = [];

  Future<void> upload(CaptureResult capture) async {
    await Future.delayed(const Duration(seconds: 2));
    uploads.add(capture);
  }
}