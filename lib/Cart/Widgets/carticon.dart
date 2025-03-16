import 'package:flutter/material.dart';
import 'package:instagrocers/Cart/View/cart.dart';
import 'package:instagrocers/Cart/services/cartservice.dart';

class CartIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => CartPage()),
        );
      },
      child: Stack(
        children: [
          Icon(Icons.shopping_cart, size: 28, color: Colors.black),

          /// **Badge for Cart Count**
          FutureBuilder<int>(
            future: CartService.getCartItemCount(),
            builder: (context, snapshot) {
              if (!snapshot.hasData || snapshot.data == 0) {
                return SizedBox(); // Hide badge if cart is empty
              }

              return Positioned(
                right: 0,
                top: 0,
                child: Container(
                  padding: EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.red,
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.white, width: 1.5),
                  ),
                  child: Text(
                    snapshot.data.toString(),
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
