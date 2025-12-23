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
      // MOCK DATA for Temporary access
      await localDataSource.setLoggedIn(true);
      final mockResponse = {
        'status': true,
        'message': 'Login Successful (Mock)',
        'data': {
          'token': 'mock_token_123',
          'name': 'Mock User',
          'email': email,
          'phone': '01000000000',
        },
      };
      return Right(mockResponse);
    }
  }

  @override
  Future<Either<Failure, dynamic>> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    try {
      final response = await remoteDataSource.register(
        name: name,
        email: email,
        password: password,
        phone: phone,
      );
      return Right(response);
    } catch (e) {
      // MOCK DATA for Temporary access
      final mockResponse = {
        'status': true,
        'message': 'Register Successful (Mock)',
        'data': {
          'token': 'mock_token_123',
          'name': name,
          'email': email,
          'phone': phone,
        },
      };
      return Right(mockResponse);
    }
  }

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
