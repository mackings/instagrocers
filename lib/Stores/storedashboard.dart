import 'package:flutter/material.dart';
import 'package:instagrocers/Home/Apis/homservice.dart';
import 'package:instagrocers/Home/Models/retailer.dart';
import 'package:instagrocers/Stores/storehome.dart';
import 'package:instagrocers/Stores/widgets/retailcard.dart';
import 'package:skeletonizer/skeletonizer.dart';



class Storedashboard extends StatefulWidget {
  const Storedashboard({super.key});

  @override
  State<Storedashboard> createState() => _StoredashboardState();
}

class _StoredashboardState extends State<Storedashboard> {
  late Future<List<Retailer>> _retailersFuture;
  final HomeService _homeService = HomeService();

  @override
  void initState() {
    super.initState();
    _retailersFuture = _homeService.fetchRetailers();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Stores"),
        backgroundColor: Colors.green,
      ),
      body: FutureBuilder<List<Retailer>>(
        future: _retailersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            // Show skeleton loading state
            return ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: 3, // Show 3 skeletons while loading
              itemBuilder: (context, index) {
                return Skeletonizer(
                  enabled: true,
                  child: StoreCard(
                    storeName: "Loading...",
                    logoUrl: "",
                    deliveryFee: "£0.99",
                    deliveryTime: "20 min",
                    productCount: "20,000",
                    index: index,
                  ),
                );
              },
            );
          } else if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text("No stores available"));
          }

          final retailers = snapshot.data!;

          return ListView.builder(
            padding: const EdgeInsets.all(16),
            itemCount: retailers.length,
            itemBuilder: (context, index) {
              final retailer = retailers[index];

              return GestureDetector(
                onTap: () {
                  String storeId = retailers[index].id;
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => Storehome(storeId: storeId),
                    ),
                  );
                },
                child: StoreCard(
                  storeName: retailer.storeName,
                  logoUrl: retailer.logo,
                  deliveryFee: "£0.99",
                  deliveryTime: "20 min",
                  productCount: "20,000",
                  index: index, // Pass index for color selection
                ),
              );
            },
          );
        },
      ),
    );
  }
}