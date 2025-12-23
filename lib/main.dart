import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  final dio = Dio();
  final remoteDataSource = ProductRemoteDataSourceImpl(dio: dio);
  final productRepository = ProductRepositoryImpl(
    remoteDataSource: remoteDataSource,
  );

  SharedPreferences? prefs;
  try {
    prefs = await SharedPreferences.getInstance().timeout(
      const Duration(seconds: 2),
      onTimeout: () {
        debugPrint(
          "SharedPreferences initialization took too long. Proceeding without prefs.",
        );
        throw TimeoutException("SP Timeout");
      },
    );
  } catch (e) {
    debugPrint("Error initializing prefs: $e");
  }

  runApp(
    RepositoryProvider(
      create: (context) => productRepository, // Use the instance created above
      // Or create it here: create: (context) => ProductRepositoryImpl(remoteDataSource: ProductRemoteDataSourceImpl(dio: Dio()))
      // But we already created it.
      child: MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => ThemeCubit(prefs: prefs)),
          BlocProvider(create: (_) => AuthCubit()),
          BlocProvider(create: (_) => FavoritesCubit()),
          BlocProvider(create: (_) => CartCubit()..loadCart()),
          BlocProvider(
            create: (context) => HomeCubit(
              productRepository: context.read<ProductRepositoryImpl>(),
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
              initialRoute: Routes.onboarding,
              debugShowCheckedModeBanner: false,
            );
          },
        );
      },
    );
  }
}
