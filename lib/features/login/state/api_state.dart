import 'package:canteen_app/features/login/model/login_model.dart';
import 'package:flutter/material.dart';

  
@immutable
abstract class ApiState {}

class ApiInitial extends ApiState {}

class ApiLoading extends ApiState {}

class ApiLoaded extends ApiState {
  final ApiResponse apiResponse;

  ApiLoaded(this.apiResponse);
}

class ApiError extends ApiState {
  final String message;

  ApiError(this.message);
}
