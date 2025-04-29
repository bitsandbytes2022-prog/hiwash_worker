import 'package:get_storage/get_storage.dart';

class LocalStorage {
  final GetStorage _storage = GetStorage();

  final String _tokenKey = 'auth_token';
  final String _userIdKey = 'user_id';
  final String _customerIdKey = 'customer_id';


  Future<void> saveToken(String token) async {
    await _storage.write(_tokenKey, token);
  }

  String? getToken() {
    return _storage.read(_tokenKey);
  }


  Future<void> saveUserId(String id) async {
    await _storage.write(_userIdKey, id);
  }
  Future<void> saveCustomerId(String id) async {
    await _storage.write(_customerIdKey, id);
  }

  String? getCustomerId() => _storage.read(_customerIdKey);
  String? getUserId() => _storage.read(_userIdKey);

  Future<void> removeToken() async {
    await _storage.remove(_tokenKey);
    await _storage.remove(_userIdKey);
    await _storage.remove(_customerIdKey);
  }
}