import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';



class CheckoutService {
  Future<Map<String, String>> createCheckoutSession({
    required List<Map<String, dynamic>> cartItems,
    required Map<String, String> userDetails,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("accessToken");

    if (token == null) throw Exception("No access token found");

    final Map<String, dynamic> body = {
      "cartItems": cartItems,
      "name": userDetails["name"],
      "phone": userDetails["phone"],
      "address": {
        "fullName": userDetails["name"],
        "fullAddress": userDetails["address"],
        "phoneNumber": userDetails["phone"]
      }
    };

    final response = await http.post(
      Uri.parse("https://instagrocers-backend.onrender.com/create-checkout-session"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
      body: jsonEncode(body),
    );

    if (response.statusCode == 200) {

final data = json.decode(response.body);
print("Checkout API Response: $data"); // Debugging

return {
  "url": data["url"],  // Stripe checkout URL
  "sessionId": data["sessionId"],  // Payment session ID
};

    } else {
      throw Exception("Failed to create checkout session");
    }
  }
}

