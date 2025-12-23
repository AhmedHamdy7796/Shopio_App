// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility in the flutter_test package. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

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
          BlocProvider(
            create: (_) => ThemeCubit(prefs: null),
          ), // Pass null for system default
          BlocProvider(create: (_) => AuthCubit()),
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
