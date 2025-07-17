import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foriyana_app/core/router/app_router.dart';
import 'package:foriyana_app/presentation/views/order/checkout_step.dart';
import 'package:foriyana_app/presentation/widgets/button_back.dart';

class Checkout2Page extends StatefulWidget {
  const Checkout2Page({super.key});

  @override
  State<Checkout2Page> createState() => _Checkout2PageState();
}

class _Checkout2PageState extends State<Checkout2Page> {
  int _selectedPaymentMethod = 1; // 0: Cash, 1: Credit Card, 2: Other
  bool _agreeTerms = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Check out", style: TextStyle(color: Colors.black)),
        backgroundColor: Colors.white,
        iconTheme: const IconThemeData(color: Colors.black),
        centerTitle: true,
        elevation: 0,
        leading: ButtonBack(),
        leadingWidth: 40,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          CheckoutStep(currentStep: 1),
          SizedBox(
            height: 8,
          ),
          const Text("STEP 2", style: TextStyle(color: Colors.grey)),
          const SizedBox(height: 4),
          const Text("Payment",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),

          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildPaymentTab(0, "assets/icons/money.svg", "Cash"),
              _buildPaymentTab(
                  1, "assets/icons/credit_card.svg", "Credit Card"),
              _buildPaymentTab(2, "assets/icons/more.svg", ""),
            ],
          ),

          const SizedBox(height: 20),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: const [
              Text("Choose your card",
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
              Text("Add new+",
                  style: TextStyle(
                      color: Colors.red,
                      fontSize: 13,
                      decoration: TextDecoration.underline,
                      decorationColor: Colors.red)),
            ],
          ),

          const SizedBox(height: 16),
          Image.asset("assets/images/visa.png",
              fit: BoxFit.fitHeight, height: 180), // Mockup kartu

          const SizedBox(height: 16),
          const Center(child: Text("or check out with")),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildPaymentLogo("assets/icons/method_paypal.svg"),
              _buildPaymentLogo("assets/icons/method_visa.svg"),
              _buildPaymentLogo("assets/icons/method_mastercard.svg"),
              _buildPaymentLogo("assets/icons/method_alipay.svg"),
              _buildPaymentLogo("assets/icons/method_amex.svg"),
            ],
          ),

          const SizedBox(height: 30),
          const Divider(),

          _buildPriceRow("Product price", "\$110"),
          _buildPriceRow("Shipping", "Freeship"),
          _buildPriceRow("Subtotal", "\$110", bold: true),

          const SizedBox(height: 20),
          Row(
            children: [
              Checkbox(
                activeColor: Color(0xff5ECE7B),
                value: _agreeTerms,
                onChanged: (value) {
                  setState(() {
                    _agreeTerms = value ?? false;
                  });
                },
              ),
              Expanded(
                child: Text.rich(
                  TextSpan(
                    children: [
                      const WidgetSpan(child: SizedBox(width: 5)),
                      TextSpan(
                        text: "I agree to Terms and conditions",
                        style: const TextStyle(
                          color: Colors.black,
                          decoration: TextDecoration.underline,
                        ),
                        recognizer: TapGestureRecognizer()
                          ..onTap = () {
                            setState(() {
                              _agreeTerms = !_agreeTerms;
                            });
                          },
                      )
                    ],
                  ),
                ),
              ),
            ],
          ),

          const SizedBox(height: 20),
          SizedBox(
            height: 50,
            child: ElevatedButton(
              onPressed: _agreeTerms
                  ? () {
                      // Lanjut ke halaman konfirmasi
                      Navigator.pushNamed(
                          context, AppRouter.orderCheckoutComplete);
                    }
                  : null,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(30)),
              ),
              child: const Text(
                "Place my order",
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildPaymentTab(int index, String icon, String label) {
    final isSelected = _selectedPaymentMethod == index;
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedPaymentMethod = index;
        });
      },
      child: Container(
        width: 100,
        height: 70,
        alignment: Alignment.center,
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? Colors.black87 : Colors.grey[200],
          borderRadius: BorderRadius.circular(10),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            SvgPicture.asset(icon),
            Visibility(
              visible: label.isNotEmpty,
              child: Column(
                children: [
                  const SizedBox(height: 4),
                  Text(label,
                      style: TextStyle(
                          color: isSelected ? Colors.white : Colors.black)),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPaymentLogo(String path) {
    return SvgPicture.asset(path,
        allowDrawingOutsideViewBox: true, width: 36, height: 30);
  }

  Widget _buildPriceRow(String label, String value, {bool bold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value,
              style:
                  bold ? const TextStyle(fontWeight: FontWeight.bold) : null),
        ],
      ),
    );
  }
}
