import 'package:canteen_app/features/home/dashboard_screen.dart';
import 'package:canteen_app/features/login/cubit/login_cubit.dart';
import 'package:canteen_app/features/otp/cubit/otp_cubit.dart';
import 'package:canteen_app/splash_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void main() {
  runApp(MultiBlocProvider(
    providers: [
      BlocProvider<ApiCubit>(
        create: (context) => ApiCubit(),
      ),
      BlocProvider<OtpCubit>(
        create: (context) => OtpCubit(),
      ),
      
    ],
    child: MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SplashScreen(),
    ),
  ));
}


