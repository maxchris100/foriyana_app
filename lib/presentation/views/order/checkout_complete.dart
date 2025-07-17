import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foriyana_app/core/router/app_router.dart';
import 'package:foriyana_app/presentation/views/order/checkout_step.dart';
import 'package:foriyana_app/presentation/widgets/button_back.dart';

class CheckoutCompletePage extends StatelessWidget {
  const CheckoutCompletePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Check out", style: TextStyle(color: Colors.black)),
        centerTitle: true,
        backgroundColor: Colors.white,
        elevation: 0,
        leading: ButtonBack(onTap: () {
          Navigator.popUntil(context, ModalRoute.withName(AppRouter.home));
        }),
        leadingWidth: 40,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 30, vertical: 40),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CheckoutStep(),
            SizedBox(
              height: 8,
            ),
            const Text(
              "Order Completed",
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.start,
            ),
            const SizedBox(height: 40),
            SvgPicture.asset(
              "assets/icons/order_complete.svg",
              height: 100,
            ),
            const SizedBox(height: 40),
            const Text(
              "Thank you for your purchase.\nYou can view your order in 'My Orders' section.",
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.black, fontSize: 16),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.popUntil(
                      context, ModalRoute.withName(AppRouter.home));
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30),
                  ),
                ),
                child: const Text(
                  "Continue shopping",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
