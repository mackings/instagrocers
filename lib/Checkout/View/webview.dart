import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

class InAppWebViewScreen extends StatefulWidget {
  final String url;
  final String sessionId; // Store session ID for verification

  InAppWebViewScreen({required this.url, required this.sessionId});

  @override
  _InAppWebViewScreenState createState() => _InAppWebViewScreenState();
}

class _InAppWebViewScreenState extends State<InAppWebViewScreen> {

  bool isPaymentCompleted = false;


  @override
void initState() {
  super.initState();
  print("Received session ID: ${widget.sessionId}"); // Debugging
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Payment")),
      body: InAppWebView(
        initialUrlRequest: URLRequest(
            url: WebUri.uri(Uri.parse(widget.url))), // Fix URL parsing
        onLoadStop: (controller, url) {
          if (url.toString().contains("success")) {
            setState(() {
              isPaymentCompleted = true;
            });
            _showPaymentVerificationSheet(); // Show bottom modal sheet
          }
        },
      ),
    );
  }

  void _showPaymentVerificationSheet() {
    showModalBottomSheet(
      context: context,
      isDismissible: false,
      isScrollControlled: true, // Makes the bottom sheet full width
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
            top: Radius.circular(20)), // Rounded top corners
      ),
      builder: (context) {
        // Automatically verify payment after a short delay
        Future.delayed(Duration(seconds: 2), () => _verifyPayment());

        return Container(
          width: double.infinity, // Full width
          padding: EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.check_circle,
                  color: Colors.green, size: 50), // Success icon
              SizedBox(height: 10),
              Text(
                "Payment Successful!",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              SizedBox(height: 10),
              Text(
                "Verifying your payment, please wait...",
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16, color: Colors.black54),
              ),
              SizedBox(height: 20),
              CircularProgressIndicator(), // Animated loader
              SizedBox(height: 20),
            ],
          ),
        );
      },
    );
  }




Future<void> _verifyPayment() async {
  final prefs = await SharedPreferences.getInstance();
  final String? token = prefs.getString("accessToken");

  if (token == null) {
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Authentication error. Please login again.")),
    );
    return;
  }

  if (widget.sessionId.isEmpty) { // Handle missing session ID
    Navigator.pop(context);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Error: Payment session ID is missing.")),
    );
    return;
  }

  print("Verifying payment with session ID: ${widget.sessionId}"); // Debugging

  final response = await http.post(
    Uri.parse("https://instagrocers-backend.onrender.com/verify-payment"),
    headers: {
      "Authorization": "Bearer $token",
      "Content-Type": "application/json",
    },
    body: jsonEncode({"session_id": widget.sessionId}),
  );


  Navigator.pop(context); // Close bottom sheet

  if (response.statusCode == 200) {
    final data = json.decode(response.body);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(data["message"])),
    );
    Navigator.pop(context); // Close WebView screen after successful payment
    Navigator.pop(context);
    Navigator.pop(context); 
  } else {
    final errorData = json.decode(response.body);
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(errorData["error"] ?? "Payment verification failed")),
    );
  }
}

}
