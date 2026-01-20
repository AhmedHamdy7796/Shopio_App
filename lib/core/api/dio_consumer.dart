import 'package:dio/dio.dart';
import 'package:shopio_app/core/api/api_consumer.dart';
import 'package:shopio_app/core/api/end_points.dart';
import 'package:shopio_app/core/errors/exceptions.dart';
import 'package:shared_preferences/shared_preferences.dart';

class DioConsumer implements ApiConsumer {
  final Dio client;
  final SharedPreferences sharedPreferences;

  DioConsumer({required this.client, required this.sharedPreferences}) {
    client.options.baseUrl = EndPoints.baseUrl;
    client.options.headers = {'Content-Type': 'application/json', 'lang': 'en'};
    client.interceptors.add(
      LogInterceptor(
        request: true,
        requestHeader: true,
        requestBody: true,
        responseHeader: true,
        responseBody: true,
        error: true,
      ),
    );
    // Add auth interceptor if needed
    client.interceptors.add(
      InterceptorsWrapper(
        onRequest: (options, handler) {
          final token = sharedPreferences.getString(
            'token',
          ); // Assuming token key
          if (token != null) {
            options.headers[ApiKeys.token] = token;
          }
          return handler.next(options);
        },
      ),
    );
  }

  @override
  Future get(String path, {Map<String, dynamic>? data}) async {
    try {
      final response = await client.get(path, queryParameters: data);
      return response.data;
    } on DioException catch (error) {
      _handleDioError(error);
    }
  }

  @override
  Future post(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    bool isFormData = false,
  }) async {
    try {
      final response = await client.post(
        path,
        data: isFormData ? FormData.fromMap(body!) : body,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (error) {
      _handleDioError(error);
    }
  }

  @override
  Future put(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
    bool isFormData = false,
  }) async {
    try {
      final response = await client.put(
        path,
        data: isFormData ? FormData.fromMap(body!) : body,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (error) {
      _handleDioError(error);
    }
  }

  @override
  Future delete(
    String path, {
    Map<String, dynamic>? body,
    Map<String, dynamic>? queryParameters,
  }) async {
    try {
      final response = await client.delete(
        path,
        data: body,
        queryParameters: queryParameters,
      );
      return response.data;
    } on DioException catch (error) {
      _handleDioError(error);
    }
  }

  dynamic _handleDioError(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.sendTimeout:
      case DioExceptionType.receiveTimeout:
        throw ServerException(
          message: 'Connection timeout',
          errorType: error.type,
        );
      case DioExceptionType.badResponse:
        switch (error.response?.statusCode) {
          case 400:
          case 401:
          case 403:
            throw ServerException(
              message: error.response?.data['message'] ?? 'Unauthorized',
              errorType: error.type,
            );
          case 404:
            throw ServerException(message: 'Not Found', errorType: error.type);
          case 500:
            throw ServerException(
              message: 'Server Error',
              errorType: error.type,
            );
        }
        throw ServerException(
          message: 'Unexpected error occurred',
          errorType: error.type,
        );
      case DioExceptionType.cancel:
        throw ServerException(
          message: 'Request Cancelled',
          errorType: error.type,
        );
      case DioExceptionType.unknown:
        throw ServerException(message: 'Unknown Error', errorType: error.type);
      default:
        throw ServerException(
          message: 'Something went wrong',
          errorType: error.type,
        );
    }
  }
}
