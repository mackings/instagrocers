class Order {
  final String id;
  final String fullName;
  final String fullAddress;
  final String phoneNumber;
  final List<OrderProduct> products;
  final double totalAmount;
  final String orderStatus;
  final DateTime estimatedDeliveryTime;

  Order({
    required this.id,
    required this.fullName,
    required this.fullAddress,
    required this.phoneNumber,
    required this.products,
    required this.totalAmount,
    required this.orderStatus,
    required this.estimatedDeliveryTime,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    return Order(
      id: json['_id'],
      fullName: json['address']['fullName'],
      fullAddress: json['address']['fullAddress'],
      phoneNumber: json['address']['phoneNumber'],
      products: (json['products'] as List)
          .map((item) => OrderProduct.fromJson(item))
          .toList(),
      totalAmount: json['grandTotal'].toDouble(),
      orderStatus: json['orderStatus'],
      estimatedDeliveryTime: DateTime.parse(json['estimatedDeliveryTime']),
    );
  }
}

class OrderProduct {
  final String id;
  final String name;
  final double price;
  final int quantity;

  OrderProduct({
    required this.id,
    required this.name,
    required this.price,
    required this.quantity,
  });

  factory OrderProduct.fromJson(Map<String, dynamic> json) {
    return OrderProduct(
      id: json['product']['_id'],
      name: json['product']['name'],
      price: json['priceAtOrder'].toDouble(),
      quantity: json['quantity'],
    );
  }
}
