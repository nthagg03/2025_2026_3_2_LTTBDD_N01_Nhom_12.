import 'package:flutter_test/flutter_test.dart';
import 'package:locket/features/friends/services/friend_service.dart';

void main() {
  group('FriendService', () {
    late FriendService service;

    setUp(() {
      service = FriendService();
    });

    test('acceptRequest chuyển request sang friends', () async {
      final beforeRequests = await service.getIncomingRequests();
      final beforeFriends = await service.getFriends();
      expect(beforeRequests.isNotEmpty, isTrue);

      final req = beforeRequests.first;
      await service.acceptRequest(req.id);

      final afterRequests = await service.getIncomingRequests();
      final afterFriends = await service.getFriends();

      expect(afterRequests.any((r) => r.id == req.id), isFalse);
      expect(afterFriends.length, equals(beforeFriends.length + 1));
      expect(afterFriends.any((f) => f.name == req.fromUserName), isTrue);
    });

    test('declineRequest xóa request không thêm vào friends', () async {
      final beforeRequests = await service.getIncomingRequests();
      final beforeFriends = await service.getFriends();
      final req = beforeRequests.first;

      await service.declineRequest(req.id);

      final afterRequests = await service.getIncomingRequests();
      final afterFriends = await service.getFriends();

      expect(afterRequests.any((r) => r.id == req.id), isFalse);
      expect(afterFriends.length, equals(beforeFriends.length));
    });

    test('removeFriend xóa đúng người khỏi danh sách friends', () async {
      final friends = await service.getFriends();
      final target = friends.first;

      await service.removeFriend(target.id);

      final afterFriends = await service.getFriends();
      expect(afterFriends.any((f) => f.id == target.id), isFalse);
      expect(afterFriends.length, equals(friends.length - 1));
    });

    test('sendFriendRequest xóa khỏi suggestions và tạo outgoing request',
        () async {
      final suggestions = await service.getSuggestions();
      expect(suggestions.isNotEmpty, isTrue);
      final target = suggestions.first;

      await service.sendFriendRequest(target.id);

      final afterSuggestions = await service.getSuggestions();
      final outgoing = await service.getOutgoingRequests();

      expect(afterSuggestions.any((s) => s.id == target.id), isFalse);
      expect(outgoing.any((r) => r.fromUserName == target.name), isTrue);
    });
  });
}
