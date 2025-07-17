import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CheckoutStep extends StatelessWidget {
  final int currentStep; // 0 = location, 1 = payment, 2 = complete

  const CheckoutStep({super.key, this.currentStep = 0});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          width: 8,
        ),
        _buildStepIcon("assets/icons/map.svg", 26, isActive: currentStep >= 0),
        _buildDashedLine(),
        _buildStepIcon("assets/icons/credit_card.svg", 20,
            isActive: currentStep >= 1),
        _buildDashedLine(),
        _buildStepIcon("assets/icons/checklist.svg", 26,
            isActive: currentStep >= 2),
        SizedBox(
          width: 8,
        ),
      ],
    );
  }

  Widget _buildStepIcon(String assetPath, double size,
      {required bool isActive}) {
    return Container(
      padding: const EdgeInsets.all(8),
      decoration: BoxDecoration(
          // color: isActive ? Colors.black : Colors.grey.shade300,
          // shape: BoxShape.circle,
          ),
      child: SvgPicture.asset(
        assetPath,
        height: size,
        width: size,
        colorFilter: ColorFilter.mode(
          isActive ? Colors.black : Colors.grey,
          BlendMode.srcIn,
        ),
      ),
    );
  }

  Widget _buildDashedLine() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Expanded(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: List.generate(
                5,
                (_) => Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: const SizedBox(
                    width: 4,
                    height: 4,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                          shape: BoxShape.circle, color: Colors.grey),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
