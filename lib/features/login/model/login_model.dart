class Token {
  final String accessToken;
  final String tokenType;
  final String expiresIn;
  final String employeeCode;
  final String employeeName;
  final String employeeMobile;
  final String? fcmToken;

  Token({
    required this.accessToken,
    required this.tokenType,
    required this.expiresIn,
    required this.employeeCode,
    required this.employeeName,
    required this.employeeMobile,
    this.fcmToken,
  });

  factory Token.fromJson(Map<String, dynamic> json) {
    return Token(
      accessToken: json['access_token'],
      tokenType: json['token_type'],
      expiresIn: json['expires_in'],
      employeeCode: json['Employeecode'],
      employeeName: json['EmployeeName'],
      employeeMobile: json['EmployeeMobile'],
      fcmToken: json['fcmToken'],
    );
  }
}

class ApiResponse {
  final bool success;
  final Token token;

  ApiResponse({required this.success, required this.token});

  factory ApiResponse.fromJson(Map<String, dynamic> json) {
    return ApiResponse(
      success: json['success'],
      token: Token.fromJson(json['Token']),
    );
  }
}
