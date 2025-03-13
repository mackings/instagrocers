import 'package:flutter/material.dart';
import 'package:instagrocers/Cart/Model/cartmodel.dart';
import 'package:instagrocers/Checkout/widgets/details.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';



class CheckoutPage extends StatelessWidget {
  final List<CartItem> cart;
  final double total;

  CheckoutPage({required this.cart, required this.total});


  // Future<void> _makePayment(BuildContext context) async {
  //   try {
  //     // Fetch payment intent from backend
  //     final paymentIntent = await _createPaymentIntent();
  //     if (paymentIntent == null) return;

  //     // Initialize Stripe Payment Sheet
  //     await Stripe.instance.initPaymentSheet(
  //       paymentSheetParameters: SetupPaymentSheetParameters(
  //         paymentIntentClientSecret: paymentIntent['client_secret'],
  //         merchantDisplayName: 'Instagrocers',
  //       ),
  //     );

  //     // Show Payment Sheet
  //     await Stripe.instance.presentPaymentSheet();

  //     // Payment Success Message
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       const SnackBar(content: Text('Payment Successful!')),
  //     );
  //   } catch (e) {
  //     print('Payment Error: $e');

  //     // Payment Failure Message
  //     ScaffoldMessenger.of(context).showSnackBar(
  //       SnackBar(content: Text('Payment Failed: $e')),
  //     );
  //   }
  // }

  /// 🔹 **Fetch Payment Intent from API**



  Future<Map<String, dynamic>?> _createPaymentIntent() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString("accessToken"); // Get token

      if (token == null) {
        print('Error: Missing auth token');
        return null;
      }

      final response = await http.post(
        Uri.parse('https://instagrocers-backend.onrender.com/create-payment-intent'),
        headers: {
          'Authorization': 'Bearer $token', // Attach Bearer Token
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'amount': ((total + 6.00) * 100).toInt(), // Convert to cents
          'currency': 'usd',
          'paymentMethod': 'Credit Card', // Optional
        }),
      );

      if (response.statusCode == 200) {
        return jsonDecode(response.body);
      } else {
        print('Error: ${response.body}');
        return null;
      }
    } catch (e) {
      print('API Error: $e');
      return null;
    }
  }

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
                 onPressed: () {},
               // onPressed: () => _makePayment(context), // Call Stripe Payment
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

  // 🛒 Display each cart item
  Widget _buildCartItem(CartItem item) {
    return ListTile(
      leading: Image.network(item.imageUrl, width: 40, height: 40),
      title: Text(item.name),
      subtitle: Text("Qty: ${item.quantity}"),
      trailing: Text("£${(item.price * item.quantity).toStringAsFixed(2)}"),
    );
  }

  // 💲 Display Price Row
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

