import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:instagrocers/Home/Apis/homservice.dart';
import 'package:instagrocers/Home/Models/product.dart';
import 'package:instagrocers/Stores/widgets/store.dart';
import 'package:skeletonizer/skeletonizer.dart';




class Storehome extends StatefulWidget {
  final String storeId;

  const Storehome({Key? key, required this.storeId}) : super(key: key);

  @override
  State<Storehome> createState() => _StorehomeState();
}

class _StorehomeState extends State<Storehome> {
  final HomeService _homeService = HomeService();
  List<Product> _products = [];
  bool _isLoading = true;
  String storeName = '';
  String storeLogo = '';

  @override
  void initState() {
    super.initState();
    fetchStoreProducts();
  }

  Future<void> fetchStoreProducts() async {
    try {
      List<Product> products = await _homeService.fetchStoreProducts(widget.storeId);
      if (products.isNotEmpty) {
        storeName = products.first.retailer.storeName;
        storeLogo = products.first.storeLogo;
      }
      setState(() {
        _products = products;
        _isLoading = false;
      });
    } catch (e) {
      print("Error fetching store products: $e");
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _isLoading
                ? _buildSkeletonLoader()
                : _products.isNotEmpty
                    ? StoreSection(
                        title: "Special Offer on Chickens",
                        products: _products,
                        storeName: storeName,
                        storeLogo: storeLogo,
                      )
                    : const Center(child: Text("No products available")),
          ],
        ),
      ),
    );
  }

  Widget _buildSkeletonLoader() {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Skeletonizer(
        enabled: true,
        child: Column(
          children: List.generate(
            3, // Show 3 placeholders
            (index) => Container(
              margin: const EdgeInsets.only(bottom: 16),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.shade300,
                    blurRadius: 5,
                    spreadRadius: 2,
                  ),
                ],
              ),
              child: Row(
                children: [
                  Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Container(
                          width: double.infinity,
                          height: 20,
                          color: Colors.grey.shade300,
                        ),
                        const SizedBox(height: 8),
                        Container(
                          width: 100,
                          height: 20,
                          color: Colors.grey.shade300,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
