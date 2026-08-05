import '../../features/history/models/history_photo.dart';

class FakeHistoryRepository {
  FakeHistoryRepository._();

  static final FakeHistoryRepository instance =
      FakeHistoryRepository._();

  final List<HistoryPhoto> _photos = [];

  List<HistoryPhoto> get photos =>
      List.unmodifiable(_photos.reversed);

  void addPhoto(HistoryPhoto photo) {
    _photos.add(photo);
  }

  void removePhoto(String id) {
    _photos.removeWhere((e) => e.id == id);
  }

  void clear() {
    _photos.clear();
  }

  HistoryPhoto? findById(String id) {
    try {
      return _photos.firstWhere((e) => e.id == id);
    } catch (_) {
      return null;
    }
  }
}