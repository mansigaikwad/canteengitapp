class OtpResponse {
  final bool success;

  final String message;
  final String OTP;

  OtpResponse(
      {required this.success, required this.message, required this.OTP});

  factory OtpResponse.fromJson(Map<String, dynamic> json) {
    return OtpResponse(
      success: json['success'],
      message: json['message'],
      OTP: json['OTP'],
    );
  }
}