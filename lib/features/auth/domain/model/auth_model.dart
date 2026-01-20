class AuthModel {
  final String msg;
  AuthModel({required this.msg});

  factory AuthModel.fromJson(Map<String, dynamic> json) {
    return AuthModel(msg: json['message']);
  }
}
