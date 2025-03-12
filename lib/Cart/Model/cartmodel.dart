import 'dart:convert';

class CartItem {
  final String id;
  final String name;
  final String imageUrl;
  final double price;
  int quantity;

  CartItem({
    required this.id,
    required this.name,
    required this.imageUrl,
    required this.price,
    required this.quantity,
  });

  // Convert CartItem to Map (for SharedPreferences)
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'imageUrl': imageUrl,
      'price': price,
      'quantity': quantity,
    };
  }

  // Convert Map to CartItem
  factory CartItem.fromMap(Map<String, dynamic> map) {
    return CartItem(
      id: map['id'],
      name: map['name'],
      imageUrl: map['imageUrl'],
      price: map['price'],
      quantity: map['quantity'],
    );
  }

  static String encode(List<CartItem> items) => json.encode(
        items.map((item) => item.toMap()).toList(),
      );

  static List<CartItem> decode(String cartData) => (json.decode(cartData) as List<dynamic>)
      .map<CartItem>((item) => CartItem.fromMap(item))
      .toList();
}
