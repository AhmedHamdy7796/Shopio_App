import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../../../core/errors/failures.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final AuthRepository authRepository;

  AuthCubit({required this.authRepository})
    : super(AuthInitial());

  Future<void> login(String email, String password) async {
    emit(AuthLoading());
    final result = await authRepository.login(
      email: email,
      password: password,
    );
    result.fold(
      (failure) => emit(
        AuthFailure(
          failure is ServerFailure
              ? failure.message ?? 'Login failed'
              : 'Login failed',
        ),
      ),
      (data) => emit(AuthLoginSuccess()),
    );
  }

  Future<void> register(
    String firstName,
    String lastName,
    String email,
    String password,
  ) async {
    emit(AuthLoading());
    final result = await authRepository.register(
      firstName: firstName,
      lastName: lastName,
      email: email,
      password: password,
    );
    result.fold(
      (failure) => emit(
        AuthFailure(
          failure is ServerFailure
              ? failure.message ?? 'Registration failed'
              : 'Registration failed',
        ),
      ),
      (data) => emit(AuthRegisterSuccess()),
    );
  }

  Future<void> verifyOtp({required String email, required String otp}) async {
    emit(AuthLoading());
    final result = await authRepository.verifyCode(email: email, code: otp);
    result.fold(
      (failure) => emit(
        AuthFailure(
          failure is ServerFailure
              ? failure.message ?? 'Verification failed'
              : 'Verification failed',
        ),
      ),
      (data) => emit(AuthOtpSuccess()),
    );
  }



  Future<void> logout() async {
    await authRepository.logout();
    // In a real app, you might emit a state here or handle navigation in the UI
  }
}
