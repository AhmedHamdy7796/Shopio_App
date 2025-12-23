import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';

part 'splash_state.dart';

class SplashCubit extends Cubit<SplashState> {
  SplashCubit() : super(SplashInitial());

  Future<void> checkStartDestination() async {
    // Simplified logic: Force navigation after a short purely UI delay (managed by listener or adjust here)
    // Actually, let's keep a tiny delay for the animation to be seen, but NO SharedPreferences.
    await Future.delayed(const Duration(seconds: 3));
    emit(SplashNavigateToOnboarding()); // Default to onboarding to be safe
  }
}
