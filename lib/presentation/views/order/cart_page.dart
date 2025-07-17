import 'package:flutter/material.dart';
import 'package:foriyana_app/core/router/app_router.dart';
import 'package:foriyana_app/presentation/widgets/button_back.dart';
import 'package:foriyana_app/presentation/widgets/cart_item.dart';

class CartPage extends StatelessWidget {
  const CartPage({super.key});

  @override
  Widget build(BuildContext context) {
    final cartItems = [
      CartItem(
        imageUrl: 'assets/images/startup1.webp',
        title: 'Sportwear Set',
        price: 80.00,
        size: 'L',
        color: 'Cream',
        isSelected: true,
      ),
      CartItem(
        imageUrl: 'assets/images/startup1.webp',
        title: 'Turtleneck Sweater',
        price: 39.99,
        size: 'M',
        color: 'White',
        isSelected: false,
      ),
      CartItem(
        imageUrl: 'assets/images/startup1.webp',
        title: 'Cotton T-shirt',
        price: 30.00,
        size: 'L',
        color: 'Black',
        isSelected: true,
      ),
    ];

    return Scaffold(
      appBar: AppBar(
        title: const Text("Your Cart",
            style: TextStyle(fontWeight: FontWeight.bold)),
        centerTitle: true,
        leading: ButtonBack(),
        leadingWidth: 40,
        elevation: 0,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ...cartItems,
            const SizedBox(height: 20),
            _buildSummary(),
            const SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12))),
                onPressed: () {
                  Navigator.pushNamed(
                    context,
                    AppRouter.orderCheckout,
                  );
                },
                child: const Text("Proceed to checkout",
                    style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                        fontWeight: FontWeight.bold)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildSummary() {
    return Column(
      children: [
        const Divider(
          height: 16,
          thickness: 0.5,
          color: Color(0xFFE0E0E0),
        ),
        _SummaryRow(label: "Product price", value: "\$110"),
        const Divider(
          height: 16,
          thickness: 0.5,
          color: Color(0xFFE0E0E0),
        ),
        _SummaryRow(label: "Shipping", value: "Freeship"),
        const Divider(
          height: 16,
          thickness: 0.5,
          color: Color(0xFFE0E0E0),
        ),
        _SummaryRow(label: "Subtotal", value: "\$110", bold: true),
      ],
    );
  }
}

class _SummaryRow extends StatelessWidget {
  final String label;
  final String value;
  final bool bold;

  const _SummaryRow({
    super.key,
    required this.label,
    required this.value,
    this.bold = false,
  });

  @override
  Widget build(BuildContext context) {
    final style = TextStyle(
      fontWeight: bold ? FontWeight.bold : FontWeight.normal,
      fontSize: bold ? 16 : 14,
    );

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: style),
          Text(value, style: style),
        ],
      ),
    );
  }
}
