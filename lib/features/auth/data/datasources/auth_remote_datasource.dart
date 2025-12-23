import 'package:shopio_app/core/api/api_consumer.dart';
import 'package:shopio_app/core/api/end_points.dart';

abstract class AuthRemoteDataSource {
  Future<dynamic> login({required String email, required String password});
  Future<dynamic> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  });
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final ApiConsumer apiConsumer;

  AuthRemoteDataSourceImpl({required this.apiConsumer});

  @override
  Future<dynamic> login({
    required String email,
    required String password,
  }) async {
    final response = await apiConsumer.post(
      EndPoints.login,
      body: {'email': email, 'password': password},
    );
    return response;
  }

  @override
  Future<dynamic> register({
    required String name,
    required String email,
    required String password,
    required String phone,
  }) async {
    final response = await apiConsumer.post(
      EndPoints.register,
      body: {
        'name': name,
        'email': email,
        'password': password,
        'phone': phone,
      },
    );
    return response;
  }
}
