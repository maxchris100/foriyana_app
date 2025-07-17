import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:foriyana_app/presentation/widgets/button_back.dart';

class DeliveryAddressPage extends StatelessWidget {
  final int selectedIndex = 0; // buat pakai Cubit/State

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: ButtonBack(),
        leadingWidth: 40,
        centerTitle: true,
        title: const Text(
          "Delivery address",
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          const SizedBox(height: 16),
          _AddressCard(
            isSelected: true,
            icon: "assets/icons/address_office.svg",
            title: "My Office",
            address: "SBI Building, street 3, Software Park",
            onEdit: () {},
          ),
          _AddressCard(
            isSelected: false,
            icon: "assets/icons/address_home.svg",
            title: "My Home",
            address: "SBI Building, street 3, Software Park",
            onEdit: () {},
          ),
          const Spacer(),
          Padding(
            padding: const EdgeInsets.all(16),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(24),
                ),
                minimumSize: const Size.fromHeight(48),
              ),
              onPressed: () {},
              child: const Text(
                "Add new address",
                style: TextStyle(color: Colors.white),
              ),
            ),
          )
        ],
      ),
    );
  }
}

class _AddressCard extends StatelessWidget {
  final bool isSelected;
  final String icon;
  final String title;
  final String address;
  final VoidCallback onEdit;

  const _AddressCard({
    required this.isSelected,
    required this.icon,
    required this.title,
    required this.address,
    required this.onEdit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            blurRadius: 6,
            offset: const Offset(0, 2),
          ),
        ],
        border: Border.all(
          color: isSelected ? Colors.black : Colors.transparent,
          width: 1.2,
        ),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
            color: Colors.black,
          ),
          const SizedBox(width: 12),
          SvgPicture.asset(icon, height: 36),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("SEND TO",
                    style: TextStyle(fontSize: 10, color: Colors.grey)),
                Text(title,
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold)),
                const SizedBox(height: 4),
                Text(address, style: const TextStyle(color: Colors.grey)),
              ],
            ),
          ),
          TextButton(
            onPressed: onEdit,
            child: const Text(
              "Edit",
              style: TextStyle(color: Colors.red),
            ),
          )
        ],
      ),
    );
  }
}
