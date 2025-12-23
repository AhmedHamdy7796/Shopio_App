import '../datasources/auth_local_datasource.dart';

class AuthRepository {
  final AuthLocalDataSource localDataSource;

  AuthRepository({required this.localDataSource});

  Future<void> login(String email, String password) async {
    // In a real app, call remote data source here.
    // For now, we simulate success and save locally.
    await Future.delayed(const Duration(seconds: 2)); // Simulate API
    await localDataSource.setLoggedIn(true);
  }

  Future<void> register(String name, String email, String password) async {
    // Simulate API
    await Future.delayed(const Duration(seconds: 2));
    await localDataSource.setLoggedIn(true);
  }

  Future<void> logout() async {
    await localDataSource.setLoggedIn(false);
  }

  bool isLoggedIn() {
    return localDataSource.getLoggedIn();
  }

  Future<void> completeOnboarding() async {
    await localDataSource.setOnboardingSeen(true);
  }

  bool hasSeenOnboarding() {
    return localDataSource.getOnboardingSeen();
  }
}
