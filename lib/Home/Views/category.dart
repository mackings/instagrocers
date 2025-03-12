import 'package:flutter/material.dart';
import 'package:instagrocers/Gen/productcard.dart';
import 'package:instagrocers/Home/Models/categorymodel.dart';
import 'package:instagrocers/Home/Models/product.dart';
import 'package:instagrocers/Home/Views/pdetails.dart';




class CategoryPage extends StatefulWidget {
  final Category category;
  final List<Product> products;

  const CategoryPage({super.key, required this.category, required this.products});

  @override
  State<CategoryPage> createState() => _CategoryPageState();
}

class _CategoryPageState extends State<CategoryPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.category.name),
      ),
      body: Padding(
        padding: const EdgeInsets.all(10),
        child: GridView.builder(
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2, // 2 items per row
            crossAxisSpacing: 20, // Reduced spacing for better fit
            mainAxisSpacing: 10,
            childAspectRatio: 0.82, // Adjusted for medium size
          ),
          itemCount: widget.products.length,
          itemBuilder: (context, index) {
            final product = widget.products[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: ProductCard(
                avatarUrl: product.storeLogo,
                imageUrl: product.imageUrl,
                title: product.name,
                rating: product.averageRating,
                reviews: product.reviews.length,
                price: product.price,
                onAddToCart: () {
                Navigator.push(
  context,
  MaterialPageRoute(
    builder: (context) => ProductDetailsPage(product: product),
  ),
);
                }
              ),
            );
          },
        ),
      ),
    );
  }
}

