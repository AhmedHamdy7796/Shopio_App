import 'package:shopio_app/features/auth/domain/model/login_model.dart';

abstract class LoginState {}

class LoginInitial extends LoginState {}

class LoginLoading extends LoginState {}

class LoginSuccess extends LoginState {
  final LoginModel msg;
  LoginSuccess({required this.msg});
}

class LoginFailure extends LoginState {
  final String error;
  LoginFailure(this.error);
}
