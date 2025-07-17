import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';

class ButtonBack extends StatelessWidget {
  final VoidCallback? onTap;
  const ButtonBack({super.key, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(left: 12),
      child: Container(
        width: 40,
        height: 40,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 5,
              offset: Offset(0, 2),
            ),
          ],
        ),
        child: Center(
          child: GestureDetector(
            onTap: onTap ?? () => Navigator.pop(context),
            child: SvgPicture.asset(
              "assets/icons/back.svg",
              width: 10, // Bisa kamu atur sesuai kebutuhan
            ),
          ),
        ),
      ),
    );
  }
}
