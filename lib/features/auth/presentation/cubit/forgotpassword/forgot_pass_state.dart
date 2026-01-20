import 'package:shopio_app/features/auth/domain/model/auth_model.dart';

abstract class ForgotPasswordState {}

class ForgotPasswordInitialState extends ForgotPasswordState {}

class ForgotPasswordLoadingState extends ForgotPasswordState {}

class ForgotPasswordSuccessState extends ForgotPasswordState {
  final AuthModel msg;
  ForgotPasswordSuccessState({required this.msg});
}

class ForgotPasswordFailureState extends ForgotPasswordState {
  final String error;
  ForgotPasswordFailureState(this.error);
}
