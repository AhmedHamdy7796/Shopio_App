class LoginModel {
  final String? accessToken;
  final String? expiresAtUtc;
  final String? refreshToken;
  final String? message;

  LoginModel({
    this.accessToken,
    this.expiresAtUtc,
    this.refreshToken,
    this.message,
  });

  factory LoginModel.fromJson(Map<String, dynamic> json) {
    return LoginModel(
      accessToken: json['accessToken'] as String?,
      expiresAtUtc: json['expiresAtUtc'] as String?,
      refreshToken: json['refreshToken'] as String?,
      message: json['message'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'accessToken': accessToken,
      'expiresAtUtc': expiresAtUtc,
      'refreshToken': refreshToken,
      'message': message,
    };
  }
}
