import 'package:dio/dio.dart';

class ServerException implements Exception {
  final String? message;
  final DioExceptionType? errorType;

  ServerException({this.message, this.errorType});
}

class CacheException implements Exception {}
