import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:instagrocers/Orders/Api/orderservice.dart';
import 'package:instagrocers/Orders/Model/ordermodel.dart';
import 'package:instagrocers/Orders/widgets/ordercard.dart';
import 'package:instagrocers/Orders/widgets/orderwidget.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';




class OrderHome extends StatefulWidget {
  @override
  State<OrderHome> createState() => _OrderHomeState();
}

class _OrderHomeState extends State<OrderHome> {
  late Future<List<Order>> _ordersFuture;

  @override
  void initState() {
    super.initState();
    _ordersFuture = _fetchOrders();
  }

  Future<List<Order>> _fetchOrders() async {
    final orderService = OrderService();
    final data = await orderService.fetchOrder();
    if (data != null && data['success'] == true && data['orders'].isNotEmpty) {
      return (data['orders'] as List).map((json) => Order.fromJson(json)).toList();
    }
    return [];
  }

  Future<void> _refreshOrders() async {
    setState(() {
      _ordersFuture = _fetchOrders();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: RefreshIndicator(
        onRefresh: _refreshOrders,
        child: FutureBuilder<List<Order>>(
          future: _ordersFuture,
          builder: (context, snapshot) {
            if (snapshot.connectionState == ConnectionState.waiting) {
              return _buildSkeletonList();
            }

            if (!snapshot.hasData || snapshot.data!.isEmpty) {
              return Center(child: Text("No orders found"));
            }

            final orders = snapshot.data!;

            return ListView.builder(
              padding: EdgeInsets.only(top: 60, left: 15, right: 15),
              itemCount: orders.length,
              itemBuilder: (context, index) {
                final order = orders[index];
                return OrderCard(order: order, onTap: () => _showOrderDetails(order));
              },
            );
          },
        ),
      ),
    );
  }

  /// **Skeleton Loading State**
  Widget _buildSkeletonList() {
    return ListView.builder(
      padding: EdgeInsets.only(top: 60, left: 15, right: 15),
      itemCount: 5, // Show 5 placeholders
      itemBuilder: (context, index) {
        return Skeletonizer(
          child: Card(
            margin: EdgeInsets.only(bottom: 15),
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 20, width: 150, color: Colors.grey), // Order title
                  SizedBox(height: 10),
                  Container(height: 16, width: double.infinity, color: Colors.grey), // Order details
                  SizedBox(height: 10),
                  Container(height: 16, width: 100, color: Colors.grey), // Price
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  /// **Show Bottom Modal with Order Details**
  /// 
  /// 
void _showOrderDetails(Order order) {
  showModalBottomSheet(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (context) {
      return DraggableScrollableSheet(
        initialChildSize: 0.7,
        maxChildSize: 0.9,
        minChildSize: 0.5,
        builder: (context, scrollController) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
            ),
            padding: EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// **Header with Close Icon**
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Order Details",
                      style: GoogleFonts.poppins(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    IconButton(
                      icon: Icon(Icons.close, color: Colors.black),
                      onPressed: () => Navigator.pop(context),
                    ),
                  ],
                ),
                Divider(),

                /// **Order Items List**
                Expanded(
                  child: ListView(
                    controller: scrollController,
                    children: [
                      ...order.products.map((product) => ListTile(
                            leading: Icon(Icons.shopping_cart, color: Colors.orange),
                            title: Text(
                              product.name,
                              style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
                            ),
                            subtitle: Text(
                              "Qty: ${product.quantity}",
                              style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700]),
                            ),
                            trailing: Text(
                              "\$${product.price.toStringAsFixed(2)}",
                              style: GoogleFonts.poppins(fontSize: 14, fontWeight: FontWeight.bold),
                            ),
                          )),
                      Divider(),

                      /// **Estimated Delivery**
                      ListTile(
                        leading: Icon(Icons.timer, color: Colors.orange),
                        title: Text(
                          "Estimated Delivery",
                          style: GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w500),
                        ),
                        subtitle: Text(
                          DateFormat("MMM dd, hh:mm a").format(order.estimatedDeliveryTime),
                          style: GoogleFonts.poppins(fontSize: 14, color: Colors.grey[700]),
                        ),
                      ),
                      Divider(),

                      SizedBox(height: 30,),

                      /// **Tracking Widget**
                      OrderTrackingWidget(order: order),
                    ],
                  ),
                ),
              ],
            ),
          );
        },
      );
    },
  );
}

}