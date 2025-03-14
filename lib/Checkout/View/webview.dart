import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';



class InAppWebViewScreen extends StatelessWidget {
  final String url;

  InAppWebViewScreen({required this.url});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Payment")),
      body: InAppWebView(
        initialUrlRequest: URLRequest(url: WebUri(url)),
        onLoadStop: (controller, url) {
          if (url.toString().contains("success")) {
            Navigator.pop(context); // Close WebView after success
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Payment Successful")),
            );
          }
        },
      ),
    );
  }
}
