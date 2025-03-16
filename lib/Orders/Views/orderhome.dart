import 'package:flutter/material.dart';
import 'package:instagrocers/Orders/Api/orderservice.dart';
import 'package:instagrocers/Orders/Model/ordermodel.dart';
import 'package:instagrocers/Orders/widgets/ordercard.dart';
import 'package:instagrocers/Orders/widgets/orderwidget.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';



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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[100],
      body: FutureBuilder<List<Order>>(
        future: _ordersFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return Center(child: CircularProgressIndicator());
          }

          if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return Center(child: Text("No orders found"));
          }

          final orders = snapshot.data!;

          return ListView.builder(
            padding: EdgeInsets.only(top: 60,left: 15,right: 15),
            itemCount: orders.length,
            itemBuilder: (context, index) {
              final order = orders[index];
              return Column(
                
                children: [
                  OrderCard(order: order, onTap: () => _showOrderDetails(order)),
                ],
              );
            },
          );
        },
      ),
    );
  }

  /// **Show Bottom Modal with Order Details**
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
              child: ListView(
                controller: scrollController,
                children: [
                  /// **Order Summary**
                  Text("Order Details", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
                  SizedBox(height: 10),


                  /// **Product List**
                  ...order.products.map((product) => ListTile(
                        leading: Icon(Icons.shopping_cart, color: Colors.orange),
                        title: Text(product.name),
                        subtitle: Text("Qty: ${product.quantity}"),
                        trailing: Text("\$${product.price.toStringAsFixed(2)}"),
                      )),

                  Divider(),

                  /// **Estimated Delivery**
                  ListTile(
                    leading: Icon(Icons.timer, color: Colors.orange),
                    title: Text("Estimated Delivery"),
                    subtitle: Text(DateFormat("MMM dd, hh:mm a").format(order.estimatedDeliveryTime)),
                  ),

                  Divider(),

                  /// **Tracking Widget**
                  OrderTrackingWidget(order: order),
                ],
              ),
            );
          },
        );
      },
    );
  }


}