import 'package:shared_preferences/shared_preferences.dart';

class UserSimplePreferences {

  static SharedPreferences? _preferences;

  static const _keyEmail = 'userEmail';
  static const _keyAccountId = 'accountId';

  static Future init() async =>
      _preferences = await SharedPreferences.getInstance();

  static Future setUserEmail(String userEmail) async =>
      await _preferences!.setString(_keyEmail, userEmail);

  static String? getUserEmail() => _preferences!.getString(_keyEmail);

  static Future setAccountId(String accountId) async =>
      await _preferences!.setString(_keyAccountId, accountId);

  static String? getAccountId() => _preferences!.getString(_keyAccountId);




}