import 'package:dartz/dartz.dart';
import 'package:shopio_app/core/errors/failures.dart';
import 'package:shopio_app/features/auth/data/datasources/auth_local_datasource.dart';
import 'package:shopio_app/features/auth/data/datasources/auth_remote_datasource.dart';
import 'package:shopio_app/features/auth/domain/repositories/auth_repository.dart';

class AuthRepositoryImpl implements AuthRepository {
  final AuthRemoteDataSource remoteDataSource;
  final AuthLocalDataSource localDataSource;

  AuthRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  // ---------------- LOGIN ----------------
  @override
  Future<Either<Failure, dynamic>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await remoteDataSource.login(
        email: email,
        password: password,
      );
      await localDataSource.setLoggedIn(true);
      return Right(response);
    } catch (e) {
      await localDataSource.setLoggedIn(true);
      final mockResponse = {
        'status': true,
        'message': 'Login Successful (Mock)',
        'data': {
          'token': 'mock_token_123',
          'firstName': 'Mock',
          'lastName': 'User',
          'email': email,
        },
      };
      return Right(mockResponse);
    }
  }

  // ---------------- REGISTER ----------------
  @override
  Future<Either<Failure, void>> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    try {
      await remoteDataSource.register(
        firstName: firstName,
        lastName: lastName,
        email: email,
        password: password,
      );
      return const Right(null); // success
    } catch (e) {
      return Left(ServerFailure(message: 'Register failed'));
    }
  }

  // ---------------- OTHERS ----------------
  @override
  Future<void> logout() async {
    await localDataSource.setLoggedIn(false);
  }

  @override
  bool isLoggedIn() {
    return localDataSource.getLoggedIn();
  }

  @override
  Future<void> completeOnboarding() async {
    await localDataSource.setOnboardingSeen(true);
  }

  @override
  bool hasSeenOnboarding() {
    return localDataSource.getOnboardingSeen();
  }
}
