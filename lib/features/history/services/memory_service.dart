import '../models/memory_model.dart';

class MemoryService {
  static final List<MemoryModel> _memories = [
    MemoryModel(
      id: 'mem_1',
      imageUrl: 'lib/assets/imgs/testimg.jpg',
      caption: 'Khoảnh khắc hoàng hôn tuyệt đẹp',
      date: DateTime.now().subtract(const Duration(hours: 3)),
      recipients: ['Tân', 'Nam'],
    ),
    MemoryModel(
      id: 'mem_2',
      imageUrl: 'lib/assets/imgs/testimg.jpg',
      caption: 'Buổi chiều bình yên tại quán nhỏ',
      date: DateTime.now().subtract(const Duration(days: 1)),
      recipients: ['Thắng'],
    ),
    MemoryModel(
      id: 'mem_3',
      imageUrl: 'lib/assets/imgs/testimg.jpg',
      caption: 'Cùng hội bạn thân đi biển 🏖️',
      date: DateTime.now().subtract(const Duration(days: 3)),
      recipients: ['An Thuyên', 'Nam', 'Tân'],
    ),
    MemoryModel(
      id: 'mem_4',
      imageUrl: 'lib/assets/imgs/testimg.jpg',
      caption: 'Tách cà phê ngon nhất tuần',
      date: DateTime.now().subtract(const Duration(days: 5)),
      recipients: ['Tân'],
    ),
  ];

  Future<List<MemoryModel>> getMemories() async {
    await Future.delayed(const Duration(milliseconds: 300));
    return List.from(_memories);
  }

  Future<bool> deleteMemory(String id) async {
    await Future.delayed(const Duration(milliseconds: 300));
    _memories.removeWhere((m) => m.id == id);
    return true;
  }
}
