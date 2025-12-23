import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:shopio_app/main.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shopio_app/core/theme/cubit/theme_cubit.dart';
import 'package:shopio_app/features/auth/presentation/cubit/auth_cubit.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      MultiBlocProvider(
        providers: [
          BlocProvider(create: (_) => ThemeCubit(prefs: null)),
          BlocProvider(
            create: (_) => AuthCubit(authRepository: null as dynamic),
          ),
        ],
        child: const ShopioApp(),
      ),
    );

    // Wait for the splash screen duration (3 seconds + buffer) + Failsafe timer if needed
    await tester.pump(const Duration(seconds: 8));
    // Settle any remaining animations
    await tester.pumpAndSettle();

    // Verify that it builds without crashing (finds at least one widget)
    expect(find.byType(MaterialApp), findsOneWidget);
  });
}
