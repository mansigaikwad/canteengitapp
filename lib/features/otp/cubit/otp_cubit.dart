import 'package:bloc/bloc.dart';
import 'package:canteen_app/features/otp/model/otp_model.dart';
import 'package:canteen_app/features/otp/state/otp_state.dart';
import 'package:canteen_app/logger/logger.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

 

class OtpCubit extends Cubit<OtpState> {
  OtpCubit() : super(OtpInitial());

  //otp

  //{"EmployeeCode":"97261506","MobileNo":"9420181669"}
  Future<void> fetchOtp(
      String empCode, String phoneNumber, String token) async {
    try {
      emit(OtpLoading());
      AppLogger.instance.i("OTP loadeding.....");
      final Uri url = Uri.parse(
          'https://ccapi.mahyco.com/api/Employee/verifyMobile'); // Replace with your API endpoint

      final response = await http.post(
        url,
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          "EmployeeCode": empCode, // Replace with your actual JSON parameters
          "MobileNo": phoneNumber,
        }),
      );
      AppLogger.instance.i("response status ${response.statusCode}");
      if (response.statusCode == 200) {
         AppLogger.instance.i("OTP loaded1");
        final otpResponse = OtpResponse.fromJson(json.decode(response.body));
        AppLogger.instance.i("OTP loaded2");
        AppLogger.instance.i(otpResponse);
        AppLogger.instance.i("OTP loaded3");
        emit(OtpLoaded(otpResponse));
      } else {
        emit(OtpError('Failed to OTP'));
      }
    } catch (e) {
      emit(OtpError(e.toString()));
    }
  }
}
