// import 'package:flutter/material.dart';

// import 'package:http/http.dart' as http;
// import 'dart:convert';



// class StripePaymentButton extends StatefulWidget {
//   final int amount; // Amount in cents
//   const StripePaymentButton({Key? key, required this.amount}) : super(key: key);

//   @override
//   _StripePaymentButtonState createState() => _StripePaymentButtonState();
// }

// class _StripePaymentButtonState extends State<StripePaymentButton> {
//   Map<String, dynamic>? paymentIntent;

//   Future<void> _makePayment() async {
//     try {
//       paymentIntent = await _createPaymentIntent();
//       if (paymentIntent == null) return;

//       await Stripe.instance.initPaymentSheet(
//         paymentSheetParameters: SetupPaymentSheetParameters(
//           paymentIntentClientSecret: paymentIntent!['client_secret'],
//           merchantDisplayName: 'Test Merchant',
//         ),
//       );

//       await Stripe.instance.presentPaymentSheet();
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Payment Successful!')),
//       );
//     } catch (e) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Payment Failed: $e')),
//       );
//     }
//   }

//   Future<Map<String, dynamic>?> _createPaymentIntent() async {
//     try {
//       final response = await http.post(
//         Uri.parse('https://api.stripe.com/v1/payment_intents'),
//         headers: {
//           //'Authorization': 'Bearer your_secret_key_here',
//           'Content-Type': 'application/x-www-form-urlencoded',
//         },
//         body: {
//           'amount': widget.amount.toString(),
//           'currency': 'usd',
//           'payment_method_types[]': 'card',
//         },
//       );

//       return jsonDecode(response.body);
//     } catch (e) {
//       print('Error creating payment intent: $e');
//       return null;
//     }
//   }

//   @override
//   Widget build(BuildContext context) {
//     return ElevatedButton(
//       onPressed: _makePayment,
//       child: Text('Pay \$${(widget.amount / 100).toStringAsFixed(2)}'),
//     );
//   }
// }
