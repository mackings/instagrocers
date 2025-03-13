import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagrocers/Gen/productcard.dart';
import 'package:instagrocers/Home/Models/product.dart';
import 'package:instagrocers/Home/Views/pdetails.dart';
import 'package:instagrocers/Search/Views/search.dart';

class StoreSection extends StatelessWidget {
  final String title;
  final String storeName;
  final String storeLogo;
  final List<Product> products;

  const StoreSection({
    Key? key,
    required this.title,
    required this.storeName,
    required this.storeLogo,
    required this.products,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Stack(
      clipBehavior: Clip.none, // Allow search bar to overflow
      children: [
        // Background content
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Store Header Section (Green Background)
            Container(
              padding: const EdgeInsets.only(
                  top: 40, left: 16, right: 16, bottom: 30),
              decoration: const BoxDecoration(
                color: Colors.green,
              ),
              child: Column(
                children: [
                  // Close Icon (Top Left)
                  Align(
                    alignment: Alignment.topLeft,
                    child: IconButton(
                      icon: const Icon(Icons.close, color: Colors.white),
                      onPressed: () {
                        Navigator.pop(context);
                      },
                    ),
                  ),

                  // Store Logo (Dynamically Displayed)
                  CircleAvatar(
                    backgroundColor: Colors.white,
                    radius: 30,
                    backgroundImage: NetworkImage(storeLogo),
                  ),

                  const SizedBox(height: 10),

                  // Store Name
                  Text(
                    storeName,
                    style: GoogleFonts.poppins(
                      fontSize: 16,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '£0.99 Delivery fee | 20 min',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                  Text(
                    'Over 20,000 products available',
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.white70,
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 60),

            // Promo Banner
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.green.shade100,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'Get Same Day Delivery',
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          Text(
                            'On orders above £20',
                            style: GoogleFonts.poppins(
                              fontSize: 12,
                              color: Colors.grey.shade700,
                            ),
                          ),
                          const SizedBox(height: 8),
                          ElevatedButton(
                            onPressed: () {},
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8),
                              ),
                            ),
                            child: const Text('Shop Now'),
                          ),
                        ],
                      ),
                    ),
                    // Dynamically use the first product image
                    ClipRRect(
                      borderRadius: BorderRadius.circular(
                          8), // Optional: Adds rounded corners
                      child: products.isNotEmpty
                          ? Image.network(
                              products
                                  .first.imageUrl, // Use first product's image
                              width: 80,
                              height: 80,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) =>
                                  Image.asset('assets/shoppingbag.png',
                                      width: 80), // Fallback image
                            )
                          : Image.asset('assets/shoppingbag.png',
                              width: 80), // Show placeholder if no products
                    ),
                  ],
                ),
              ),
            ),

            const SizedBox(height: 16),

            // Special Offers Section
            _buildSection("Special Offers", products.take(5).toList()),

            // Best Sellers Section
            _buildSection("Best Sellers", products.skip(5).take(5).toList()),
          ],
        ),

        // Floating Search Bar 
        Positioned(
          top: 230,
          left: 16,
          right: 16,
          child: Container(
            height: 50,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(30),
              boxShadow: [
                BoxShadow(
                  color: Colors.black12,
                  blurRadius: 5,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(
                    18), // Matches the TextField's border radius
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey
                        .withOpacity(0.3), // Shadow color with opacity
                    spreadRadius: 2, // How far the shadow spreads
                    blurRadius: 5, // How blurry the shadow is
                    offset: const Offset(0, 3), // Shadow position (x, y)
                  ),
                ],
              ),
              child: GestureDetector(
  onTap: () {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Search()),
    );
  },
  child: Container(
    padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10),
    decoration: BoxDecoration(
      color: Colors.white,
      borderRadius: BorderRadius.circular(18),
      boxShadow: [
        BoxShadow(
          color: Colors.grey.withOpacity(0.3),
          spreadRadius: 2,
          blurRadius: 5,
          offset: const Offset(0, 3),
        ),
      ],
    ),
    child: Row(
      children: [
        const Icon(Icons.search, color: Colors.grey),
        const SizedBox(width: 10),
        Text(
          "Search products and stores",
          style: TextStyle(color: Colors.grey[600], fontSize: 16),
        ),
      ],
    ),
  ),
),

            ),
          ),
        ),
      ],
    );
  }

  // Section for Displaying Products in a Horizontal List
  Widget _buildSection(String sectionTitle, List<Product> items) {
    if (items.isEmpty) return const SizedBox();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            sectionTitle,
            style: GoogleFonts.poppins(
              fontSize: 16,
              fontWeight: FontWeight.w600,
              color: Colors.black,
            ),
          ),
        ),
        SizedBox(
          height: 230, // Adjusted height for product cards
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Padding(
                padding: const EdgeInsets.all(8.0),
                child: ProductCard(
                  imageUrl: item.imageUrl,
                  avatarUrl: item.storeLogo,
                  title: item.name,
                  rating: item.averageRating,
                  reviews: 287,
                  price: item.price,
                  onAddToCart: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ProductDetailsPage(product: item),
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
