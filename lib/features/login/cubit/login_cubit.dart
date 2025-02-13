import 'package:bloc/bloc.dart';
import 'package:canteen_app/features/login/model/login_model.dart';
import 'package:canteen_app/features/login/state/api_state.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';


class ApiCubit extends Cubit<ApiState> {
  ApiCubit() : super(ApiInitial());

  Future<void> fetchToken(String username) async {
    try {
      emit(ApiLoading());
      final response = await http.post(
        Uri.parse('https://ccapi.mahyco.com/api/CustomAuth/customToken'),
        headers: {'Content-Type': 'application/json'},
        body: json.encode({"username": username}),
      );
      if (response.statusCode == 200) {
        final apiResponse = ApiResponse.fromJson(json.decode(response.body));
        emit(ApiLoaded(apiResponse));
      } else {
        emit(ApiError('Failed to fetch token'));
      }
    } catch (e) {
      emit(ApiError(e.toString()));
       //emit(ApiError("Invalid Employee SAPID"));
    }
  }
}
//otp

