import 'dart:convert';
import 'package:canteen_app/features/login/cubit/login_cubit.dart';
import 'package:canteen_app/features/login/state/api_state.dart';
import 'package:canteen_app/features/otp/cubit/otp_cubit.dart';
import 'package:canteen_app/logger/logger.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:http/http.dart' as http;
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:permission_handler/permission_handler.dart';

class CouponForSelfScreen extends StatefulWidget {
  const CouponForSelfScreen({super.key});

  @override
  State<CouponForSelfScreen> createState() => _CouponForSelfScreenState();
}

class _CouponForSelfScreenState extends State<CouponForSelfScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String qrText = '';
  bool isFlashOn = false;

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenSize = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Scan QR Code'),
        actions: [
          IconButton(
            icon: Icon(isFlashOn ? Icons.flash_on : Icons.flash_off),
            onPressed: () async {
              await controller?.toggleFlash();
              setState(() {
                isFlashOn = !isFlashOn;
              });
            },
          ),
        ],
      ),
      body: SafeArea(
        child: FutureBuilder(
          future: _checkCameraPermission(),
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return const Center(child: CircularProgressIndicator());
            } else if (snapshot.hasError || !snapshot.data!) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text('Camera permission is required to scan QR codes.'),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () async {
                        await openAppSettings();
                      },
                      child: const Text('Open Settings'),
                    ),
                  ],
                ),
              );
            } else {
              return Column(
                children: <Widget>[
                  Expanded(
                    flex: 5,
                    child: QRView(
                      key: qrKey,
                      onQRViewCreated: _onQRViewCreated,
                      overlay: QrScannerOverlayShape(
                        borderColor: Colors.red,
                        borderRadius: 10,
                        borderLength: 30,
                        borderWidth: 10,
                        cutOutSize: screenSize.width * 0.8,
                      ),
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Center(
                      child: Text(
                        'Scan result: $qrText',
                        style: const TextStyle(fontSize: 18),
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }

  Future<bool> _checkCameraPermission() async {
    var status = await Permission.camera.status;
    if (status.isDenied) {
      status = await Permission.camera.request();
    }
    return status.isGranted;
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) {
      setState(() {
        qrText = scanData.code ?? '';
      });
      // Handle the scanned data here
      _handleScannedData(scanData.code ?? '');
    });
  }
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
    context.read<OtpCubit>().fetchOtp(
        apistate.apiResponse.token.employeeCode,
        apistate.apiResponse.token.employeeMobile,
        apistate.apiResponse.token.accessToken);
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
}