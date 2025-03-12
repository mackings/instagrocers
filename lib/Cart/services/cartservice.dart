import 'package:instagrocers/Cart/Model/cartmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


class CartService {
  static const String _cartKey = 'shopping_cart';

  // Save cart to SharedPreferences
  static Future<void> saveCart(List<CartItem> cart) async {
    final prefs = await SharedPreferences.getInstance();
    final String cartString = CartItem.encode(cart);
    await prefs.setString(_cartKey, cartString);
  }

  // Load cart from SharedPreferences
  static Future<List<CartItem>> loadCart() async {
    final prefs = await SharedPreferences.getInstance();
    final String? cartString = prefs.getString(_cartKey);

    if (cartString == null) return [];
    return CartItem.decode(cartString);
  }

  // Add product to cart
  static Future<void> addToCart(CartItem product) async {
    List<CartItem> cart = await loadCart();

    // Check if product is already in the cart
    int index = cart.indexWhere((item) => item.id == product.id);

    if (index != -1) {
      cart[index].quantity += 1; // Increase quantity
    } else {
      cart.add(product);
    }

    await saveCart(cart);
  }

  // Remove product from cart
  static Future<void> removeFromCart(String productId) async {
    List<CartItem> cart = await loadCart();
    cart.removeWhere((item) => item.id == productId);
    await saveCart(cart);
  }

  // Update quantity
  static Future<void> updateQuantity(String productId, int quantity) async {
    List<CartItem> cart = await loadCart();
    int index = cart.indexWhere((item) => item.id == productId);

    if (index != -1) {
      cart[index].quantity = quantity;
      await saveCart(cart);
    }
  }

  // Get cart total
static Future<double> getCartTotal() async {
  List<CartItem> cart = await loadCart();
  
  // Explicitly define sum as a double (0.0)
  return cart.fold<double>(0.0, (sum, item) => sum + (item.price * item.quantity));
}

}
