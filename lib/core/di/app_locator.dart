import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';
import 'package:shopio_app/core/api/api_services.dart';
import 'package:shopio_app/features/auth/data/repositories/auth_repo_imple.dart';
import 'package:shopio_app/features/auth/presentation/cubit/forgotpassword/forgot_pass_cubit.dart';
import 'package:shopio_app/features/auth/presentation/cubit/login/login_cubit.dart';

GetIt getIt = GetIt.instance;
void setupLocator() {
  getIt.registerSingleton<ApiServices>(ApiServices(dio: Dio()));
  getIt.registerSingleton<AuthRepoImple>(
    AuthRepoImple(apiServices: getIt.get<ApiServices>()),
  );
  getIt.registerLazySingleton<LoginCubit>(
    () => LoginCubit(authRepo: getIt.get<AuthRepoImple>()),
  );
  getIt.registerLazySingleton<ForgotPasswordCubit>(
    () => ForgotPasswordCubit(authRepoImple: getIt.get<AuthRepoImple>()),
  );
}
