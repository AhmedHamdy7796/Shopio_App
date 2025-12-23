import 'package:shared_preferences/shared_preferences.dart';

abstract class AuthLocalDataSource {
  Future<void> setLoggedIn(bool value);
  bool getLoggedIn();
  Future<void> setOnboardingSeen(bool value);
  bool getOnboardingSeen();
}

class AuthLocalDataSourceImpl implements AuthLocalDataSource {
  final SharedPreferences sharedPreferences;

  AuthLocalDataSourceImpl({required this.sharedPreferences});

  @override
  Future<void> setLoggedIn(bool value) async {
    await sharedPreferences.setBool('is_logged_in', value);
  }

  @override
  bool getLoggedIn() {
    return sharedPreferences.getBool('is_logged_in') ?? false;
  }

  @override
  Future<void> setOnboardingSeen(bool value) async {
    await sharedPreferences.setBool('seen_onboarding', value);
  }

  @override
  bool getOnboardingSeen() {
    return sharedPreferences.getBool('seen_onboarding') ?? false;
  }
}
