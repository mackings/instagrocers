import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class StoreCard extends StatelessWidget {
  final String storeName;
  final String logoUrl;
  final String deliveryFee;
  final String deliveryTime;
  final String productCount;
  final int index; // Store index to determine color

  const StoreCard({
    required this.storeName,
    required this.logoUrl,
    required this.deliveryFee,
    required this.deliveryTime,
    required this.productCount,
    required this.index,
    Key? key,
  }) : super(key: key);

  // List of different background colors
  static const List<Color> storeColors = [
    Colors.green,
    Colors.blue,
    Colors.orange,
    Colors.purple,
    Colors.red,
    Colors.teal,
    Colors.indigo,
  ];

  @override
  Widget build(BuildContext context) {
    // Select color based on store index (cycling through colors)
    Color backgroundColor = storeColors[index % storeColors.length];

    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 16),
      decoration: BoxDecoration(
        color: backgroundColor,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          // Store Logo
          CircleAvatar(
            radius: 30,
            backgroundImage: NetworkImage(logoUrl),
            backgroundColor: Colors.white,
          ),
          const SizedBox(width: 12),

          // Store Info
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  storeName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "$deliveryFee Delivery fee | $deliveryTime",
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  "Over $productCount products available",
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 14,
                  ),
                ),
              ],
            ),
          ),

          // Heart Icon
          const Icon(Icons.favorite_border, color: Colors.white),
        ],
      ),
    );
  }
}
