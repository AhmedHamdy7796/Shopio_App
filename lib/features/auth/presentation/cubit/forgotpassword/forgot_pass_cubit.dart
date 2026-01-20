import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopio_app/features/auth/data/repositories/auth_repo_imple.dart';
import 'package:shopio_app/features/auth/presentation/cubit/forgotpassword/forgot_pass_state.dart';

class ForgotPasswordCubit extends Cubit<ForgotPasswordState> {
  ForgotPasswordCubit({required this.authRepoImple})
    : super(ForgotPasswordInitialState());
  AuthRepoImple authRepoImple;
  TextEditingController email = TextEditingController();
  GlobalKey<FormState> forgotPassForm = GlobalKey();
  Future<void> forgotPasswordUser() async {
    try {
      var value = await authRepoImple.forgotRepo(email: email.text);
      return value.fold(
        (error) {
          emit(ForgotPasswordFailureState(error));
        },
        (msg) {
          emit(ForgotPasswordSuccessState(msg: msg));
        },
      );
    } catch (e) {
      return emit(ForgotPasswordFailureState(e.toString()));
    }
  }

  void validateForgotPass() {
    if (forgotPassForm.currentState!.validate()) {
      forgotPasswordUser();
    }
  }

  void clear() {
    email.clear();
  }
}
