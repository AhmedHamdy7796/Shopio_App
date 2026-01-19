import 'package:dartz/dartz.dart';
import 'package:shopio_app/core/errors/failures.dart';

abstract class AuthRepository {
  Future<Either<Failure, dynamic>> login({
    required String email,
    required String password,
  });

  Future<Either<Failure, void>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  });

  Future<Either<Failure, dynamic>> verifyCode({
    required String email,
    required String code,
  });

  Future<Either<Failure, void>> resendOtp({required String email});

  Future<void> logout();
  bool isLoggedIn();
  Future<void> completeOnboarding();
  bool hasSeenOnboarding();
}
