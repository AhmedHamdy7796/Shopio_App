import 'package:dartz/dartz.dart';
import 'package:shopio_app/core/api/api_services.dart';
import 'package:shopio_app/features/auth/data/repositories/auth_repo.dart';
import 'package:shopio_app/features/auth/domain/model/auth_model.dart';
import 'package:shopio_app/features/auth/domain/model/login_model.dart';

class AuthRepoImple implements AuthRepo {
  final ApiServices apiServices;
  AuthRepoImple({required this.apiServices});
  // Register Repo

  // // OTP Repo
  // @override
  // Future<Either<String, RegisterModel>> otpRepo({
  //   required String email,
  //   required String otpCode,
  // }) async {
  //   try {
  //     var data = await apiServices.otp(
  //       endpoint: ApiEndPoint.otp,
  //       email: email,
  //       otpCode: otpCode,
  //     );
  //     print(data.runtimeType);
  //     print(data);
  //     return right(RegisterModel.fromJson(data));
  //   } catch (e) {
  //     String errorMsg = e.toString();
  //     if (errorMsg.startsWith("Exception: ")) {
  //       errorMsg = errorMsg.replaceFirst("Exception: ", "");
  //     }
  //     return left(errorMsg);
  //   }
  // }

  //Login Repo
  @override
  Future<Either<String, LoginModel>> loginRepo({
    required String email,
    required String password,
  }) async {
    try {
      var data = await apiServices.login(
        endpoint: "auth/login",
        email: email,
        password: password,
      );
      print(data.runtimeType);
      print(data);
      return right(LoginModel.fromJson(data));
    } catch (e) {
      return left(e.toString());
    }
  }

  // Forgot Repo
  @override
  Future<Either<String, AuthModel>> forgotRepo({required String email}) async {
    try {
      var data = await apiServices.forgotPassword(
        endpoint: "auth/forgot-password",
        email: email,
      );
      print(data.runtimeType);
      print(data);
      return right(AuthModel.fromJson(data));
    } catch (e) {
      return left(e.toString());
    }
  }

  // // Reset Password
  // @override
  // Future<Either<String, RegisterModel>> resetPasswordRepo({
  //   required String email,
  //   required String otpCode,
  //   required String newPassword,
  // }) async {
  //   try {
  //     var data = await apiServices.resetPassword(
  //       endpoint: ApiEndPoint.resetPassword,
  //       email: email,
  //       otpCode: otpCode,
  //       newPassword: newPassword,
  //     );
  //     return right(RegisterModel.fromJson(data));
  //   } catch (e) {
  //     return left(e.toString());
  //   }
  // }
}
