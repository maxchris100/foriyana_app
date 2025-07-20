import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:foriyana_app/core/router/app_router.dart';
import 'package:foriyana_app/core/util/firebase.dart';
import 'package:foriyana_app/data/data_sources/user_local_data_source.dart';
import 'package:foriyana_app/presentation/blocs/cubit/auth_cubit.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isDev = false;
  bool _isLoading = false;
  bool obscureText = true;

  String callbackUrl = 'myapp://customer-portal.app'; // Callback URL default
  late String selectedLocal;
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passFocus = FocusNode();
  bool isAppleAvailable = false;
  @override
  void initState() {
    selectedLocal = UserLocalDataSource.language;
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      isAppleAvailable = await SignInWithApple.isAvailable();
      if (dotenv.env["ENV"] != "production") {
        isDev = true;
        _emailController.text = "johndoe@example.com";
        _passController.text = "securePassword123";
        //   _emailController.text = "123@yopmail.com";
        //   _passController.text = "123123123";
      }
      setState(() {});
    });
  }

  void _handleSubmit() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });
      await AuthCubit().login(context,
          _emailController.text.trim().toLowerCase(), _passController.text);

      setState(() {
        _isLoading = false;
      });
    }
  }

  Future googleLogin() async {
    var res = await CFirebase.signInGoogle();
    if (res?.accessToken != null) {
      await AuthCubit().login(
          context, _emailController.text.trim().toLowerCase(), "",
          loginType: "google", accessToken: res?.accessToken ?? "");
    }
  }

  Future appleLogin() async {
    var res = await CFirebase.signInApple();
    if (res?.accessToken != null) {
      await AuthCubit().login(
        context,
        _emailController.text.trim().toLowerCase(),
        "",
        loginType: "apple",
        accessToken: res?.accessToken ?? "",
      );
    }
  }

  Future fbLogin() async {}

  @override
  void dispose() {
    _emailFocus.dispose();
    _passFocus.dispose();
    _emailController.dispose();
    _passController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: isDev
      //       ? GestureDetector(
      //           onTap: () {
      //             Navigator.of(context).pushReplacementNamed('/home');
      //           },
      //           child: Icon(Icons.home))
      //       : Text(""),
      //   actions: [
      //     isDev
      //         ? GestureDetector(
      //             onTap: () {
      //               Navigator.of(context).pushNamed('/otp');
      //             },
      //             child: Text("OTP"))
      //         : Text(""),
      //     SizedBox(
      //       width: 10,
      //     ),
      //   ],
      // ),
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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: TextFormField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      hintText: "Email Address",
                      hintStyle: TextStyle(),
                      border: const UnderlineInputBorder(),
                    ),
                    keyboardType: TextInputType.emailAddress,
                    onChanged: (value) {
                      _formKey.currentState!.validate();
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Email is required';
                      }
                      final emailRegex =
                          RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
                      if (!emailRegex.hasMatch(value)) {
                        return 'Email Format is not valid';
                      }
                      return null;
                    },
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: TextFormField(
                    controller: _passController,
                    obscureText: obscureText,
                    decoration: InputDecoration(
                      hintText: "Password",
                      hintStyle: TextStyle(),
                      border: const UnderlineInputBorder(),
                    ),
                    onChanged: (value) {
                      _formKey.currentState!.validate();
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Password is required';
                      }
                      if (value.length < 6) {
                        return 'Password length minimum 6 characters';
                      }
                      return null;
                    },
                  ),
                ),
                GestureDetector(
                  onTap: () {
                    Navigator.pushNamed(context, AppRouter.forgotPassword);
                  },
                  child: Container(
                      alignment: Alignment.centerRight,
                      child: Text("Forgot Password?")),
                ),
                const SizedBox(height: 24),
                Center(
                  child: SizedBox(
                    width: 150,
                    child: ElevatedButton(
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
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    "or log in with",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Visibility(
                      visible: isAppleAvailable,
                      child:
                          _buildSocialIcon('assets/icons/apple.svg', onTap: () {
                        appleLogin();
                      }),
                    ),
                    const SizedBox(width: 24),
                    _buildSocialIcon('assets/icons/google.svg', onTap: () {
                      googleLogin();
                    }),
                    const SizedBox(width: 24),
                    _buildSocialIcon('assets/icons/facebook.svg', onTap: () {
                      fbLogin();
                    }),
                  ],
                ),
                const SizedBox(height: 24),
                Center(
                  child: TextButton(
                    onPressed: () {
                      Navigator.pushReplacementNamed(context, AppRouter.signUp);
                    },
                    child: RichText(
                      text: TextSpan(
                        text: "Don't have an account? ",
                        style: TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                            text: "Sign Up",
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

  Widget _buildSocialIcon(String assetPath, {VoidCallback? onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 48,
        height: 48,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          border: Border.all(
            color: Colors.grey.shade300, // Border gray
            width: 1.5,
          ),
        ),
        child: Center(
          child: SvgPicture.asset(
            assetPath,
            height: 24,
            width: 24,
          ),
        ),
      ),
    );
  }
}
