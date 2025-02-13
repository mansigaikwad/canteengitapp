import 'package:canteen_app/features/otp/model/otp_model.dart';
import 'package:flutter/material.dart';

  
@immutable
abstract class OtpState {}

class OtpInitial extends OtpState {}

class OtpLoading extends OtpState  {}

class OtpLoaded extends OtpState  {
  final OtpResponse Otpresponse;

  OtpLoaded(this.Otpresponse);
}

class OtpError extends OtpState  {
  final String message;

  OtpError(this.message);
}