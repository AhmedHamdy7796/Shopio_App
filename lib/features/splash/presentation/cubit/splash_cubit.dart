import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import '../../../auth/domain/repositories/auth_repository.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  final AuthRepository authRepository;

  SplashCubit({required this.authRepository}) : super(SplashInitial());

  Future<void> checkStartDestination() async {
    await Future.delayed(const Duration(seconds: 3));

    // final isLoggedIn = authRepository.isLoggedIn(); // Disabled auto-login as per user request
    final seenOnboarding = authRepository.hasSeenOnboarding();

    // if (isLoggedIn) {
    //   emit(SplashNavigateToHome());
    // } else
    if (seenOnboarding) {
      emit(SplashNavigateToLogin());
    } else {
      emit(SplashNavigateToOnboarding());
    }
  }
}
