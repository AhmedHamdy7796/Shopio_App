import 'package:flutter/material.dart';
import '../../pages/onboarding_screen.dart';
import '../../pages/splash_screen.dart';
import '../../pages/login_screen.dart';
import '../../pages/register_screen.dart';
import '../../pages/forgot_password_screen.dart';
import '../../pages/otp_screen.dart';
import '../../pages/reset_password_screen.dart';
import '../../pages/home_screen.dart';
import '../../pages/product_details_screen.dart';
import '../../features/home/data/models/product_model.dart';
import '../../pages/cart_screen.dart';
import '../../pages/profile_screen.dart';
import '../../pages/categories_screen.dart';
import '../../pages/products_list_screen.dart';
import '../../pages/favorites_screen.dart';
import '../../pages/add_product_screen.dart';

class Routes {
  static const String splash = '/';
  static const String onboarding = '/onboarding';
  static const String login = '/login';
  static const String register = '/register';
  static const String home = '/home';
  static const String productDetails = '/product_details';
  static const String cart = '/cart';
  static const String profile = '/profile';
  static const String forgotPassword = '/forgot_password';
  static const String otpVerification = '/otp_verification';
  static const String resetPassword = '/reset_password';
  static const String categories = '/categories';
  static const String productsList = '/products_list';
  static const String favorites = '/favorites';
  static const String addProduct = '/add_product';
}

class AppRoutes {
  static Route<dynamic>? onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case Routes.splash:
        return MaterialPageRoute(builder: (_) => const SplashScreen());
      case Routes.onboarding:
        return MaterialPageRoute(builder: (_) => const OnboardingScreen());
      case Routes.login:
        return MaterialPageRoute(builder: (_) => const LoginScreen());
      case Routes.register:
        return MaterialPageRoute(builder: (_) => const RegisterScreen());
      case Routes.home:
        return MaterialPageRoute(builder: (_) => const HomeScreen());
      case Routes.productDetails:
        final product = settings.arguments as ProductModel;
        return MaterialPageRoute(
          builder: (_) => ProductDetailsScreen(product: product),
        );
      case Routes.cart:
        return MaterialPageRoute(builder: (_) => const CartScreen());
      case Routes.profile:
        return MaterialPageRoute(builder: (_) => const ProfileScreen());
      case Routes.forgotPassword:
        return MaterialPageRoute(builder: (_) => const ForgotPasswordScreen());
      case Routes.otpVerification:
        final email = settings.arguments as String? ?? 'user@shopio.com';
        return MaterialPageRoute(
          builder: (_) => OtpVerificationScreen(email: email),
        );
      case Routes.resetPassword:
        return MaterialPageRoute(builder: (_) => const ResetPasswordScreen());
      case Routes.categories:
        return MaterialPageRoute(builder: (_) => const CategoriesScreen());
      case Routes.productsList:
        final categoryName = settings.arguments as String?;
        return MaterialPageRoute(
          builder: (_) => ProductsListScreen(categoryName: categoryName),
        );
      case Routes.favorites:
        return MaterialPageRoute(builder: (_) => const FavoritesScreen());
      case Routes.addProduct:
        return MaterialPageRoute(builder: (_) => const AddProductScreen());
      default:
        return null; // Let MaterialApp handle unknown routes or return a error page
    }
  }
}
