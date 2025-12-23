import 'package:dartz/dartz.dart';
import 'package:shopio_app/core/errors/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, dynamic>> login({
    required String email,
    required String password,
  });
  Future<Either<Failure, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  });
  Future<void> logout();
  bool isLoggedIn();
  Future<void> completeOnboarding();
  bool hasSeenOnboarding();
}
