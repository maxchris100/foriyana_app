import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foriyana_app/core/router/app_router.dart';
import 'package:foriyana_app/core/util/firebase.dart';
import 'package:foriyana_app/presentation/blocs/cubit/auth_cubit.dart';
import 'package:sign_in_with_apple/sign_in_with_apple.dart';

class SignUpPage extends StatefulWidget {
  const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {
  final _formKey = GlobalKey<FormState>();
  bool obscureText = true;

  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passController = TextEditingController();
  final TextEditingController _confirmpassController = TextEditingController();
  final FocusNode _nameFocus = FocusNode();
  final FocusNode _emailFocus = FocusNode();
  final FocusNode _passFocus = FocusNode();
  final FocusNode _confirmpassFocus = FocusNode();

  Future register() async {
    if (_formKey.currentState!.validate()) {
      await AuthCubit().register(context, _nameController.text.trim(),
          _emailController.text.trim().toLowerCase(), _passController.text,
          loginType: "manual", accessToken: "");
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

  bool isDev = false;
  bool isAppleAvailable = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      isAppleAvailable = await SignInWithApple.isAvailable();
      if (dotenv.env["ENV"] != "production") {
        isDev = true;
        _nameController.text = "John Doe";
        _emailController.text = "johndoe@example.com";
        _passController.text = "securePassword123";
        _confirmpassController.text = "securePassword123";
      }
      setState(() {});
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Form(
        key: _formKey,
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ListView(
              children: [
                const SizedBox(height: 32),
                Text(
                  "Create",
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
                    controller: _nameController,
                    decoration: InputDecoration(
                      hintText: "Enter your name",
                      hintStyle: TextStyle(),
                      border: const UnderlineInputBorder(),
                    ),
                    onChanged: (value) {
                      _formKey.currentState!.validate();
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Name is required';
                      }
                      return null;
                    },
                  ),
                ),
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
                Padding(
                  padding: const EdgeInsets.symmetric(vertical: 12),
                  child: TextFormField(
                    controller: _confirmpassController,
                    obscureText: obscureText,
                    decoration: InputDecoration(
                      hintText: "Confirm Password",
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
                      if (value != _confirmpassController.text) {
                        return 'Confirm password not match with password';
                      }
                      return null;
                    },
                  ),
                ),
                const SizedBox(height: 24),
                Center(
                  child: SizedBox(
                    width: 150,
                    child: ElevatedButton(
                      onPressed: () {
                        register();
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF2B1B17),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(40),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 18),
                      ),
                      child: Text(
                        "SIGN UP",
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
                    "or sign up with",
                    style: TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                ),
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    _buildSocialIcon('assets/icons/apple.svg', onTap: () {
                      appleLogin();
                    }),
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
                      Navigator.pushReplacementNamed(context, AppRouter.signIn);
                    },
                    child: RichText(
                      text: TextSpan(
                        text: "Already have account? ",
                        style: TextStyle(color: Colors.black),
                        children: [
                          TextSpan(
                            text: "Log In",
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
