import 'package:flutter/material.dart';
import '../../features/onboarding/presentation/pages/onboarding_screen.dart';
import '../../features/splash/presentation/pages/splash_screen.dart';
import '../../features/auth/presentation/pages/login_screen.dart';
import '../../features/auth/presentation/pages/register_screen.dart';
import '../../features/auth/presentation/pages/forgot_password_screen.dart';
import '../../features/auth/presentation/pages/otp_screen.dart';
import '../../features/auth/presentation/pages/reset_password_screen.dart';
import '../../features/home/presentation/pages/home_screen.dart';
import '../../features/product_details/presentation/pages/product_details_screen.dart';
import '../../features/home/data/models/product_model.dart';
import '../../features/cart/presentation/pages/cart_screen.dart';
import '../../features/profile/presentation/pages/profile_screen.dart';
import '../../features/categories/presentation/pages/categories_screen.dart';
import '../../features/products/presentation/pages/products_list_screen.dart';
import '../../features/favorites/presentation/pages/favorites_screen.dart';
import '../../features/admin/presentation/pages/add_product_screen.dart';

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
