import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';



class AuthService {
  static const String baseUrl = "https://instagrocers-backend.onrender.com";

  Future<UserModel?> login(String email, String password) async {
    final url = Uri.parse("$baseUrl/login");
    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({"email": email, "password": password}),
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        final user = UserModel.fromJson(data);
        await _saveUserData(data);
        return user;
      } else {
        return null;
      }
    } catch (e) {
      print("Login Error: $e");
      return null;
    }
  }

  Future<void> _saveUserData(Map<String, dynamic> data) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("accessToken", data["accessToken"]);
    await prefs.setString("refreshToken", data["refreshToken"]);
    await prefs.setString("user", jsonEncode(data["user"]));
  }
}

class UserModel {
  final String id;
  final String name;
  final String email;
  final String role;
  final String accessToken;
  final String refreshToken;

  UserModel({
    required this.id,
    required this.name,
    required this.email,
    required this.role,
    required this.accessToken,
    required this.refreshToken,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      id: json["user"]["_id"],
      name: json["user"]["name"],
      email: json["user"]["email"],
      role: json["user"]["role"],
      accessToken: json["accessToken"],
      refreshToken: json["refreshToken"],
    );
  }
}
