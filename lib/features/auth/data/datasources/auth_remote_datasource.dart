import 'package:shopio_app/core/api/api_consumer.dart';
import 'package:shopio_app/core/api/end_points.dart';

abstract class AuthRemoteDataSource {
  Future<dynamic> login({required String email, required String password});
  Future<dynamic> register({
    required String firstName,
    required String lastName,
    required String email,
    required String password,
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
    required String firstName,
    required String lastName,
    required String email,
    required String password,
  }) async {
    final response = await apiConsumer.post(
      EndPoints.register,
      body: {
        'firstName': firstName,
        'lastName': lastName,   
        'email': email,
        'password': password,
      },
    );
    return response;
  }
}
