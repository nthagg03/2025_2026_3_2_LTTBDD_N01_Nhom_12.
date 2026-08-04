import '../models/history_photo.dart';
import '../services/history_service.dart';

class FakeHistoryRepository {
  FakeHistoryRepository._();

  static final FakeHistoryRepository instance = FakeHistoryRepository._();

  List<HistoryPhoto> get photos => HistoryService.instance.photos;

  void addPhoto(HistoryPhoto photo) {
    HistoryService.instance.addPhoto(photo);
  }

  void removePhoto(String id) {
    HistoryService.instance.deletePhoto(id);
  }

  void clear() {
    HistoryService.instance.clear();
  }

  HistoryPhoto? findById(String id) {
    return HistoryService.instance.getById(id);
  }
}