import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:canteen_app/features/login/cubit/login_cubit.dart';
import 'package:canteen_app/features/login/state/api_state.dart';
import 'package:canteen_app/features/otp/cubit/otp_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../coupon_for_self/view/coupon_for_self.dart';

class DashboardScreen extends StatefulWidget {
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  @override
  void initState() {
    super.initState();
   // checkForUpdates();
  }

  Future<void> checkForUpdates() async {
    try {
      // Get current app version
      PackageInfo packageInfo = await PackageInfo.fromPlatform();
      String currentVersion = packageInfo.version;

      // Make API call to App Store
      final response = await http.get(
        Uri.parse('http://itunes.apple.com/lookup?bundleId=${packageInfo.packageName}'),
      );

      if (response.statusCode == 200) {
        final jsonResult = json.decode(response.body);
        if (jsonResult['resultCount'] > 0) {
          final storeVersion = jsonResult['results'][0]['version'];
          
          // Compare versions and show alert if update is available
          if (storeVersion != currentVersion) {
            WidgetsBinding.instance.addPostFrameCallback((_) {
              showUpdateDialog(context, storeVersion);
            });
          }
        }
      }
    } catch (e) {
      print('Error checking for updates: $e');
    }
  }

  void showUpdateDialog(BuildContext context, String storeVersion) {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: Text('Update Available'),
        content: Text('A new version ($storeVersion) is available. Please update to continue using the app.'),
        actions: [
          TextButton(
            onPressed: () async {
              // Open App Store
              final appStoreUrl = 'https://apps.apple.com/app/[YOUR_APP_ID]';
              if (await canLaunchUrl(Uri.parse(appStoreUrl))) {
                await launchUrl(Uri.parse(appStoreUrl));
              }
            },
            child: Text('Update Now'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: Text('Later'),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.green[700],
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text('HOME'),
          ],
        ),
      ),
      drawer: Drawer(
        child: ListView(
          padding: EdgeInsets.zero,
          children: <Widget>[
            DrawerHeader(
              decoration: BoxDecoration(
                color: Colors.yellow[200],
              ),
              child: BlocBuilder<ApiCubit, ApiState>(
                builder: (context, state) {
                  if (state is ApiLoaded) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Text(
                        //   'Menu',
                        //   style: TextStyle(
                        //     color: Colors.green[700],
                        //     fontSize: 24,
                        //   ),
                        // ),
                        SizedBox(height: 8),
                        Text(
                          'Name: ${state.apiResponse.token.employeeName}',
                          style: TextStyle(
                            color: Colors.green[700],
                            fontSize: 16,
                          ),
                        ),
                        Text(
                          'Mobile: ${state.apiResponse.token.employeeMobile}',
                          style: TextStyle(
                            color: Colors.green[700],
                            fontSize: 16,
                          ),
                        ),
                      ],
                    );
                  }
                  return Text(
                    'Menu',
                    style: TextStyle(
                      color: Colors.green[700],
                      fontSize: 24,
                    ),
                  );
                },
              ),
            ),
            ListTile(
              leading: Icon(Icons.home),
              title: Text(
                'Home',
                style: TextStyle(
                  color: Colors.green[700],
                  fontSize: 20,
                ),
              ),
              onTap: () {
                // Handle Home tap
              },
            ),
            ListTile(
              leading: Icon(Icons.settings),
              title: Text('Settings',
              style: TextStyle(
                  color: Colors.green[700],
                  fontSize: 20,
                ),),
              onTap: () {
                // Handle Settings tap
              },
            ),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text('Logout',style: TextStyle(
                  color: Colors.green[700],
                  fontSize: 20,
                ),),
              onTap: () {
                // Handle Logout tap
              },
            ),
          ],
        ),
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: ImageButton(
                    imagePath: 'assets/images/Group 8.png',
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const CouponForSelfScreen(),
                        ),
                      );
                      // _handleScannedData(" canteen@mahyco ");
                      // Handle button 1 press
                    },
                  ),
                ),
                SizedBox(height: constraints.maxHeight * 0.02),
                Center(
                  child: ImageButton(
                    imagePath: 'assets/images/Group 9.png',
                    onPressed: () {
                      // Handle button 2 press
                      showDialog(context: context, builder: (context) => AlertDialog(
                        title: Text('Coming Soon'),
                        content: Text('This feature is coming soon'),
                      ));
                    },
                  ),
                ),
                SizedBox(height: constraints.maxHeight * 0.02),
                Center(
                  child: ImageButton(
                    imagePath: 'assets/images/Group 10.png',
                    onPressed: () {
                       showDialog(context: context, builder: (context) => AlertDialog(
                        title: Text('Coming Soon'),
                        content: Text('This feature is coming soon'),
                      ));
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }


  //testing code here

 bool _isLoading = false;

  void _showLoadingDialog() {
    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }

  void _hideLoadingDialog() {
    Navigator.of(context).pop();
  }

  Future<void> _handleScannedData(String data) async {
    // Add your logic to handle the scanned data
    debugPrint('Scanned QR Code: $data');
    // Send POST request with QR data
    if(data==" canteen@mahyco "){
      _showLoadingDialog();
      sendRequest();
    }else{
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: Text('Invalid QR Code'),
          content: Text('Please scan a valid QR code.'),
        ),
      );
    }
    // You can navigate to another screen or show a dialog with the scanned data
  }
  Future<void> sendRequest() async {
     try {
      ApiLoaded apistate = context.read<ApiCubit>().state as ApiLoaded;
    // context.read<OtpCubit>().fetchOtp(
    //     apistate.apiResponse.token.employeeCode,
    //     apistate.apiResponse.token.employeeMobile,
    //     apistate.apiResponse.token.accessToken);
      final response = await http.post(
        Uri.parse('https://ccapi.mahyco.com/api/CanteenVisits/addScanedQR'),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          "Token": apistate.apiResponse.token.accessToken,
          "EmployeeCode": apistate.apiResponse.token.employeeCode,
          "Remark": "",
          "SelfCount": 1,
          "GuestCount": 0,
          "CouponId": 1,
          "VisitedDt": DateTime.now().toIso8601String(),
          "VisitedTimeStamp": DateTime.now().toIso8601String(), 
          "AppVersion": "1.14"
        }),
      );

      if (response.statusCode == 200) {
        debugPrint('Request successful');
        print(response.body);
        // Handle success response
      } else {
        debugPrint('Request failed with status: ${response.statusCode}');
        // Handle error response
      }
      _hideLoadingDialog();
    } catch (e) {
      _hideLoadingDialog();
      debugPrint('Error sending request: $e');
      // Handle network/other errors
    }
  }

  //test code end here
}

class ImageButton extends StatelessWidget {
  final String imagePath;
  final VoidCallback onPressed;

  ImageButton({required this.imagePath, required this.onPressed});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Image.asset(
        imagePath,
        width: 190, // Set the width for medium size
        height: 160, // Set the height for medium size
      ),
    );
  }
}
