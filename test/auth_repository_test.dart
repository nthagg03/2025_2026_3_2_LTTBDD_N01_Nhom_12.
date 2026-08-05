import 'package:flutter_test/flutter_test.dart';
import 'package:locket/repositories/auth_repository.dart';

void main() {
  group('AuthRepository', () {
    late AuthRepository repository;

    setUp(() {
      repository = AuthRepository();
    });

    test('emailExists trả true với email đã seed, false với email lạ', () async {
      final exists = await repository.emailExists('test@locket.com');
      final notExists = await repository.emailExists('unknown@locket.com');

      expect(exists, isTrue);
      expect(notExists, isFalse);
    });

    test('register thêm user mới thành công và emailExists trả true sau đó', () async {
      const newEmail = 'newuser@locket.com';
      const pass = '87654321';

      final beforeExists = await repository.emailExists(newEmail);
      expect(beforeExists, isFalse);

      final user = await repository.register(newEmail, pass);
      expect(user.email, equals(newEmail));
      expect(user.password, equals(pass));

      final afterExists = await repository.emailExists(newEmail);
      expect(afterExists, isTrue);
    });

    test('register với email đã tồn tại phải ném lỗi', () async {
      expect(
        () async => await repository.register('test@locket.com', 'password123'),
        throwsA(isA<Exception>()),
      );
    });

    test('validatePassword trả true khi đúng mật khẩu, false khi sai', () async {
      final valid = await repository.validatePassword('test@locket.com', '12345678');
      final invalid = await repository.validatePassword('test@locket.com', 'wrongpass');

      expect(valid, isTrue);
      expect(invalid, isFalse);
    });

    test('resetPassword đổi mật khẩu thành công', () async {
      const email = 'reset_test@locket.com';
      const oldPass = 'oldpassword123';
      const newPass = 'newpassword123';

      await repository.register(email, oldPass);

      await repository.resetPassword(email, newPass);

      final oldValid = await repository.validatePassword(email, oldPass);
      final newValid = await repository.validatePassword(email, newPass);

      expect(oldValid, isFalse);
      expect(newValid, isTrue);
    });
  });
}
