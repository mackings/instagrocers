import 'package:flutter/material.dart';
import 'package:instagrocers/Cart/Model/cartmodel.dart';
import 'package:instagrocers/Checkout/widgets/details.dart';

class CheckoutPage extends StatelessWidget {
  final List<CartItem> cart;
  final double total;

  CheckoutPage({required this.cart, required this.total});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Checkout")),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            UserDetailsWidget(),
            const SizedBox(height: 16),

            // Order Summary
            const Text(
              "Order Summary",
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Column(
                children: [
                  ...cart.map((item) => _buildCartItem(item)), // Display Cart Items
                  const Divider(),
                  _buildPriceRow(Icons.local_shipping, "Delivery", "£6.00"),
                  const Divider(),
                  _buildPriceRow(
                    Icons.shopping_bag,
                    "Total",
                    "£${(total + 6.00).toStringAsFixed(2)}",
                    isBold: true,
                  ),
                ],
              ),
            ),

            const SizedBox(height: 24),

            // Checkout Button
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  // Implement checkout logic
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.orange,
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                child: const Text(
                  "Proceed to Payment",
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Widget to display each cart item
  Widget _buildCartItem(CartItem item) {
    return ListTile(
      leading: Image.network(item.imageUrl, width: 40, height: 40),
      title: Text(item.name),
      subtitle: Text("Qty: ${item.quantity}"),
      trailing: Text("£${(item.price * item.quantity).toStringAsFixed(2)}"),
    );
  }

  // Price Row with Icon
  Widget _buildPriceRow(IconData icon, String label, String amount, {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.black54),
              const SizedBox(width: 8),
              Text(label, style: TextStyle(fontSize: 16)),
            ],
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: 16,
              fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
            ),
          ),
        ],
      ),
    );
  }
}

