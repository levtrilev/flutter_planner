import 'package:flutter_secure_storage/flutter_secure_storage.dart';

abstract class _Keys {
  static const token = 'token';
  static const userId = 'user_id';
}

class SessionDataProvider {
  static const _secureStorage = FlutterSecureStorage();

  Future<String?> getToken() => _secureStorage.read(key: _Keys.token);
  Future<void> setToken(String? value) {
    if (value != null) {
      return _secureStorage.write(key: _Keys.token, value: value);
    } else {
      return _secureStorage.delete(key: _Keys.token);
    }
  }

  Future<int?> getUserId() async {
    String? userId = await _secureStorage.read(key: _Keys.userId);
    if (userId != null) {
      return int.tryParse(userId);
    } else {
      return null;
    }
  }

  Future<void> setUserId(int? value) {
    if (value != null) {
      return _secureStorage.write(key: _Keys.userId, value: value.toString());
    } else {
      return _secureStorage.delete(key: _Keys.userId);
    }
  }
}
