import 'package:flutter_test/flutter_test.dart';
import 'package:shopio_app/core/utils/validators.dart';
void main() {
  group('Validator Tests', () {
    test('Email validation - valid email returns null', () {
      final result = Validator.validateEmail('test@example.com');
      expect(result, null);
    });

    test('Email validation - empty email returns error string', () {
      final result = Validator.validateEmail('');
      expect(result, isNotNull);
    });
  });
}