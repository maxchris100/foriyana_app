import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foriyana_app/core/router/app_router.dart';
import 'package:foriyana_app/presentation/widgets/button_back.dart';

class OrderDetailPage extends StatelessWidget {
  const OrderDetailPage({super.key});

  @override
  Widget build(BuildContext context) {
    Map? item;
    var args = ModalRoute.of(context)?.settings.arguments as Map?;

    try {
      item = args?["item"];
    } catch (e) {}
    final List<Map<String, dynamic>> items = [
      {'name': 'Maxi Dress', 'qty': 1, 'price': 68.00},
      {'name': 'Linen Dress', 'qty': 1, 'price': 52.00},
    ];

    final subtotal = items.fold(0.0, (total, item) => total + item['price']);
    const shipping = 0.0;
    final total = subtotal + shipping;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Order #1514'),
        centerTitle: true,
        leading: ButtonBack(),
        leadingWidth: 40,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Status card
            item?["status"] == "Pending"
                ? Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                  context, AppRouter.trackOrder);
                            },
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: const [
                                Text(
                                  "Your order is on the way",
                                  style: TextStyle(
                                    color: Colors.white,
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16,
                                    decoration: TextDecoration.underline,
                                    decorationColor: Colors.white,
                                  ),
                                ),
                                SizedBox(height: 4),
                                Text(
                                  "Click here to track order",
                                  style: TextStyle(color: Colors.white70),
                                ),
                              ],
                            ),
                          ),
                        ),
                        SvgPicture.asset("assets/icons/order_shipping.svg"),
                      ],
                    ),
                  )
                : Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: Colors.grey[800],
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                "Your order is delivered",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  decoration: TextDecoration.underline,
                                  decorationColor: Colors.white,
                                ),
                              ),
                              const SizedBox(height: 4),
                              const Text(
                                "Rate product to get 5 points for collect.",
                                style: TextStyle(color: Colors.white70),
                              ),
                            ],
                          ),
                        ),
                        SvgPicture.asset("assets/icons/order_delivered.svg"),
                      ],
                    ),
                  ),
            const SizedBox(height: 20),

            // Info Card
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: const Color.fromARGB(255, 253, 253, 253),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 1,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: const [
                  InfoRow(title: 'Order number', value: '#1514'),
                  SizedBox(height: 8),
                  InfoRow(title: 'Tracking Number', value: 'IK987362341'),
                  SizedBox(height: 8),
                  InfoRow(
                      title: 'Delivery address',
                      value: 'SBI Building, Software Park'),
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Items List
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: const Color.fromARGB(255, 253, 253, 253),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 1,
                    offset: Offset(0, 2),
                  ),
                ],
              ),
              child: Column(
                children: [
                  ...items.map((item) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              item['name'],
                              style: const TextStyle(fontSize: 16),
                            ),
                            Row(
                              children: [
                                Text("x${item['qty']}   ",
                                    style: const TextStyle(color: Colors.grey)),
                                Text(
                                  "\$${item['price'].toStringAsFixed(2)}",
                                  style: const TextStyle(
                                      fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )),

                  const Divider(),
                  const SizedBox(height: 8),

                  // Totals
                  _buildTotalRow("Sub Total", subtotal),
                  const SizedBox(height: 4),
                  _buildTotalRow("Shipping", shipping),
                  const Divider(height: 24),
                  _buildTotalRow("Total", total,
                      isBold: true, isCurrency: true),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Buttons
            item?["status"] == "Pending"
                ? Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24)),
                              backgroundColor: Colors.black87,
                            ),
                            child: const Text(
                              "Continue Shopping",
                              style: TextStyle(color: Colors.white),
                            )),
                      ),
                    ],
                  )
                : Row(
                    children: [
                      Expanded(
                        child: OutlinedButton(
                          onPressed: () {
                            Navigator.pop(context);
                          },
                          style: OutlinedButton.styleFrom(
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(24)),
                          ),
                          child: const Text(
                            "Return home",
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: ElevatedButton(
                            onPressed: () {
                              Navigator.pushNamed(
                                  context, AppRouter.rateProduct);
                            },
                            style: ElevatedButton.styleFrom(
                              shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(24)),
                              backgroundColor: Colors.black87,
                            ),
                            child: const Text(
                              "Rate",
                              style: TextStyle(color: Colors.white),
                            )),
                      ),
                    ],
                  )
          ],
        ),
      ),
    );
  }

  Widget _buildTotalRow(String label, double value,
      {bool isBold = false, bool isCurrency = false}) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(
          isCurrency
              ? '\$${value.toStringAsFixed(2)}'
              : value.toStringAsFixed(2),
          style: TextStyle(
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal),
        ),
      ],
    );
  }
}

class InfoRow extends StatelessWidget {
  final String title;
  final String value;

  const InfoRow({super.key, required this.title, required this.value});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
            child: Text(title, style: const TextStyle(color: Colors.grey))),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
      ],
    );
  }
}
