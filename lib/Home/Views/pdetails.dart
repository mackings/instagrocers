import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagrocers/Gen/custombtn.dart';
import 'package:instagrocers/Gen/productcard.dart';
import 'package:instagrocers/Home/Apis/homservice.dart';
import 'package:instagrocers/Home/Models/product.dart';




class ProductDetailsPage extends StatefulWidget {
  final Product product;

  const ProductDetailsPage({super.key, required this.product});

  @override
  _ProductDetailsPageState createState() => _ProductDetailsPageState();
}

class _ProductDetailsPageState extends State<ProductDetailsPage> {



  int quantity = 1;
  List<Product> similarItems = [];
  List<Product> frequentlyBought = [];
  List<Product> moreToExplore = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchRelatedProducts();
  }

  Future<void> _fetchRelatedProducts() async {
    try {
      List<Product> allProducts = await HomeService().fetchProducts();
      List<Product> sameCategory = allProducts
          .where((p) =>
              p.category.id == widget.product.category.id &&
              p.id != widget.product.id)
          .toList();

      List<Product> otherCategories = allProducts
          .where((p) => p.category.id != widget.product.category.id)
          .toList();

      setState(() {
        similarItems = sameCategory.take(5).toList();
        frequentlyBought = sameCategory.take(3).toList();
        moreToExplore = otherCategories.take(5).toList();
        isLoading = false;
      });
    } catch (e) {
      print("Error fetching products: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.green.shade700,
      bottomNavigationBar: const BottomAppBar(
        elevation: 0,
        color: Colors.white,
        child: CustomButton(
          color: Colors.orange,
          text: "Add to cart",
        ),
      ),
      body: Stack(
        alignment: Alignment.topCenter,
        children: [
          SingleChildScrollView(
            child: Column(
              children: [
                const SizedBox(height: 60),
                Container(
                  margin:
                      const EdgeInsets.only(top: 40), 
                  padding: const EdgeInsets.all(12),
                  decoration:const BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                          topRight: Radius.circular(20),
                          topLeft: Radius.circular(20))),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Close and Favorite Icons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          _buildIconButton(
                              Icons.close, () => Navigator.pop(context)),
                          _buildIconButton(Icons.favorite_border, () {}),
                        ],
                      ),

                      // Product Image
                      Center(
                        child:
                            Image.network(widget.product.imageUrl, height: 200),
                      ),

                      const SizedBox(height: 10),

                      // Product Name and Rating
                      Text(widget.product.name,
                          style: GoogleFonts.poppins(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      Row(
                        children: [
                          const Icon(Icons.star,
                              color: Colors.orange, size: 18),
                          Text("${widget.product.averageRating} (287)",
                              style: GoogleFonts.poppins(
                                  fontSize: 14, color: Colors.grey[600])),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // Price and Quantity Selector
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text("£${widget.product.price.toStringAsFixed(2)}",
                              style: GoogleFonts.poppins(
                                  fontSize: 18, fontWeight: FontWeight.bold)),
                          _buildQuantitySelector(),
                        ],
                      ),

                      const SizedBox(height: 10),

                      // Details Section
                      const Text("Details",
                          style: TextStyle(
                              fontSize: 16, fontWeight: FontWeight.bold)),
                      const SizedBox(height: 5),
                      Text(widget.product.description,
                          style: GoogleFonts.poppins(color: Colors.grey)),

                      const SizedBox(height: 15),

                      // Related Products Sections
                      if (isLoading)
                        const Center(child: CircularProgressIndicator(color: Colors.white,)),
                      if (!isLoading)
                        _buildSection("Similar Items", similarItems),
                      if (!isLoading)
                        _buildSection(
                            "Frequently Bought Together", frequentlyBought),
                      if (!isLoading)
                        _buildSection("More to Explore", moreToExplore),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Positioned(
            top: 40,
            child: CircleAvatar(
              radius: 40,
              backgroundColor: Colors.white,
              backgroundImage:
                  NetworkImage(widget.product.storeLogo), // Store Image URL
            ),
          ),
        ],
      ),
    );
  }

  // Custom Icon Button
  Widget _buildIconButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.white.withOpacity(0.8),
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.black),
      ),
    );
  }

  // Quantity Selector
  Widget _buildQuantitySelector() {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        children: [
          _buildQuantityButton(Icons.remove, () {
            if (quantity > 1) setState(() => quantity--);
          }),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12),
            child: Text("$quantity", style: GoogleFonts.poppins(fontSize: 16)),
          ),
          _buildQuantityButton(Icons.add, () {
            setState(() => quantity++);
          }),
        ],
      ),
    );
  }

  // Quantity Button
  Widget _buildQuantityButton(IconData icon, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Icon(icon, size: 18, color: Colors.orange),
      ),
    );
  }

  // Product List Sections
// Product List Sections
Widget _buildSection(String title, List<Product> items) {
  if (items.isEmpty) return const SizedBox();

  return Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(title,
            style: GoogleFonts.poppins(
                fontSize: 16, fontWeight: FontWeight.bold)),
      ),
      SizedBox(
        height: 230,
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
                  // Navigate to the selected product's details page
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
