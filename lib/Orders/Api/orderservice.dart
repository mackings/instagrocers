import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class OrderService {
  static const String baseUrl = 'https://instagrocers-backend.onrender.com/order';

  /// Fetch order details from API
  Future<Map<String, dynamic>?> fetchOrder() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('accessToken'); // Retrieve auth token

      final response = await http.get(
        Uri.parse(baseUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        return data;
      } else {
        print('Failed to load order data: ${response.statusCode}');
        return null;
      }
    } catch (e) {
      print('Error fetching order data: $e');
      return null;
    }
  }
}
