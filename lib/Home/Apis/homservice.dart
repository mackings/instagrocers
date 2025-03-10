 
import 'dart:convert';
import 'package:instagrocers/Home/Models/categorymodel.dart';
import 'package:instagrocers/Home/Models/product.dart';
import 'package:instagrocers/Home/Models/retailer.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;


class HomeService {
  Future<List<Category>> fetchCategories() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("accessToken");

    if (token == null) throw Exception("No access token found");

    final response = await http.get(
      Uri.parse("https://instagrocers-backend.onrender.com/category"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Category.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load categories");
    }
  }

  Future<List<Retailer>> fetchRetailers() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("accessToken");

    if (token == null) throw Exception("No access token found");

    final response = await http.get(
      Uri.parse("https://instagrocers-backend.onrender.com/retailers"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Retailer.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load retailers");
    }
  }

  Future<List<Product>> fetchProducts() async {
    final prefs = await SharedPreferences.getInstance();
    final String? token = prefs.getString("accessToken");

    if (token == null) throw Exception("No access token found");

    final response = await http.get(
      Uri.parse("https://instagrocers-backend.onrender.com/product"),
      headers: {
        "Authorization": "Bearer $token",
        "Content-Type": "application/json",
      },
    );

    if (response.statusCode == 200) {
      List<dynamic> data = json.decode(response.body);
      return data.map((json) => Product.fromJson(json)).toList();
    } else {
      throw Exception("Failed to load products");
    }
  }
}