import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopio_app/features/auth/data/repositories/auth_repo_imple.dart';
import 'package:shopio_app/features/auth/presentation/cubit/login/login_state.dart';

class LoginCubit extends Cubit<LoginState> {
  final AuthRepoImple authRepo;
  LoginCubit({required this.authRepo}) : super(LoginInitial());
  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  GlobalKey<FormState> loginFormKey = GlobalKey<FormState>();
  Future<void> loginUser() async {
    emit(LoginLoading());
    final result = await authRepo.loginRepo(
      email: emailController.text,
      password: passwordController.text,
    );
    result.fold(
      (failure) => emit(LoginFailure(failure)),
      (loginModel) => emit(LoginSuccess(msg: loginModel)),
    );
  }

  void loginValidation() {
    final isValid = loginFormKey.currentState?.validate();
    if (isValid == true) {
      loginUser();
    }
  }

  void clear() {
    emailController.clear();
    passwordController.clear();
  }

  @override
  Future<void> close() {
    emailController.dispose();
    passwordController.dispose();
    return super.close();
  }
}
