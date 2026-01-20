import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shopio_app/core/di/app_locator.dart';
import 'package:shopio_app/features/auth/presentation/cubit/forgotpassword/forgot_pass_cubit.dart';
import 'package:shopio_app/features/auth/presentation/cubit/login/login_cubit.dart';
import 'core/theme/app_theme.dart';
import 'core/routes/app_routes.dart';
import 'core/theme/cubit/theme_cubit.dart';
import 'features/auth/presentation/cubit/auth_cubit.dart';
import 'features/favorites/presentation/cubit/favorites_cubit.dart';
import 'features/cart/presentation/cubit/cart_cubit.dart';
import 'features/home/presentation/cubit/home_cubit.dart';
import 'package:dio/dio.dart';
import 'features/admin/data/datasources/product_remote_datasource.dart';
import 'features/admin/data/repositories/product_repository_impl.dart';
import 'features/auth/data/datasources/auth_local_datasource.dart';
import 'features/auth/data/datasources/auth_remote_datasource.dart';
import 'features/auth/data/repositories/auth_repository_impl.dart';
import 'features/auth/domain/repositories/auth_repository.dart';
import 'features/home/data/datasources/home_remote_datasource.dart';
import 'features/home/data/repositories/home_repository_impl.dart';
import 'features/home/domain/repositories/home_repository.dart';
import 'features/product_details/data/datasources/product_details_remote_datasource.dart';
import 'features/product_details/data/repositories/product_details_repository_impl.dart';
import 'features/product_details/domain/repositories/product_details_repository.dart';
import 'core/api/dio_consumer.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  setupLocator();

  final sharedPrefs = await SharedPreferences.getInstance();
  final dio = Dio();
  final dioConsumer = DioConsumer(client: dio, sharedPreferences: sharedPrefs);

  final productRemoteDataSource = ProductRemoteDataSourceImpl(dio: dio);
  final productRepository = ProductRepositoryImpl(
    remoteDataSource: productRemoteDataSource,
  );

  final authLocalDataSource = AuthLocalDataSourceImpl(
    sharedPreferences: sharedPrefs,
  );
  final authRemoteDataSource = AuthRemoteDataSourceImpl(
    apiConsumer: dioConsumer,
  );
  final authRepository = AuthRepositoryImpl(
    remoteDataSource: authRemoteDataSource,
    localDataSource: authLocalDataSource,
  );

  final homeRemoteDataSource = HomeRemoteDataSourceImpl(
    apiConsumer: dioConsumer,
  );
  final homeRepository = HomeRepositoryImpl(
    homeRemoteDataSource: homeRemoteDataSource,
  );

  final productDetailsRemoteDataSource = ProductDetailsRemoteDataSourceImpl(
    apiConsumer: dioConsumer,
  );
  final productDetailsRepository = ProductDetailsRepositoryImpl(
    remoteDataSource: productDetailsRemoteDataSource,
  );

  runApp(
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<ProductRepositoryImpl>.value(
          value: productRepository,
        ),
        RepositoryProvider<AuthRepository>.value(value: authRepository),
        RepositoryProvider<HomeRepository>.value(value: homeRepository),
        RepositoryProvider<ProductDetailsRepository>.value(
          value: productDetailsRepository,
        ),
      ],
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => ThemeCubit(prefs: sharedPrefs)),
          BlocProvider(create: (_) => getIt.get<ForgotPasswordCubit>()),
          BlocProvider(create: (_) => getIt.get<LoginCubit>()),
          BlocProvider(
            create: (context) =>
                AuthCubit(authRepository: context.read<AuthRepository>()),
          ),
          BlocProvider(create: (_) => FavoritesCubit()),
          BlocProvider(create: (_) => CartCubit()..loadCart()),
          BlocProvider(
            create: (context) => HomeCubit(
              productRepository: context.read<ProductRepositoryImpl>(),
              homeRepository: context.read<HomeRepository>(),
            )..loadHomeData(),
          ),
        ],
        child: const ShopioApp(),
      ),
    ),
  );
}

class ShopioApp extends StatelessWidget {
  const ShopioApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return BlocBuilder<ThemeCubit, ThemeMode>(
          builder: (context, themeMode) {
            return MaterialApp(
              title: 'Shopio',
              theme: AppTheme.lightTheme,
              darkTheme: AppTheme.darkTheme,
              themeMode: themeMode,
              onGenerateRoute: AppRoutes.onGenerateRoute,
              initialRoute: Routes.splash,
              debugShowCheckedModeBanner: false,
            );
          },
        );
      },
    );
  }
}
