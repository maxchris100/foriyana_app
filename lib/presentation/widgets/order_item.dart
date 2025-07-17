import 'package:flutter/material.dart';
import 'package:foriyana_app/core/router/app_router.dart';
import 'package:foriyana_app/core/util/string_util.dart';

class OrderItem extends StatelessWidget {
  final item;
  const OrderItem({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black12,
            blurRadius: 6,
            offset: Offset(0, 2),
          ),
        ],
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Order ID and Date
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Order 123',
                style:
                    const TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
              ),
              Text(
                '',
                style: const TextStyle(color: Colors.grey),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Tracking Number
          Text(
            'Tracking number: ',
            style: const TextStyle(color: Colors.grey),
          ),
          const SizedBox(height: 8),
          // Quantity and Subtotal
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text('Quantity: 1'),
              Text(
                'Subtotal: 1',
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // Delivered + Details
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                StringUtil.castToString(item["status"]).toUpperCase(),
                style: TextStyle(
                    color: item["status"] == "Delivered"
                        ? Colors.green
                        : Colors.red,
                    fontWeight: FontWeight.bold),
              ),
              OutlinedButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRouter.orderDetail,
                      arguments: {"item": item});
                },
                child: const Text(
                  'Details',
                  style: TextStyle(color: Colors.black),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
