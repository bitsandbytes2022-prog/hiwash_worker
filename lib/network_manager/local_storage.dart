import 'package:get_storage/get_storage.dart';

class LocalStorage {
  final GetStorage _storage = GetStorage();

  final String _tokenKey = 'auth_token';
  final String _userIdKey = 'user_id';
  final String _customerIdKey = 'customer_id';
  final String _scannedQrCodeKey = 'scanned_qr_code';
  final  String _fcmToken = "fcmToken";
  final String _refreshTokenKey = 'refresh_token';
  final String _localeKey = 'selected_locale';





  Future<void> saveToken(String token) async {
    await _storage.write(_tokenKey, token);
  }

  String? getToken() {
    return _storage.read(_tokenKey);
  }



  Future<void> saveCustomerId(String id) async {
    await _storage.write(_customerIdKey, id);
  }
  Future<void> saveScannedQrCode(String qrCode) async {
    await _storage.write(_scannedQrCodeKey, qrCode);
  }
  saveFCMToken({var token}) {
    _storage.write(_fcmToken, token);
  }

  String getFCMToken() {
    return _storage.read(_fcmToken) ?? '';
  }

  String? getScannedQrCode() => _storage.read(_scannedQrCodeKey);
  String? getCustomerId() => _storage.read(_customerIdKey);
  Future<void> saveUserId(String id) async {
    await _storage.write(_userIdKey, id);
  }

  String? getUserId() => _storage.read(_userIdKey);



  // Refresh Token
  Future<void> saveRefreshToken(String token) async {
    await _storage.write(_refreshTokenKey, token);
  }

  String? getRefreshToken() {
    return _storage.read(_refreshTokenKey);
  }
  /// Language

  // Store selected locale
  Future<void> saveLocale(String localeCode) async {
    await _storage.write(_localeKey, localeCode);
    print("Locale saved: $localeCode");
  }

  String? getSavedLocale() {
    final locale = _storage.read(_localeKey);
    print("Retrieved saved locale: $locale");
    return locale;
  }
  Future<void> removeToken() async {
    await _storage.remove(_tokenKey);
    await _storage.remove(_userIdKey);
    await _storage.remove(_customerIdKey);
    await _storage.remove(_refreshTokenKey);
    await _storage.remove(_localeKey);

  }
}