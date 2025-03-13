import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:instagrocers/Home/Models/product.dart';
import 'package:shared_preferences/shared_preferences.dart';



class SearchService {
  final String baseUrl = "https://instagrocers-backend.onrender.com";

  Future<List<Product>> searchProducts(String query) async {
    try {
      // Fetch token from SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString("accessToken"); // Ensure consistency

      if (token == null) throw Exception("No access token found");

      final url = "$baseUrl/search?query=$query";
      final headers = {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      };

      // Log Request Details
      debugPrint("🔍 [Search API] Request URL: $url");
      debugPrint("🔍 [Search API] Headers: $headers");

      // API Request
      final response = await http.get(Uri.parse(url), headers: headers);

      // Log Response Details
      debugPrint("✅ [Search API] Response Status: ${response.statusCode}");
      debugPrint("✅ [Search API] Response Body: ${response.body}");

      if (response.statusCode == 200) {
        List<dynamic> data = json.decode(response.body);
        return data.map((json) => Product.fromJson(json)).toList();
      } else {
        debugPrint("❌ [Search API] Error: ${response.body}");
        throw Exception("Failed to fetch search results");
      }
    } catch (e) {
      debugPrint("🚨 [Search API] Exception: $e");
      throw Exception("Error searching products: $e");
    }
  }
}