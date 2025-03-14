import 'package:flutter/material.dart';
import 'package:instagrocers/Cart/Model/cartmodel.dart';
import 'package:instagrocers/Checkout/Api/checkoutservice.dart';
import 'package:instagrocers/Checkout/View/webview.dart';
import 'package:instagrocers/Checkout/widgets/details.dart';
import 'package:http/http.dart' as http;




class CheckoutPage extends StatefulWidget {
  final List<CartItem> cart;
  final double total;

  CheckoutPage({required this.cart, required this.total});

  @override
  State<CheckoutPage> createState() => _CheckoutPageState();
}

class _CheckoutPageState extends State<CheckoutPage> {
  Map<String, String> userDetails = {};
  final CheckoutService _checkoutService = CheckoutService();

  void _updateUserDetails(Map<String, String> details) {
    setState(() {
      userDetails = details;
    });
  }

  Future<void> _makePayment(BuildContext context) async {
    try {
      List<Map<String, dynamic>> cartItems = widget.cart.map((item) {
        return {
          "productId": item.id,
          "quantity": item.quantity,
        };
      }).toList();

      String checkoutUrl = await _checkoutService.createCheckoutSession(
        cartItems: cartItems,
        userDetails: userDetails,
      );

      _openWebView(context, checkoutUrl);
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Payment failed: $e")),
      );
    }
  }

  void _openWebView(BuildContext context, String url) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => InAppWebViewScreen(url: url),
      ),
    );
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
            UserDetailsWidget(onDetailsUpdated: _updateUserDetails),
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
                  ...widget.cart.map((item) => _buildCartItem(item)),
                  const Divider(),
                  _buildPriceRow(Icons.local_shipping, "Delivery", "£6.00"),
                  const Divider(),
                  _buildPriceRow(
                    Icons.shopping_bag,
                    "Total",
                    "£${(widget.total + 6.00).toStringAsFixed(2)}",
                    isBold: true,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () => _makePayment(context),
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

  Widget _buildCartItem(CartItem item) {
    return ListTile(
      leading: Image.network(item.imageUrl, width: 40, height: 40),
      title: Text(item.name),
      subtitle: Text("Qty: ${item.quantity}"),
      trailing: Text("£${(item.price * item.quantity).toStringAsFixed(2)}"),
    );
  }

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
