import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foriyana_app/core/router/app_router.dart';
import 'package:foriyana_app/presentation/widgets/button_back.dart';
import 'package:http/http.dart' as http;
import 'package:foriyana_app/data/data_sources/user_local_data_source.dart';
import 'package:foriyana_app/data/models/auth_response_model.dart';
import 'package:foriyana_app/data/models/user_model.dart';
import 'package:foriyana_app/generated/l10n.dart';
import 'package:foriyana_app/presentation/blocs/cubit/auth_cubit.dart';
import 'package:foriyana_app/presentation/blocs/cubit/otp_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OtpPage extends StatefulWidget {
  const OtpPage({super.key});

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> with WidgetsBindingObserver {
  bool isLoading = false;
  bool isLoadingResend = false;
  int otpLength = 4;
  final List<TextEditingController> controllers = List.generate(
    4,
    (index) => TextEditingController(),
  );

  final List<FocusNode> focusNodesListener = List.generate(
    4,
    (index) => FocusNode(),
  );
  final List<FocusNode> focusNodes = List.generate(4, (index) => FocusNode());
  var args;
  late final UserLocalDataSource userLocalDataSource;

  // void onChanged(String value, int index) {
  //   if (value.isNotEmpty && index < 5) {
  //     FocusScope.of(context).nextFocus();
  //   } else if (value.isEmpty && index > 0) {
  //     FocusScope.of(context).previousFocus();
  //   }
  // }

  String getOTP() {
    return controllers.map((c) => c.text).join();
  }

  Future<void> _initializeUserLocalDataSource() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final secureStorage = const FlutterSecureStorage();

    userLocalDataSource = UserLocalDataSourceImpl(
      sharedPreferences: sharedPreferences,
      secureStorage: secureStorage,
    );
  }

  void checkOtpComplete() {
    final otp = controllers.map((c) => c.text).join().trim();
    if (otp.length == otpLength) {
      print("OTP Completed: $otp");
      verifyOtp();
      // You can call your submit logic here
    }
  }

  void onBackspacePressed(String value, int index) {
    if (value.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(focusNodes[index - 1]);
    }
  }

  void onChanged(String value, int index) {
    if (value.length == 1 && index < otpLength - 1) {
      FocusScope.of(context).requestFocus(focusNodes[index + 1]);
    }
    // if (value.length == 1 && index < 6) {
    //   FocusScope.of(context)
    //       .requestFocus(focusNodes[index + 1]);
    // }
    // if (value.length > 1) {
    //   final pastedValues = value.split('');
    //   for (int i = 0;
    //       i < pastedValues.length && i < 6;
    //       i++) {
    //     controllers[i].text = pastedValues[i];
    //   }
    //   FocusScope.of(context).unfocus(); // optional
    // }
    // else {
    //   onChanged(value, index);
    // }
  }

  void handleKeyEvent(KeyEvent event, int index) {
    if (event.logicalKey == LogicalKeyboardKey.backspace &&
        controllers[index].text.isEmpty &&
        index > 0) {
      FocusScope.of(context).requestFocus(focusNodes[index - 1]);
      controllers[index - 1].selection = TextSelection(
        baseOffset: 0,
        extentOffset: controllers[index - 1].text.length,
      );
    }
  }

  Future<void> checkClipboardForOtp() async {
    final clipboardData = await Clipboard.getData(Clipboard.kTextPlain);
    final text = clipboardData?.text?.trim() ?? '';

    if (text.length == 4 && RegExp(r'^\d{6}$').hasMatch(text)) {
      for (int i = 0; i < 4; i++) {
        controllers[i].text = text[i];
      }
      FocusScope.of(context).unfocus();
      print('OTP auto-filled from clipboard: $text');
    }
  }

  @override
  void initState() {
    _initializeUserLocalDataSource();

    for (int i = 0; i < otpLength; i++) {
      controllers[i].addListener(checkOtpComplete);
    }
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    for (var focusNode in focusNodes) {
      focusNode.dispose();
    }
    for (var focusNode in focusNodesListener) {
      focusNode.dispose();
    }
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.resumed) {
      print('🔄 App resumed');
      if (controllers[0].text.isEmpty) {
        await checkClipboardForOtp();
      }
      // Check clipboard again or refresh data
    } else if (state == AppLifecycleState.paused) {
      print('⏸️ App paused');
    }
  }

  String formatTime(int seconds) {
    final minutes = (seconds ~/ 60).toString().padLeft(2, '0');
    final secs = (seconds % 60).toString().padLeft(2, '0');
    return '$minutes:$secs';
  }

  Future<void> verifyOtp() async {
    String otp = getOTP();
    if (otp.length < 4) {
      debugPrint("Invalid OTP");
      return;
    }

    FocusScope.of(context).unfocus(); // optional
    setState(() {
      isLoading = true;
    });

    try {
      Navigator.pushReplacementNamed(context, AppRouter.createNewPassword);
    } catch (ex) {
      Fluttertoast.showToast(
        msg: "Error Internal",
        backgroundColor: Colors.red,
      );
      print(ex);
    }

    controllers.forEach((c) => c.clear());
    setState(() {
      isLoading = false;
    });
  }

  Future<void> resendOtp(BuildContext context) async {
    setState(() {
      isLoadingResend = true;
    });
    try {
      var response = await http.post(
        Uri.parse('https://stg-auth-service-2xr35.ondigitalocean.app/otp/send'),
        headers: <String, String>{
          'authorization': 'Bearer 6eyw7n4kk9063sivf6ubt8dz5kyhwl',
        },
        body: {'email': args["email"], 'phoneNumber': args["phoneNumber"]},
      );
      var res = json.decode(response.body);
      if (response.statusCode == 201 &&
          res["message"] == "OTP sent successfully") {
        Fluttertoast.showToast(
          msg: res["message"],
          backgroundColor: Colors.green,
        );
        context.read<OtpCubit>().resetTimer();
      } else {
        Fluttertoast.showToast(
          msg: res["message"],
          backgroundColor: Colors.red,
        );
      }
    } catch (e) {
      debugPrint('Login error: $e');
    }
    controllers.forEach((c) => c.clear());
    setState(() {
      isLoadingResend = false;
    });
  }

  // Function to handle session code and perform POST request
  void _handleSessionCode(String? sessionCode) async {
    if (sessionCode == null || sessionCode.isEmpty) {
      debugPrint("Error: Session code is null or empty.");
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });
      var response = await http.post(
        Uri.parse(
          'https://stg-auth-service-2xr35.ondigitalocean.app/sso/login',
        ),
        headers: <String, String>{
          'authorization': 'Bearer 6eyw7n4kk9063sivf6ubt8dz5kyhwl',
        },
        body: {'session_code': sessionCode},
      );

      debugPrint('Response Code: ${response.body}');

      var responseLogin = authResponseModelFromJson(response.body);
      debugPrint('responseLogin.token: ${responseLogin.token}');

      // Save token
      await userLocalDataSource.saveToken(responseLogin.token);

      // ignore: use_build_context_synchronously
      UserModel user = await userLocalDataSource.getUser();
      await userLocalDataSource.saveUser(user);
      // context.read<AuthCubit>().getUserInformation(responseLogin.token);

      // context.read<AuthCubit>().checkAuthStatus();

      // Navigate to home and remove login from backstack
      // ignore: use_build_context_synchronously

      setState(() {
        isLoading = false;
      });
      context.read<AuthCubit>().saveToken(responseLogin.token);
      Navigator.of(context).pushReplacementNamed('/home');
    } catch (e) {
      debugPrint('Login error: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context)?.settings.arguments as Map?;

    // isLoading = false;

    return BlocProvider(
      create: (_) => OtpCubit()..startTimer(),
      child: Scaffold(
        appBar: AppBar(
          leading: ButtonBack(),
          leadingWidth: 40,
          backgroundColor: Colors.white,
          elevation: 0,
        ),
        body: BlocBuilder<OtpCubit, int>(builder: (context, state) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Verification Code",
                  style: TextStyle(fontSize: 26, fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 15),
                const Text(
                  "Please Enter the verification code we sent to your email address",
                  style: TextStyle(color: Colors.black54, fontSize: 16),
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    4,
                    (index) => Container(
                      width: 60,
                      height: 60,
                      margin: const EdgeInsets.symmetric(horizontal: 5),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                        border: Border.all(color: Colors.grey),
                      ),
                      child: Focus(
                        onKeyEvent: (FocusNode node, KeyEvent event) {
                          handleKeyEvent(event, index);
                          return KeyEventResult.ignored;
                        },
                        child: TextField(
                          controller: controllers[index],
                          focusNode: focusNodes[index],
                          keyboardType: TextInputType.number,
                          textAlign: TextAlign.center,
                          maxLength: 1,
                          style: TextStyle(fontWeight: FontWeight.bold),
                          cursorColor: Colors.red,
                          decoration: InputDecoration(
                            counterText: "",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(8),
                              borderSide: BorderSide.none,
                            ),
                          ),
                          onTap: () async {
                            controllers[index].selection = TextSelection(
                              baseOffset: 0,
                              extentOffset: controllers[index].text.length,
                            );
                            // if (controllers[0].text.isEmpty) {
                            //   await checkClipboardForOtp();
                            // }
                          },
                          onChanged: (value) {
                            onChanged(value, index);
                          },
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 40),
                Row(
                  children: [
                    GestureDetector(
                      onTap: isLoadingResend && state > 0
                          ? null
                          : () async {
                              resendOtp(context);
                            },
                      child: Text(
                        "Resend in",
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: state > 0 ? Colors.grey : null,
                        ),
                      ),
                    ),
                    SizedBox(
                      width: 8,
                    ),
                    Container(
                      child: Column(
                        children: [
                          Text(
                            formatTime(state),
                            style: TextStyle(fontSize: 16, color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        }),
      ),
    );
  }
}
