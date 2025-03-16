import 'package:flutter/material.dart';
import 'package:instagrocers/Cart/Model/cartmodel.dart';
import 'package:instagrocers/Cart/Widgets/cartcard.dart';
import 'package:instagrocers/Cart/services/cartservice.dart';
import 'package:instagrocers/Checkout/View/checkout.dart';
import 'package:instagrocers/Gen/custombtn.dart';
import 'package:instagrocers/Gen/customtext.dart';

class CartPage extends StatefulWidget {
  @override
  _CartPageState createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List<CartItem> cart = [];
  double total = 0;

  @override
  void initState() {
    super.initState();
    _loadCart();
  }

  Future<void> _loadCart() async {
    List<CartItem> loadedCart = await CartService.loadCart();
    double cartTotal = await CartService.getCartTotal();

    setState(() {
      cart = loadedCart;
      total = cartTotal;
    });
  }

  Future<void> _removeItem(String id) async {
    await CartService.removeFromCart(id);
    _loadCart();
  }

  Future<void> _updateQuantity(String id, int quantity) async {
    await CartService.updateQuantity(id, quantity);
    _loadCart();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: CustomText(text: "Cart")),
      body: cart.isEmpty
          ? const Center(child: Text("Your cart is empty"))
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 15,right: 15),
                child: Column(
                  children: [
                    // Cart Items (Inside a ListView with shrinkWrap)
                    ListView.builder(
                      shrinkWrap: true, // Prevents infinite height error
                      physics:
                          const NeverScrollableScrollPhysics(), // Disables inner scrolling
                      itemCount: cart.length,
                      itemBuilder: (context, index) {
                        final item = cart[index];
                
                        return CartItemCard(
                          item: item,
                          onRemove: () => _removeItem(item.id),
                          onIncrease: () =>
                              _updateQuantity(item.id, item.quantity + 1),
                          onDecrease: () {
                            if (item.quantity > 1) {
                              _updateQuantity(item.id, item.quantity - 1);
                            } else {
                              _removeItem(item.id);
                            }
                          },
                        );
                      },
                    ),
                
                    const SizedBox(height: 10),
                
                    // Checkout Section
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          border: Border.all(color: Colors.grey.shade300),
                        ),
                        child: Column(
                          children: [
                            _buildListTile("Add Note", Icons.edit),
                            const Divider(),
                            _buildListTile("Send as Gift", Icons.card_giftcard),
                            const Divider(),
                            _buildPriceRow(
                                "Delivery", "£6.00", Icons.local_shipping,
                                isBold: false),
                            const Divider(),
                            _buildPriceRow(
                                "Total",
                                "£${(total + 6.00).toStringAsFixed(2)}",
                                Icons.receipt_long,
                                isBold: false),
                          ],
                        ),
                      ),
                    ),
                
                    const SizedBox(height: 16),
                
                    // Checkout Button
                
                    Padding(
                      padding: EdgeInsets.all(8.0),
                      child: CustomButton(
                        color: Colors.orange,
                        text: "Go to Checkout",
                        onPressed: () {
                Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => CheckoutPage(cart: cart, total: total),
                        ),
                      );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
    );
  }

  Widget _buildListTile(String title, IconData icon) {
    return ListTile(
      leading: Icon(icon, color: Colors.black54),
      title: Text(title, style: const TextStyle(fontSize: 16)),
      trailing:
          const Icon(Icons.arrow_forward_ios, size: 16, color: Colors.grey),
      onTap: () {},
    );
  }

  // Helper widget for price rows (Delivery & Total)
  Widget _buildPriceRow(String label, String amount, IconData icon,
      {bool isBold = false}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon, color: Colors.black54, size: 20), // Icon added here
              const SizedBox(width: 8), // Spacing between icon and text
              Text(label,
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight:
                          isBold ? FontWeight.bold : FontWeight.normal)),
            ],
          ),
          Text(amount,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: isBold ? FontWeight.bold : FontWeight.normal)),
        ],
      ),
    );
  }
}
