import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit() : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    await Future.delayed(const Duration(seconds: 2)); // Simulate API call
    if (email.isNotEmpty && password.length >= 6) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_logged_in', true);
      emit(AuthLoginSuccess());
    } else {
      emit(const AuthFailure('Invalid credentials or password too short'));
    }
  }

  Future<void> register(String name, String email, String password) async {
    emit(AuthLoading());
    await Future.delayed(const Duration(seconds: 2));
    if (name.isNotEmpty && email.isNotEmpty && password.length >= 6) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_logged_in', true);
      emit(AuthRegisterSuccess());
    } else {
      emit(const AuthFailure('Please fill all fields correctly'));
    }
  }

  Future<void> verifyOtp(String otp) async {
    emit(AuthLoading());
    await Future.delayed(const Duration(seconds: 1));
    if (otp.length == 4) {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('is_logged_in', true);
      emit(AuthOtpSuccess());
    } else {
      emit(const AuthFailure('Invalid OTP'));
    }
  }

  Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('is_logged_in', false);
    // In a real app, you might emit a state here or handle navigation in the UI
  }
}
