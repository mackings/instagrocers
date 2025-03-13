import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagrocers/Gen/productcard.dart';
import 'package:instagrocers/Home/Models/product.dart';
import 'package:instagrocers/Home/Views/pdetails.dart';
import 'package:instagrocers/Search/Api/searchservice.dart';
import 'package:instagrocers/Stores/storehome.dart';

class Search extends StatefulWidget {
  const Search({super.key});

  @override
  State<Search> createState() => _SearchState();
}

class _SearchState extends State<Search> {
  final TextEditingController _searchController = TextEditingController();
  final SearchService _searchService = SearchService();
  Map<String, List<Product>> _storeGroupedResults = {};
  bool _isLoading = false;
  final ScrollController _scrollController =
      ScrollController(); // Added ScrollController

  void _performSearch(String query) async {
    if (query.isEmpty) {
      setState(() {
        _storeGroupedResults.clear();
      });
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      List<Product> results = await _searchService.searchProducts(query);

      // Group results by store
      Map<String, List<Product>> groupedResults = {};
      for (var product in results) {
        groupedResults
            .putIfAbsent(product.retailer.storeName, () => [])
            .add(product);
      }

      setState(() {
        _storeGroupedResults = groupedResults;
        // Reset scroll position after results load
        Future.delayed(Duration.zero, () {
          if (_scrollController.hasClients) {
            _scrollController.jumpTo(0);
          }
        });
      });
    } catch (e) {
      print("Search Error: $e");
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _scrollController.dispose(); // Clean up controller
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        // Move SingleChildScrollView to the body level
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              const SizedBox(height: 19),
              // Search Input Field
Container(
  decoration: BoxDecoration(
    color: Colors.white,
    borderRadius: BorderRadius.circular(18), // Matches the TextField's border radius
    boxShadow: [
      BoxShadow(
        color: Colors.grey.withOpacity(0.3), // Shadow color with opacity
        spreadRadius: 2, // How far the shadow spreads
        blurRadius: 5, // How blurry the shadow is
        offset: const Offset(0, 3), // Shadow position (x, y)
      ),
    ],
  ),
  child: TextField(
    controller: _searchController,
    decoration: InputDecoration(
      hintText: "Search products and stores",
      prefixIcon: const Icon(Icons.search, color: Colors.grey),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide.none, // Remove the default border to avoid overlap
      ),
      filled: true,
      fillColor: Colors.white, // Ensure the TextField background matches the container
      contentPadding: const EdgeInsets.symmetric(vertical: 15, horizontal: 10), // Optional: Adjust padding
    ),
    onChanged: _performSearch,
  ),
),
              const SizedBox(height: 16),
              // Results Section
              _isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : _storeGroupedResults.isEmpty
                      ? const Center(child: Text("No results found"))
                      : ListView.builder(
                          controller: _scrollController,
                          shrinkWrap:
                              true, // Makes ListView take only the space it needs
                          physics:
                              const NeverScrollableScrollPhysics(), // Disable ListView's own scrolling
                          itemCount: _storeGroupedResults.length,
                          itemBuilder: (context, index) {
                            final entry =
                                _storeGroupedResults.entries.elementAt(index);
                            final storeName = entry.key;
                            final products = entry.value;

                            return Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Store Info
                                GestureDetector(
                                  onTap: () {
                                    String storeId = products.first.retailer.id;
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            Storehome(storeId: storeId),
                                      ),
                                    );
                                  },
                                  child: ListTile(
                                    leading: CircleAvatar(
                                      backgroundImage: NetworkImage(
                                          products.first.storeLogo),
                                      radius: 24,
                                    ),
                                    title: Text(
                                      storeName,
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    subtitle: Text(
                                      "£0.99 Delivery fee | 20 min",
                                      style: GoogleFonts.poppins(
                                          fontSize: 12,
                                          color: Colors.grey[600]),
                                    ),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                // Product List for the Store
                                SizedBox(
                                  height: 230,
                                  child: ListView.builder(
                                    scrollDirection: Axis.horizontal,
                                    itemCount: products.length,
                                    itemBuilder: (context, index) {
                                      final product = products[index];
                                      return Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: ProductCard(
                                          imageUrl: product.imageUrl,
                                          avatarUrl: product.storeLogo,
                                          title: product.name,
                                          rating: product.averageRating,
                                          reviews: product.reviews.isNotEmpty
                                              ? product.reviews.first
                                              : 0,
                                          price: product.price,
                                          onAddToCart: () {
                                            Navigator.push(
                                              context,
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    ProductDetailsPage(
                                                        product: product),
                                              ),
                                            );
                                          },
                                        ),
                                      );
                                    },
                                  ),
                                ),
                                const SizedBox(height: 16),
                              ],
                            );
                          },
                        ),
            ],
          ),
        ),
      ),
    );
  }
}
