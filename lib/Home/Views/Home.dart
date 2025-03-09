

import 'package:flutter/material.dart';
import 'package:instagrocers/Home/Models/categorymodel.dart';
import 'package:instagrocers/Gen/Textformfield.dart';
import 'package:instagrocers/Gen/customtext.dart';
import 'package:instagrocers/Home/Models/retailer.dart';
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
  bool _isLoadingCategories = true;
  bool _isLoadingRetailers = true;
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadCategories();
    _loadRetailers();
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



  @override
  Widget build(BuildContext context) {
    return Scaffold(
    body: Padding(
      padding: const EdgeInsets.only(top: 20),
      child: Column(
        children: [
          ContainerTextFormField(
            label: "",
            hintText: "Search products and stores",
            controller: _searchController,
            prefixIcon: const Icon(Icons.search, color: Colors.grey),
          ),
      
          const SizedBox(height: 20),
      
          // Categories Section
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _isLoadingCategories ? 5 : _categories.length,
              itemBuilder: (_, index) {
                return _isLoadingCategories
                    ? Skeletonizer(enabled: true, child: _buildSkeletonCategory())
                    : GestureDetector(
                        onTap: () {
                          print(_categories[index].id);
                        },
                        child: _buildCategory(_categories[index]));
              },
            ),
          ),
      
          const SizedBox(height: 20),
      
          // Stores Near You Section
          const Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              CustomText(
                text: "Stores near you",
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
              CircleAvatar(
                child: Icon(Icons.arrow_forward),
              )
            ],
          ),
      
          const SizedBox(height: 15),
      
          // Retailers Section
          SizedBox(
            height: 120,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: _isLoadingRetailers ? 5 : _retailers.length,
              itemBuilder: (_, index) {
                return _isLoadingRetailers
                    ? Skeletonizer(enabled: true, child: _buildSkeletonRetailer())
                    : GestureDetector(
                        onTap: () {
                          print(_retailers[index].id);
                        },
                        child: _buildRetailer(_retailers[index]));
              },
            ),
          ),
        ],
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
              errorBuilder: (context, error, stackTrace) => const CircleAvatar(
                radius: 30,
                child: Icon(Icons.error, color: Colors.red),
              ),
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
            errorBuilder: (context, error, stackTrace) => const SizedBox.shrink(),
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
