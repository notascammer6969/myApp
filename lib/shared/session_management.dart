import 'package:flutter/cupertino.dart';
import 'package:shared_preferences/shared_preferences.dart';


class SessionManager extends ChangeNotifier {
  late SharedPreferences _preferences;

  Future<void> init() async {
    _preferences = await SharedPreferences.getInstance();
  }

  String? getToken() {
    return _preferences.getString('token');
  }

  Future<void> setToken(String token) async {
    await _preferences.setString('token', token);
  }

  Future<void> clearToken() async {
    await _preferences.remove('token');
  }

  String? getUsername() {
    return _preferences.getString('username');
  }

  Future<void> setUsername(String username) async {
    await _preferences.setString('username', username);
  }

  Future<void> clearUsername() async {
    await _preferences.remove('username');
  }

  bool isLoggedIn() {
    return _preferences.containsKey('token');
  }
}

class SessionManagerNotifier extends ChangeNotifier {
  final SessionManager sessionManager = SessionManager();

  Future<void> init() async {
    await sessionManager.init();
  }

}