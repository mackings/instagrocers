import 'package:flutter/material.dart';
import 'package:instagrocers/Orders/Model/ordermodel.dart';
import 'package:intl/intl.dart';




class OrderTrackingWidget extends StatefulWidget {
  final Order order;

  const OrderTrackingWidget({Key? key, required this.order}) : super(key: key);

  @override
  _OrderTrackingWidgetState createState() => _OrderTrackingWidgetState();
}

class _OrderTrackingWidgetState extends State<OrderTrackingWidget> {
  late int _currentStep;

  @override
  void initState() {
    super.initState();
    _currentStep = _getStepFromStatus(widget.order.orderStatus);
  }

  /// **Map API order statuses to tracking steps**
  int _getStepFromStatus(String status) {
    switch (status) {
      case 'Pending':
        return 0;
      case 'Processing':
        return 1;
      case 'Shipped':
        return 2;
      case 'Delivered':
        return 3;
      case 'Cancelled':
        return 4;
      default:
        return 0;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(width: 0.5)
      ),
      padding: EdgeInsets.all(16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _getTrackingTitle(),
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          SizedBox(height: 4),
          Text(
            'Arriving at ${DateFormat("hh:mm a").format(widget.order.estimatedDeliveryTime)}',
            style: TextStyle(fontSize: 14, color: Colors.grey),
          ),
          Divider(),
          _buildTimeline(context),
          Divider(),
          _buildShopperInfo(widget.order),
          Divider(),
        ],
      ),
    );
  }

  /// **Get Tracking Title based on Status**
  String _getTrackingTitle() {
    switch (widget.order.orderStatus) {
      case 'Pending':
        return 'Your order is pending...';
      case 'Processing':
        return 'Processing your order...';
      case 'Shipped':
        return 'Your order is on the way...';
      case 'Delivered':
        return 'Your order has been delivered!';
      case 'Cancelled':
        return 'Your order was cancelled';
      default:
        return 'Tracking your order...';
    }
  }

  /// **Order Tracking Timeline**
  Widget _buildTimeline(BuildContext context) {
    List<String> steps = ["Pending", "Processing", "Shipped", "Delivered", "Cancelled"];
    List<IconData> icons = [
      Icons.timer,
      Icons.autorenew,
      Icons.local_shipping,
      Icons.done,
      Icons.cancel
    ];

    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 80,
          child: Stack(
            alignment: Alignment.center,
            children: [
              Positioned(
                top: 28,
                left: 40,
                right: 40,
                child: Row(
                  children: List.generate(steps.length - 1, (index) {
                    bool isCompleted = index < _currentStep;
                    return Expanded(
                      child: Container(
                        height: 3,
                        color: isCompleted ? Colors.orange : Colors.grey[300],
                      ),
                    );
                  }),
                ),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: List.generate(steps.length, (index) {
                  bool isActive = index <= _currentStep;
                  return Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        width: 34,
                        height: 34,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: isActive ? Colors.orange : Colors.grey[300],
                        ),
                        child: Icon(
                          icons[index],
                          color: isActive ? Colors.white : Colors.grey,
                          size: 18,
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 4),
                        child: Text(
                          steps[index],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: isActive ? Colors.black : Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ],
          ),
        ),
      ],
    );
  }

  /// **Shopper/Delivery Info**
  Widget _buildShopperInfo(Order order) {
    return Row(
      children: [
        CircleAvatar(
          radius: 20,
          backgroundImage: AssetImage('assets/flower.png'),
        ),
        SizedBox(width: 10),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(order.fullName, style: TextStyle(fontWeight: FontWeight.bold)),
            Text(
              order.orderStatus == "Delivered"
                  ? "Delivery Completed ⭐ 5.0"
                  : "Delivering Orders ⭐ 4.8",
              style: TextStyle(color: Colors.grey),
            ),
          ],
        ),
        Spacer(),
        Icon(Icons.phone, color: Colors.orange),
        SizedBox(width: 10),
        Icon(Icons.message, color: Colors.orange),
      ],
    );
  }
}

