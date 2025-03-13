import 'package:flutter/material.dart';
import 'package:instagrocers/Cart/View/cart.dart';
import 'package:instagrocers/Gen/productcard.dart';
import 'package:instagrocers/Home/Models/categorymodel.dart';
import 'package:instagrocers/Gen/Textformfield.dart';
import 'package:instagrocers/Gen/customtext.dart';
import 'package:instagrocers/Home/Models/product.dart';
import 'package:instagrocers/Home/Models/retailer.dart';
import 'package:instagrocers/Home/Views/category.dart';
import 'package:instagrocers/Home/Views/pdetails.dart';
import 'package:instagrocers/Stores/storedashboard.dart';
import 'package:instagrocers/Stores/storehome.dart';
import 'package:skeletonizer/skeletonizer.dart';
import 'package:instagrocers/Home/Apis/homservice.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final HomeService _homeService = HomeService();
  List<Category> _categories = [];
  List<Retailer> _retailers = [];
  Map<String, List<Product>> _categoryProducts = {};

  bool _isLoadingCategories = true;
  bool _isLoadingRetailers = true;
  bool _isLoadingProducts = true;

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _loadRetailers();
    _loadProducts();
  }

  Future<void> _loadCategories() async {
    try {
      final categories = await _homeService.fetchCategories();
      setState(() {
        _categories = categories;
        _isLoadingCategories = false;
      });
    } catch (e) {
      print("Error fetching categories: $e");
      setState(() => _isLoadingCategories = false);
    }
  }

  Future<void> _loadRetailers() async {
    try {
      final retailers = await _homeService.fetchRetailers();
      setState(() {
        _retailers = retailers;
        _isLoadingRetailers = false;
      });
    } catch (e) {
      print("Error fetching retailers: $e");
      setState(() => _isLoadingRetailers = false);
    }
  }

  Future<void> _loadProducts() async {
    try {
      final categories = await _homeService.fetchCategories();
      final products = await _homeService.fetchProducts();

      Map<String, List<Product>> groupedProducts = {};
      for (var category in categories) {
        groupedProducts[category.id] = products
            .where((product) => product.category.id == category.id)
            .take(5)
            .toList();
      }

      setState(() {
        _categories = categories;
        _categoryProducts = groupedProducts;
        allProducts = products;
        _isLoadingProducts = false;
      });
    } catch (e) {
      print("Error fetching products: $e");
      setState(() => _isLoadingProducts = false);
    }
  }

  Future<void> _refreshData() async {
    setState(() {
      _isLoadingCategories = true;
      _isLoadingRetailers = true;
      _isLoadingProducts = true;
    });

    await Future.wait([_loadCategories(), _loadRetailers(), _loadProducts()]);

    setState(() {
      _isLoadingCategories = false;
      _isLoadingRetailers = false;
      _isLoadingProducts = false;
    });
  }

  List<Product> allProducts = [];

  List<Product> _getProductsForCategory(Category category) {
    return allProducts
        .where((product) => product.category.id == category.id)
        .toList();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.only(top: 20),
        child: RefreshIndicator(
          onRefresh: _refreshData, // Function to refresh data
          child: ListView(
            padding: const EdgeInsets.all(10),
            children: [
              const SizedBox(height: 10),

              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => Storedashboard()));
                      },
                      child: CustomText(text: "Lagos NG")),
                  GestureDetector(
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => CartPage()));
                      },
                      child: Icon(Icons.shopping_cart))
                ],
              ),

              const SizedBox(height: 15),
              // Search Bar
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
    //onChanged: _performSearch,
  ),
),

              const SizedBox(height: 20),

              // Categories Section
              SizedBox(
                height: 110,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _isLoadingCategories ? 5 : _categories.length,
                  itemBuilder: (_, index) {
                    if (_isLoadingCategories) {
                      return Skeletonizer(
                          enabled: true, child: _buildSkeletonCategory());
                    }

                    final category = _categories[index];
                    final products = _getProductsForCategory(category);

                    return GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => CategoryPage(
                                category: category, products: products),
                          ),
                        );
                      },
                      child: _buildCategory(category),
                    );
                  },
                ),
              ),

              // Retailers Section
              SizedBox(
                height: 110,
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: _isLoadingRetailers ? 5 : _retailers.length,
                  itemBuilder: (_, index) {
                    return _isLoadingRetailers
                        ? Skeletonizer(
                            enabled: true, child: _buildSkeletonRetailer())
                        : GestureDetector(
                            onTap: () {
                              String storeId = _retailers[index].id;
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      Storehome(storeId: storeId),
                                ),
                              );
                            },
                            child: _buildRetailer(_retailers[index]),
                          );
                  },
                ),
              ),

              if (_isLoadingProducts)
                Skeletonizer(
                  enabled: true,
                  child: Column(
                    children: List.generate(
                      3, // Show 3 skeleton loading sections
                      (index) => Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Simulated Category Title
                            Container(
                              width: 120,
                              height: 20,
                              color: Colors.grey[300],
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 16),
                            ),
                            const SizedBox(height: 8),

                            // Simulated Product List
                            SizedBox(
                              height:
                                  200, // Adjust height for the product section
                              child: ListView.builder(
                                scrollDirection: Axis.horizontal,
                                itemCount:
                                    4, // Simulating 4 products per category
                                itemBuilder: (context, _) => Padding(
                                  padding: const EdgeInsets.only(right: 10),
                                  child: Container(
                                    width: 140, // Simulated product card width
                                    decoration: BoxDecoration(
                                      color: Colors.grey[300],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                )
              else
                Column(
                  children: _categories
                      .map(
                        (category) => _buildCategorySection(
                            category, _categoryProducts[category.id] ?? []),
                      )
                      .toList(),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCategory(Category category) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          ClipOval(
            child: Image.network(
              category.image,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 5),
          CustomText(
            text: category.name,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }

  Widget _buildCategorySection(Category category, List<Product> products) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Category Title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                category.name,
                style:
                    const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              GestureDetector(
                onTap: () {
                  print(category.name);
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) =>
                          CategoryPage(category: category, products: products),
                    ),
                  );
                },
                child: const Text(
                  "See all",
                  style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.orange),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 10),

        SizedBox(
          height: 230,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: products.length,
            itemBuilder: (context, index) {
              final product = products[index];
              return Padding(
                padding:
                    EdgeInsets.only(right: 10, left: 10, top: 10, bottom: 10),
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
                          builder: (context) =>
                              ProductDetailsPage(product: product),
                        ),
                      );
                    }),
              );
            },
          ),
        ),
      ],
    );
  }

  Widget _buildSkeletonCategory() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          const CircleAvatar(radius: 35), // Skeletonized circle
          const SizedBox(height: 5),
          Container(width: 60, height: 10, color: Colors.grey),
        ],
      ),
    );
  }

  Widget _buildRetailer(Retailer retailer) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          ClipOval(
            child: Image.network(
              retailer.logo,
              width: 60,
              height: 60,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stackTrace) =>
                  const SizedBox.shrink(),
            ),
          ),
          const SizedBox(height: 5),
          CustomText(
            text: retailer.storeName,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ],
      ),
    );
  }

  Widget _buildSkeletonRetailer() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8),
      child: Column(
        children: [
          const CircleAvatar(radius: 35), // Skeletonized circle
          const SizedBox(height: 5),
          Container(width: 60, height: 10, color: Colors.grey),
        ],
      ),
    );
  }
}
