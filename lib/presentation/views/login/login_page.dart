import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:foriyana_app/core/router/app_router.dart';
import 'package:foriyana_app/data/data_sources/local/user_local_data_source.dart';
import 'package:foriyana_app/env/config.dart';
import 'package:foriyana_app/presentation/widgets/filter_language.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isDev = false;
  bool _isLoading = false;
  // late final AuthRepository _authRepository;
  late final UserLocalDataSource userLocalDataSource;

  String callbackUrl = 'myapp://customer-portal.app'; // Callback URL default
  late String selectedLocal;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _phoneFocus = FocusNode();

  Future<void> _initializeUserLocalDataSource() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final secureStorage = const FlutterSecureStorage();

    userLocalDataSource = UserLocalDataSourceImpl(
      sharedPreferences: sharedPreferences,
      secureStorage: secureStorage,
    );
  }

  @override
  void initState() {
    selectedLocal = UserLocalDataSource.language;
    super.initState();
    // _initialize2WebView();

    // ✅ Initialize UserLocalDataSourceImpl with dependencies
    _initializeUserLocalDataSource();
    // if (Config.env.appName == "MyApp (Dev)") {
    //   isDev = true;
    // }
    // if (isDev) {
    //   // _emailController.text = "dev-friendsure@yopmail.com";
    //   // _phoneController.text = "82297897576";

    //   _emailController.text = "123@yopmail.com";
    //   _phoneController.text = "123123123";
    // }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _phoneFocus.requestFocus();
    });
  }

  void _handleSubmit() async {
    Navigator.of(context).pushReplacementNamed(
      AppRouter.home,
    );
    return;
    if (_formKey.currentState!.validate()) {
      //handle submit
      setState(() {
        _isLoading = true;
      });
      try {
        String phoneCode = "+" + getPhoneCode(selectedLocal);
        String phoneNumber = phoneCode + _phoneController.text;
        String baseUrl = dotenv.get('BASE_API_URL');

        var response = await http.post(
          Uri.parse(
            baseUrl,
          ),
          headers: <String, String>{
            'authorization': 'Bearer 6eyw7n4kk9063sivf6ubt8dz5kyhwl',
          },
          body: {'email': _emailController.text, 'phoneNumber': phoneNumber},
        );
        var res = json.decode(response.body);
        if (response.statusCode == 201 &&
            res["message"] == "OTP sent successfully") {
          Navigator.of(context).pushReplacementNamed(
            '/otp',
            arguments: {
              "email": _emailController.text,
              'phoneNumber': phoneNumber,
            },
          );
        } else {
          Fluttertoast.showToast(
            msg: res["message"],
            backgroundColor: Colors.red,
          );
        }
        // if (res["message"] == 'User not found' ||
        //     res["message"] == 'User not found or inactive') {
        //   Fluttertoast.showToast(
        //       msg: res["message"], backgroundColor: Colors.red);
        // } else {
        //   // Navigate to home and remove login from backstack
        //   // ignore: use_build_context_synchronously
        //   Navigator.of(context).pushReplacementNamed('/otp');
        // }
      } catch (e) {
        debugPrint('Login error: $e');
      }
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _emailFocus.dispose();
    _phoneFocus.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          // title: isDev
          //     ? GestureDetector(
          //         onTap: () {
          //           Navigator.of(context).pushReplacementNamed('/home');
          //         },
          //         child: Icon(Icons.home))
          //     : Text(""),
          // actions: [
          //   isDev
          //       ? GestureDetector(
          //           onTap: () {
          //             Navigator.of(context).pushNamed('/otp');
          //           },
          //           child: Text("OTP"))
          //       : Text(""),
          //   SizedBox(
          //     width: 10,
          //   ),
          // ],
          ),
      body: Form(
        key: _formKey,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ListView(
              children: [
                const SizedBox(height: 32),
                Text(
                  "Log into",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  "your account",
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 32),
                _buildTextField("Email address"),
                _buildTextField("Password", isPassword: true),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, AppRouter.forgotPassword);
                  },
                  child: Container(
                      alignment: Alignment.centerRight,
                      child: Text("Forgot Password?")),
                ),
                const SizedBox(height: 24),
                ElevatedButton(
                  onPressed: () {
                    _handleSubmit();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF2B1B17),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(40),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 18),
                  ),
                  child: Text(
                    "LOG IN",
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    "or log in with",
                    style: TextStyle(fontSize: 14),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSocialIcon('assets/icons/apple.svg'),
                    const SizedBox(width: 24),
                    _buildSocialIcon('assets/icons/google.svg'),
                    const SizedBox(width: 24),
                    _buildSocialIcon('assets/icons/facebook.svg'),
                  ],
                ),
                const SizedBox(height: 24),
                Center(
                  child: TextButton(
                    onPressed: () {
                      // Navigate to login
                    },
                    child: RichText(
                      text: TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                            text: "Create Account",
                            style: TextStyle(
                              color: Colors.black,
                              decoration: TextDecoration.underline,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildTextField(String hint, {bool isPassword = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 12),
      child: TextField(
        obscureText: isPassword,
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: TextStyle(),
          border: const UnderlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildSocialIcon(String assetPath) {
    return GestureDetector(
      onTap: () {
        Navigator.of(context).pushReplacementNamed(
          AppRouter.home,
        );
      },
      child: CircleAvatar(
        backgroundColor: Colors.white,
        radius: 24,
        child: SvgPicture.asset(
          assetPath,
          height: 24,
          width: 24,
        ),
      ),
    );
  }
}
