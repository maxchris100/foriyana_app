import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ButtonBack extends StatelessWidget {
  const ButtonBack({super.key});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 24,
      height: 24,
      child: Center(
        child: GestureDetector(
          onTap: () => Navigator.pop(context),
          child: SvgPicture.asset(
            "assets/icons/back.svg",
            width: 10, // Bisa kamu atur sesuai kebutuhan
          ),
        ),
      ),
    );
  }
}
