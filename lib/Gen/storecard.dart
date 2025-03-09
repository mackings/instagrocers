import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';


class StoreCard extends StatelessWidget {
  final String storeLogoUrl;
  final String storeName;
  final String deliveryFee;
  final String deliveryTime;
  final String productCount;
  final String productImageUrl; 
  final Color bgColor;
  final VoidCallback onTap;
  final VoidCallback onFavoriteTap;
  final bool isFavorite;

  const StoreCard({
    Key? key,
    required this.storeLogoUrl,
    required this.storeName,
    required this.deliveryFee,
    required this.deliveryTime,
    required this.productCount,
    required this.productImageUrl,
    required this.onTap,
    required this.onFavoriteTap,
    this.bgColor = Colors.orange,
    this.isFavorite = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Stack(
        children: [
          // Background Container
          Container(
            padding: const EdgeInsets.all(16),
            height: 100, // Adjust height as needed
            decoration: BoxDecoration(
              color: bgColor,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                // Store Logo (Left Side)
                CircleAvatar(
                  radius: 28,
                  backgroundImage: NetworkImage(storeLogoUrl),
                ),
                const SizedBox(width: 12),

                // Store Details (Middle)
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        storeName,
                        style: GoogleFonts.poppins(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        "$deliveryFee Delivery fee • $deliveryTime",
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        productCount,
                        style: GoogleFonts.poppins(
                          fontSize: 12,
                          color: Colors.white70,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Background Product Image (Positioned at the right)
          Positioned(
            right: -10,
            top: -5,
            bottom: -5,
            child: Image.network(
              productImageUrl,
              width: 120,
              height: 120,
              fit: BoxFit.contain, // Ensures it sits nicely
              
            ),
          ),

          // Favorite Icon (Top Right)
          Positioned(
            top: 8,
            right: 8,
            child: GestureDetector(
              onTap: onFavoriteTap,
              child: Icon(
                isFavorite ? Icons.favorite : Icons.favorite_border,
                color: Colors.white,
              ),
            ),
          ),

        ],
      ),
    );
  }
}
