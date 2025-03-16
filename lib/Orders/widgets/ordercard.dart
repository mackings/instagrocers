import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:instagrocers/Orders/Model/ordermodel.dart';
import 'package:intl/intl.dart';



class OrderCard extends StatelessWidget {
  final Order order;
  final VoidCallback onTap;

  const OrderCard({Key? key, required this.order, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap, 
      child: Container(
        padding: EdgeInsets.all(16),
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          border: Border.all(width: 0.5, color: Colors.black),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// **Order Status & Amount**
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    Icon(Icons.receipt_long, color: _getStatusColor(order.orderStatus)),
                    SizedBox(width: 8),
                    Text(
                      order.orderStatus, // Show API order status
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: _getStatusColor(order.orderStatus),
                      ),
                    ),
                  ],
                ),

                /// **Total Amount**
                Chip(
                  label: Text(
                    "USD ${order.totalAmount.toStringAsFixed(2)}",
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                  backgroundColor: Colors.orange,
                ),
              ],
            ),
            SizedBox(height: 8),

            /// **Estimated Delivery**
            Row(
              children: [
                Icon(Icons.access_time, color: Colors.grey, size: 18),
                SizedBox(width: 6),
                Text(
                  "Est: ${DateFormat("MMM dd, hh:mm a").format(order.estimatedDeliveryTime)}",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
              ],
            ),

            SizedBox(height: 12),

            /// **Address**
            Row(
              children: [
                Icon(Icons.location_on, color: Colors.orange, size: 18),
                SizedBox(width: 6),
                Expanded(
                  child: Text(
                    order.fullAddress,
                    style: TextStyle(fontSize: 14, color: Colors.black87),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),

            SizedBox(height: 12),

            /// **View Details Button**
            Align(
              alignment: Alignment.centerLeft,
              child: OutlinedButton.icon(
                onPressed: onTap,
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.orange),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                icon: Icon(Icons.info_outline, color: Colors.orange),
                label: Text("View Details", style: TextStyle(color: Colors.orange)),
              ),
            ),
          ],
        ),
      ),
    );
  }

  /// **Determine Order Status Color**
  Color _getStatusColor(String status) {
    switch (status) {
      case 'Pending':
        return Colors.blue;
      case 'Processing':
        return Colors.orange;
      case 'Shipped':
        return Colors.green;
      case 'Delivered':
        return Colors.grey;
      case 'Cancelled':
        return Colors.red;
      default:
        return Colors.black;
    }
  }
}

