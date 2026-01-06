import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthRepository extends ChangeNotifier {
  String? _username;
  String? _phone;
  String? _password;

  static const _kUsernameKey = 'auth.username';
  static const _kPhoneKey = 'auth.phone';
  static const _kPasswordKey = 'auth.password';

  Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    _username = prefs.getString(_kUsernameKey);
    _phone = prefs.getString(_kPhoneKey);
    _password = prefs.getString(_kPasswordKey);
    notifyListeners();
  }

  Future<void> register({required String username, required String phone, required String password}) async {
    _username = username;
    _phone = phone;
    _password = password;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kUsernameKey, username);
    await prefs.setString(_kPhoneKey, phone);
    await prefs.setString(_kPasswordKey, password);
    notifyListeners();
  }

  Future<void> clear() async {
    _username = null;
    _phone = null;
    _password = null;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_kUsernameKey);
    await prefs.remove(_kPhoneKey);
    await prefs.remove(_kPasswordKey);
    notifyListeners();
  }

  bool get hasUser => _username != null && _password != null;

  bool usernameExists(String username) {
    return _username != null && _username == username;
  }

  bool validate(String username, String password) {
    if (!hasUser) return false;
    return _username == username && _password == password;
  }

  String? get username => _username;
  String? get phone => _phone;

  Future<void> setUsername(String username) async {
    _username = username;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_kUsernameKey, username);
    notifyListeners();
  }
}