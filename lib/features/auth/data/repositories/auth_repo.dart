import 'package:dartz/dartz.dart';
import 'package:shopio_app/features/auth/domain/model/auth_model.dart';
import 'package:shopio_app/features/auth/domain/model/login_model.dart';

abstract class AuthRepo {
  Future<Either<String, LoginModel>> loginRepo({
    required String email,
    required String password,
  });
  Future<Either<String, AuthModel>> forgotRepo({required String email});
}
