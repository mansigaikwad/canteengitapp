import 'package:canteen_app/features/login/cubit/login_cubit.dart';
import 'package:canteen_app/features/login/state/api_state.dart';
import 'package:canteen_app/features/otp/view/otp_screen.dart';
import 'package:canteen_app/logger/logger.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class LoginScreen extends StatelessWidget {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController usernameController = TextEditingController();
  String message = "";

  LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      body: SafeArea(
        child: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/images/Login-Screen.png'), // Replace with your background image
              fit: BoxFit.cover,
            ),
          ),
          child: SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: Column(
              children: [
                SizedBox(height: screenSize.height * 0.3),
                Form(
                  key: _formKey,
                  child: Column(
                    children: [
                      TextFormField(
                        controller: usernameController,
                        decoration: const InputDecoration(
                          hintText: 'Employee ID',
                          filled: true,
                          fillColor: Color(0xFFF5FCF9),
                          contentPadding: EdgeInsets.symmetric(
                              horizontal: 24.0, vertical: 16.0),
                          border: OutlineInputBorder(
                            borderSide: BorderSide.none,
                            borderRadius: BorderRadius.all(Radius.circular(50)),
                          ),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'This field is required';
                          }
                          return null;
                        },
                      ),
                      SizedBox(height: 30),
                      BlocConsumer<ApiCubit, ApiState>(
                        listener: (context, state) {
                          if (state is ApiLoaded) {
                            AppLogger.instance
                                .i(state.apiResponse.token.accessToken);
                            _showConfirmDialog(context, state);
                          } else if (state is ApiError) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text('Invalid Employee ID')),
                            );
                            usernameController.text = "";
                          }
                        },
                        builder: (context, state) {
                          if (state is ApiLoading) {
                            return CircularProgressIndicator();
                          }
                          return ElevatedButton(
                            onPressed: () {
                              if (_formKey.currentState!.validate()) {
                                final username = usernameController.text;
                                context.read<ApiCubit>().fetchToken(username);
                              }
                            },
                            child: Text(
                              'Sign In',
                              style: TextStyle(
                                fontSize: 20,
                                color: Color(0xFF000000),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.greenAccent,
                              minimumSize: Size(double.infinity, 48),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30.0),
                              ),
                            ),
                          );
                        },
                      ),
                      Text(message),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void _showConfirmDialog(BuildContext context, ApiLoaded state) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Center(
            child: Text(
              'CONFIRMATION',
              style: TextStyle(
                  color: Colors.green[700], fontWeight: FontWeight.bold),
            ),
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              Row(
                children: [
                  Text(
                    'Name  : ',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  Text(
                    '${state.apiResponse.token.employeeName}',
                    style: TextStyle(color: Colors.black, fontSize: 14),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Code  : ',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  Text(
                    '${state.apiResponse.token.employeeCode}',
                    style: TextStyle(color: Colors.black, fontSize: 14),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    'Phone : ',
                    style: TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 18),
                  ),
                  Text(
                    '${state.apiResponse.token.employeeMobile}',
                    style: TextStyle(color: Colors.black, fontSize: 14),
                  ),
                ],
              ),
            ],
          ),
          actions: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                FilledButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.red[500],
                    overlayColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: Text(
                    'Cancel',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
                SizedBox(width: 8),
                FilledButton(
                  style: TextButton.styleFrom(
                    backgroundColor: Colors.green[500],
                    overlayColor: Colors.white,
                  ),
                  onPressed: () {
                    Navigator.of(context).pop();
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => OTPScreen()),
                    );
                  },
                  child: Text(
                    'Confirm',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}
//************ */
 
// class LoginScreen extends StatelessWidget {
//   final _formKey = GlobalKey<FormState>();
//   final TextEditingController usernameController = TextEditingController();
//   String message = "";

//   LoginScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Container(
//           width: double.infinity,
//           height: double.infinity,
//           decoration: BoxDecoration(
//             image: DecorationImage(
//               image: AssetImage('assets/images/Login-Screen.png'), // Replace with your background image
//               fit: BoxFit.fill,
//             ),
//           ),
//           child: LayoutBuilder(
//             builder: (context, constraints) {
//               return SingleChildScrollView(
//                 padding: const EdgeInsets.symmetric(horizontal: 16.0),
//                 child: Column(
//                   children: [
//                     // SizedBox(height: constraints.maxHeight * 0.1),
//                     // Image.asset("assets/images/carimage2.png", height: 150),
//                     // SizedBox(height: constraints.maxHeight * 0.05),
//                     // Text(
//                     //   "Sign In to Continue",
//                     //   style: Theme.of(context).textTheme.headlineSmall!.copyWith(
//                     //       fontWeight: FontWeight.bold,
//                     //       color: Colors.white,
//                     //       fontSize: 26),
//                     // ),
//                     SizedBox(height: constraints.maxHeight * 0.3),
//                     Form(
//                       key: _formKey,
//                       child: Column(
//                         children: [
//                           TextFormField(
//                             controller: usernameController,
//                             decoration: const InputDecoration(
//                               hintText: 'Employee ID',
//                               filled: true,
//                               fillColor: Color(0xFFF5FCF9),
//                               contentPadding: const EdgeInsets.symmetric(
//                                   horizontal: 16.0 * 1.5, vertical: 16.0),
//                               border: const OutlineInputBorder(
//                                 borderSide: BorderSide.none,
//                                 borderRadius:
//                                     BorderRadius.all(Radius.circular(50)),
//                               ),
//                             ),
//                             validator: (value) {
//                               if (value == null || value.isEmpty) {
//                                 return 'This field is required';
//                               }
//                               return null;
//                             },
//                           ),
//                           SizedBox(height: 30),
//                           BlocConsumer<ApiCubit, ApiState>(
//                             listener: (context, state) {
//                               if (state is ApiLoaded) {
//                                 AppLogger.instance
//                                     .i(state.apiResponse.token.accessToken);
//                                 _showConfirmDialog(context, state);
//                               } else if (state is ApiError) {
//                                 ScaffoldMessenger.of(context).showSnackBar(
//                                   SnackBar(
//                                       content: Text('Invalid Employee ID')),
//                                 );
//                                 usernameController.text = "";
//                               }
//                             },
//                             builder: (context, state) {
//                               if (state is ApiLoading) {
//                                 return CircularProgressIndicator();
//                               }
//                               return ElevatedButton(
//                                 onPressed: () {
//                                   if (_formKey.currentState!.validate()) {
//                                     final username = usernameController.text;
//                                     context.read<ApiCubit>().fetchToken(username);
//                                   }
//                                 },
//                                 child: Text(
//                                   'Sign In',
//                                   style: TextStyle(
//                                     fontSize: 20,
//                                     color: Color(0xFF000000),
//                                     fontWeight: FontWeight.bold,
//                                   ),
//                                 ),
//                                 style: ElevatedButton.styleFrom(
//                                   backgroundColor: Colors.greenAccent,
//                                   minimumSize: const Size(double.minPositive, 48),
//                                   shape: RoundedRectangleBorder(
//                                     borderRadius: BorderRadius.circular(30.0),
//                                   ),
//                                 ),
//                               );
//                             },
//                           ),
//                           Text(message),
//                         ],
//                       ),
//                     ),
//                   ],
//                 ),
//               );
//             },
//           ),
//         ),
//       ),
//     );
//   }

//   void _showConfirmDialog(BuildContext context, ApiLoaded state) {
//     showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           title: Center(
//             child: Text(
//               'CONFIRMATION',
//               style: TextStyle(
//                   color: Colors.green[700], fontWeight: FontWeight.bold),
//             ),
//           ),
//           content: Column(
//             mainAxisSize: MainAxisSize.min,
//             children: <Widget>[
//               Row(
//                 children: [
//                   Text(
//                     'Name  : ',
//                     style: TextStyle(
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 18),
//                   ),
//                   Text(
//                     '${state.apiResponse.token.employeeName}',
//                     style: TextStyle(color: Colors.black, fontSize: 14),
//                   ),
//                 ],
//               ),
//               Row(
//                 children: [
//                   Text(
//                     'Code  : ',
//                     style: TextStyle(
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 18),
//                   ),
//                   Text(
//                     '${state.apiResponse.token.employeeCode}',
//                     style: TextStyle(color: Colors.black, fontSize: 14),
//                   ),
//                 ],
//               ),
//               Row(
//                 children: [
//                   Text(
//                     'Phone : ',
//                     style: TextStyle(
//                         color: Colors.black,
//                         fontWeight: FontWeight.bold,
//                         fontSize: 18),
//                   ),
//                   Text(
//                     '${state.apiResponse.token.employeeMobile}',
//                     style: TextStyle(color: Colors.black, fontSize: 14),
//                   ),
//                 ],
//               ),
//             ],
//           ),
//           actions: <Widget>[
//             Row(
//               mainAxisAlignment: MainAxisAlignment.center,
//               children: [
//                 FilledButton(
//                   style: TextButton.styleFrom(
//                     backgroundColor: Colors.red[500],
//                     overlayColor: Colors.white,
//                   ),
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                   },
//                   child: Text(
//                     'Cancel',
//                     style: TextStyle(fontSize: 16),
//                   ),
//                 ),
//                 SizedBox(width: 8),
//                 FilledButton(
//                   style: TextButton.styleFrom(
//                     backgroundColor: Colors.green[500],
//                     overlayColor: Colors.white,
//                   ),
//                   onPressed: () {
//                     Navigator.of(context).pop();
//                     Navigator.push(
//                       context,
//                       MaterialPageRoute(
//                           builder: (context) => OTPScreen()),
//                     );
//                   },
//                   child: Text(
//                     'Confirm',
//                     style: TextStyle(fontSize: 16),
//                   ),
//                 ),
//               ],
//             ),
//           ],
//         );
//       },
//     );
//   }
// }
