import 'package:flutter/material.dart';
import 'package:foriyana_app/core/router/app_router.dart';
import 'package:foriyana_app/presentation/views/order/checkout_step.dart';
import 'package:foriyana_app/presentation/widgets/button_back.dart';

class Checkout1Page extends StatefulWidget {
  const Checkout1Page({super.key});

  @override
  State<Checkout1Page> createState() => _Checkout1PageState();
}

class _Checkout1PageState extends State<Checkout1Page> {
  final _formKey = GlobalKey<FormState>();
  int _selectedShippingMethod = 0;
  bool _copyAddress = false;

  final _firstNameController = TextEditingController();
  final _lastNameController = TextEditingController();
  final _countryController = TextEditingController();
  final _streetController = TextEditingController();
  final _cityController = TextEditingController();
  final _stateController = TextEditingController();
  final _zipController = TextEditingController();
  final _phoneController = TextEditingController();
  final _couponController = TextEditingController();

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
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            CheckoutStep(),
            SizedBox(
              height: 8,
            ),
            const Text("STEP 1", style: TextStyle(color: Colors.grey)),
            const SizedBox(height: 4),
            const Text("Shipping",
                style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
            const SizedBox(height: 16),
            _buildTextField("First name *", _firstNameController, true),
            _buildTextField("Last name *", _lastNameController, true),
            _buildTextField("Country *", _countryController, true),
            _buildTextField("Street name *", _streetController, true),
            _buildTextField("City *", _cityController, true),
            _buildTextField("State / Province", _stateController, false),
            _buildTextField("Zip-code *", _zipController, true),
            _buildTextField("Phone number *", _phoneController, true),
            const SizedBox(height: 24),
            const Text("Shipping method",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 12),
            _buildShippingOption(
              0,
              "Free",
              "Delivery to home",
              "Delivery from 3 to 7 business days",
            ),
            _buildShippingOption(
              1,
              "\$9.90",
              "Delivery to home",
              "Delivery from 4 to 6 business days",
            ),
            _buildShippingOption(
              2,
              "\$9.90",
              "Fast Delivery",
              "Delivery from 2 to 3 business days",
            ),
            const SizedBox(height: 20),
            const Text("Coupon Code",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFFF7F7F8), // Soft grey
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: TextFormField(
                      controller: _couponController,
                      style: const TextStyle(color: Colors.black),
                      decoration: const InputDecoration(
                        hintText: "Have a code? type it here...",
                        hintStyle: TextStyle(color: Colors.grey),
                        border: InputBorder.none,
                      ),
                    ),
                  ),
                  GestureDetector(
                    onTap: () {},
                    child: const Text(
                      "Validate",
                      style: TextStyle(
                        color: Color(0xFF3C7563), // Greenish color
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            const Text("Billing Address",
                style: TextStyle(fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Row(
              children: [
                Checkbox(
                  value: _copyAddress,
                  onChanged: (value) {
                    setState(() {
                      _copyAddress = value ?? false;
                    });
                  },
                ),
                const Text("Copy address data from shipping"),
              ],
            ),
            const SizedBox(height: 24),
            SizedBox(
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, AppRouter.orderCheckout2);
                  return;
                  if (_formKey.currentState!.validate()) {
                    // lanjut ke payment page
                    Navigator.pushNamed(context, AppRouter.orderCheckout2);
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30)),
                ),
                child: const Text(
                  "Continue to payment",
                  style: TextStyle(color: Colors.white),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget _buildTextField(
      String label, TextEditingController controller, bool required) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextFormField(
        controller: controller,
        validator: (value) {
          if (required && (value == null || value.isEmpty)) {
            return 'Field is required';
          }
          return null;
        },
        decoration: InputDecoration(
          labelText: label,
          border: const UnderlineInputBorder(),
        ),
      ),
    );
  }

  Widget _buildShippingOption(
      int index, String price, String title, String subtitle) {
    return RadioListTile(
      value: index,
      selectedTileColor: Color(0xFF3C7563),
      groupValue: _selectedShippingMethod,
      onChanged: (value) {
        setState(() {
          _selectedShippingMethod = value!;
        });
      },
      title: Text("$price  $title"),
      subtitle: Text(
        subtitle,
        style: TextStyle(color: Colors.grey),
      ),
      activeColor: Colors.black,
      contentPadding: EdgeInsets.zero,
    );
  }
}
