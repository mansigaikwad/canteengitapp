import 'package:canteen_app/features/home/dashboard_screen.dart';
import 'package:canteen_app/features/login/cubit/login_cubit.dart';
import 'package:canteen_app/features/login/state/api_state.dart';
import 'package:canteen_app/features/otp/cubit/otp_cubit.dart';
import 'package:canteen_app/features/otp/state/otp_state.dart';
import 'package:canteen_app/logger/logger.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:otp_autofill/otp_autofill.dart';



class OTPScreen extends StatefulWidget {
  const OTPScreen({super.key});

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: LogoWithTitle(
        title: 'Verification',
        subText: "SMS Verification code has been sent",
        children: [
          // const Text("+1 18577 11111"),
          SizedBox(height: MediaQuery.of(context).size.height * 0.04),
          // OTP Form
          const OtpForm(),
        ],
      ),
    );
  }
}

class OtpForm extends StatefulWidget {
  const OtpForm({super.key});

  @override
  _OtpFormState createState() => _OtpFormState();
}

class _OtpFormState extends State<OtpForm> {
  final _formKey = GlobalKey<FormState>();
  final List<TextInputFormatter> otpTextInputFormatters = [
    FilteringTextInputFormatter.digitsOnly,
    LengthLimitingTextInputFormatter(1),
  ];
  late OTPTextEditController controller;
  late OTPInteractor _otpInteractor;

  late FocusNode _pin1Node;
  late FocusNode _pin2Node;
  late FocusNode _pin3Node;
  late FocusNode _pin4Node;
  late FocusNode _pin5Node;
  late FocusNode _pin6Node;
  TextEditingController txt1 = new TextEditingController();
  TextEditingController txt2 = new TextEditingController();
  TextEditingController txt3 = new TextEditingController();
  TextEditingController txt4 = new TextEditingController();
  TextEditingController txt5 = new TextEditingController();
  TextEditingController txt6 = new TextEditingController();
  @override
  void initState() {
    super.initState();
    _pin1Node = FocusNode();
    _pin2Node = FocusNode();
    _pin3Node = FocusNode();
    _pin4Node = FocusNode();
    _pin5Node = FocusNode();
    _pin6Node = FocusNode();

    _initInteractor();
    controller = OTPTextEditController(
      codeLength: 6,
      //ignore: avoid_print
      onCodeReceive: (code) {
        AppLogger.instance.i('Your Application receive code - $code');
        List<String> characters = code.split('');
        AppLogger.instance.i(characters); // Output: [H, e, l, l, o]
        txt1.text = characters.elementAt(0);
        txt2.text = characters.elementAt(1);
        txt3.text = characters.elementAt(2);
        txt4.text = characters.elementAt(3);
        txt5.text = characters.elementAt(4);
        txt6.text = characters.elementAt(5);
      },
      otpInteractor: _otpInteractor,
    )..startListenUserConsent(
        (code) {
          final exp = RegExp(r'(\d{6})');
          return exp.stringMatch(code ?? '') ?? '';
        },
      );
  }

  @override
  void dispose() {
    super.dispose();
    _pin1Node.dispose();
    _pin2Node.dispose();
    _pin3Node.dispose();
    _pin4Node.dispose();
    _pin5Node.dispose();
    _pin6Node.dispose();
    controller.stopListen();
  }

  Future<void> _initInteractor() async {
    _otpInteractor = OTPInteractor();

    // You can receive your app signature by using this method.
    final appSignature = await _otpInteractor.getAppSignature();

    if (kDebugMode) {
      print('Your app signature: $appSignature');
    }
  }

  String otpString = "pass is :";
  @override
  Widget build(BuildContext context) {
    ApiLoaded apistate = context.read<ApiCubit>().state as ApiLoaded;
    context.read<OtpCubit>().fetchOtp(
        apistate.apiResponse.token.employeeCode,
        apistate.apiResponse.token.employeeMobile,
        apistate.apiResponse.token.accessToken);

    return Form(
      key: _formKey,
      child: Column(
        children: [
          Row(
            children: [
              Expanded(
                child: OtpTextFormField(
                  textEditingController: txt1,
                  focusNode: _pin1Node,
                  onChanged: (value) {
                    if (value.length == 1) _pin2Node.requestFocus();
                  },
                  onSaved: (pin) {},
                  autofocus: true,
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: OtpTextFormField(
                  textEditingController: txt2,
                  focusNode: _pin2Node,
                  onChanged: (value) {
                    if (value.length == 1) _pin3Node.requestFocus();
                     if(value.isEmpty) _pin1Node.requestFocus();
                  },
                  onSaved: (pin) {
                    // Save it
                  },
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: OtpTextFormField(
                  textEditingController: txt3,
                  focusNode: _pin3Node,
                  onChanged: (value) {
                    if (value.length == 1) _pin4Node.requestFocus();
                     if(value.isEmpty) _pin2Node.requestFocus();
                  },
                  onSaved: (pin) {
                    // Save it
                  },
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: OtpTextFormField(
                  textEditingController: txt4,
                  focusNode: _pin4Node,
                  onChanged: (value) {
                    if (value.length == 1) _pin5Node.requestFocus();
                     if(value.isEmpty) _pin3Node.requestFocus();
                  },
                  onSaved: (pin) {
                    // Save it
                  },
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: OtpTextFormField(
                  textEditingController: txt5,
                  focusNode: _pin5Node,
                  onChanged: (value) {
                    if (value.length == 1) _pin6Node.requestFocus();
                     if(value.isEmpty) _pin4Node.requestFocus();
                  },
                  onSaved: (pin) {
                    // Save it
                  },
                ),
              ),
              const SizedBox(width: 16.0),
              Expanded(
                child: OtpTextFormField(
                  textEditingController: txt6,
                  focusNode: _pin6Node,
                  onChanged: (value) {
                    if (value.length == 1) _pin6Node.unfocus();
                    if(value.isEmpty) _pin5Node.requestFocus();
                  },
                  onSaved: (pin) {
                    // Save it
                  },
                ),
              ),
            ],
          ),
          const SizedBox(height: 16.0),
          BlocBuilder<OtpCubit, OtpState>(
            builder: (context, state) {
              if (state is OtpLoaded) {
                return ElevatedButton(
                  onPressed: () {
                    OtpLoaded otpLoaded = state;
                    String otp = txt1.text +
                        txt2.text +
                        txt3.text +
                        txt4.text +
                        txt5.text +
                        txt6.text;
                    AppLogger.instance.i('Entered OTP: $otp');
                    String otp1 = otpLoaded.Otpresponse.OTP;
                    if (otp == otp1) {
                      Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                              builder: (context) => DashboardScreen()));
                    } else {
                      const snackBar = SnackBar(
                        content: Text('Invalid OTP !'),
                        duration: Duration(seconds: 5), // Display for 5 seconds
                      );

                      // Show the SnackBar
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }

                    // if (_formKey.currentState!.validate()) {
                    //   _formKey.currentState!.save();
                    //   // check your code
                    //   Navigator.push(
                    //       context,
                    //       MaterialPageRoute(
                    //           builder: (context) => VehicleBookingScreen()));
                    // }
                  },
                  style: ElevatedButton.styleFrom(
                    elevation: 0,
                    backgroundColor: const Color(0xFF4caf50),
                    foregroundColor: Colors.white,
                    minimumSize: const Size(double.infinity, 48),
                    shape: const StadiumBorder(),
                  ),
                  child: const Text(
                    "Next",
                    style: TextStyle(fontSize: 20),
                  ),
                );
              }
              return ElevatedButton(
                onPressed: null,
                style: ElevatedButton.styleFrom(
                  elevation: 0,
                  backgroundColor: const Color(0xFF4caf50),
                  foregroundColor: Colors.white,
                  minimumSize: const Size(double.infinity, 48),
                  shape: const StadiumBorder(),
                ),
                child: const Text(
                  "Next",
                  style: TextStyle(fontSize: 20),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}

const InputDecoration otpInputDecoration = InputDecoration(
  filled: false,
  border: UnderlineInputBorder(),
  hintText: "0",
);

class OtpTextFormField extends StatelessWidget {
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final FormFieldSetter<String>? onSaved;
  final bool autofocus;
  final TextEditingController? textEditingController;

  const OtpTextFormField(
      {Key? key,
      this.focusNode,
      this.onChanged,
      this.onSaved,
      this.autofocus = false,
      this.textEditingController})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      focusNode: focusNode,
      onChanged: onChanged,
      onSaved: onSaved,
      autofocus: autofocus,
      // obscureText: true,
      controller: textEditingController,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(1),
      ],
      textAlign: TextAlign.center,
      keyboardType: TextInputType.number,
      style: Theme.of(context).textTheme.headlineSmall,
      decoration: otpInputDecoration,
    );
  }
}

class LogoWithTitle extends StatelessWidget {
  final String title, subText;
  final List<Widget> children;

  const LogoWithTitle(
      {Key? key,
      required this.title,
      this.subText = '',
      required this.children})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: LayoutBuilder(builder: (context, constraints) {
        return SingleChildScrollView(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Column(
            children: [
              SizedBox(height: constraints.maxHeight * 0.1),
              Image.asset("assets/images/icon.png", height: 150),
              // Image.network(
              //   "https://i.postimg.cc/nz0YBQcH/Logo-light.png",
              //   height: 100,
              // ),
              SizedBox(
                height: constraints.maxHeight * 0.1,
                width: double.infinity,
              ),
              Text(
                title,
                style: Theme.of(context)
                    .textTheme
                    .headlineSmall!
                    .copyWith(fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 16.0),
                child: Text(
                  subText,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    height: 1.5,
                    color: Theme.of(context)
                        .textTheme
                        .bodyLarge!
                        .color!
                        .withOpacity(0.64),
                  ),
                ),
              ),
              ...children,
            ],
          ),
        );
      }),
    );
  }
}
