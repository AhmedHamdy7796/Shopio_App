import 'dart:developer';

import 'package:dio/dio.dart';

class ApiServices {
  final Dio dio;
  ApiServices({required this.dio});
  final String _baseUrl = "https://accessories-eshop.runasp.net/api/";
  // Login User
  Future<Map<String, dynamic>> login({
    required String endpoint,
    required String email,
    required String password,
  }) async {
    try {
      var response = await dio.post(
        "$_baseUrl$endpoint",
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          responseType: ResponseType.json,
        ),
        data: {"email": email, "password": password},
      );
      return Map<String, dynamic>.from(response.data);
    } on DioException catch (e) {
      log("Full API Error: ${e.response}");

      if (e.response != null && e.response?.data != null) {
        final data = e.response?.data;

        if (data['errors'] != null && data['errors'] is Map) {
          Map<String, dynamic> errorsMap = data['errors'];

          String allErrors = errorsMap.values
              .map((e) => (e as List).join(', '))
              .join('\n');

          throw allErrors;
        }

        throw data['message'] ?? 'Auth Error';
      }

      throw 'Please check your internet connection';
    }
  }

  // OTP Verification
  Future<Map<String, dynamic>> otp({
    required String endpoint,
    required String email,
    required String otpCode,
  }) async {
    try {
      var response = await dio.post(
        "$_baseUrl$endpoint",
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          responseType: ResponseType.json,
        ),
        data: {"email": email, "otp": otpCode},
      );
      if (response.data is Map) {
        return Map<String, dynamic>.from(response.data);
      } else {
        return {"message": response.data.toString()};
      }
    } on DioException catch (e) {
      log("Full API Error: ${e.response}");

      if (e.response?.data != null) {
        final data = e.response?.data;

        if (data is Map) {
          if (data['errors'] != null) {
            final errors = data['errors'];

            if (errors is Map) {
              for (var entry in errors.entries) {
                if (entry.value is List && (entry.value as List).isNotEmpty) {
                  throw entry.value[0].toString();
                } else if (entry.value is String) {
                  throw entry.value.toString();
                }
              }
            }
          }

          if (data['message'] != null &&
              data['message'] != "One or more errors occurred!") {
            throw data['message'].toString();
          }
        }
      }

      throw "Invalid code, please try again.";
    }
  }

  // Forgot Password
  Future<Map<String, dynamic>> forgotPassword({
    required String endpoint,
    required String email,
  }) async {
    try {
      var response = await dio.post(
        "$_baseUrl$endpoint",
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          responseType: ResponseType.json,
        ),
        data: {"email": email},
      );
      if (response.data is Map) {
        return Map<String, dynamic>.from(response.data);
      } else {
        return {"message": response.data.toString()};
      }
    } on DioException catch (e) {
      log("Full API Error: ${e.response}");

      if (e.response?.data != null) {
        final data = e.response?.data;

        if (data is Map) {
          if (data['errors'] != null) {
            final errors = data['errors'];

            if (errors is Map) {
              for (var entry in errors.entries) {
                if (entry.value is List && (entry.value as List).isNotEmpty) {
                  throw entry.value[0].toString();
                } else if (entry.value is String) {
                  throw entry.value.toString();
                }
              }
            }
          }

          if (data['message'] != null &&
              data['message'] != "One or more errors occurred!") {
            throw data['message'].toString();
          }
        }
      }
    }
    throw "Invalid code, please try again.";
  }

  // Reset Password
  Future<Map<String, dynamic>> resetPassword({
    required String endpoint,
    required String email,
    required String otpCode,
    required String newPassword,
  }) async {
    try {
      var response = await dio.post(
        "$_baseUrl$endpoint",
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          responseType: ResponseType.json,
        ),
        data: {"email": email, "otp": otpCode, "newPassword": newPassword},
      );
      if (response.data is Map) {
        return Map<String, dynamic>.from(response.data);
      } else {
        return {"message": response.data.toString()};
      }
    } on DioException catch (e) {
      log("Full API Error: ${e.response}");

      if (e.response?.data != null) {
        final data = e.response?.data;

        if (data is Map) {
          if (data['errors'] != null) {
            final errors = data['errors'];

            if (errors is Map) {
              for (var entry in errors.entries) {
                if (entry.value is List && (entry.value as List).isNotEmpty) {
                  throw entry.value[0].toString();
                } else if (entry.value is String) {
                  throw entry.value.toString();
                }
              }
            }
          }

          if (data['message'] != null &&
              data['message'] != "One or more errors occurred!") {
            throw data['message'].toString();
          }
        }
      }
    }
    throw "Invalid code, please try again.";
  }

  // Change Password
  Future<Map<String, dynamic>> changePassword({
    required String endpoint,
    required String currentPassword,
    required String newPassword,
    required String confirmNewPassword,
  }) async {
    try {
      var response = await dio.post(
        "$_baseUrl$endpoint",
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
          },
          responseType: ResponseType.json,
        ),
        data: {
          "currentPassword": currentPassword,
          "newPassword": newPassword,
          "confirmNewPassword": confirmNewPassword,
        },
      );
      if (response.data is Map) {
        return Map<String, dynamic>.from(response.data);
      } else {
        return {"message": response.data.toString()};
      }
    } on DioException catch (e) {
      log("Full API Error: ${e.response}");

      if (e.response?.data != null) {
        final data = e.response?.data;

        if (data is Map) {
          if (data['errors'] != null) {
            final errors = data['errors'];

            if (errors is Map) {
              for (var entry in errors.entries) {
                if (entry.value is List && (entry.value as List).isNotEmpty) {
                  throw entry.value[0].toString();
                } else if (entry.value is String) {
                  throw entry.value.toString();
                }
              }
            }
          }

          if (data['message'] != null &&
              data['message'] != "One or more errors occurred!") {
            throw data['message'].toString();
          }
        }
      }
    }
    throw "Invalid code, please try again.";
  }
}
