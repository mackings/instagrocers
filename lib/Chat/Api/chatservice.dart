import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:instagrocers/Chat/models/chatmodel.dart';
import 'package:shared_preferences/shared_preferences.dart';



class ChatService {
  static const String sendMessageUrl = 'https://instagrocers-backend.onrender.com/chat';
  static const String getMessagesUrl = 'https://instagrocers-backend.onrender.com/display/chat';

  /// Fetches the authentication token and user ID from SharedPreferences.
  static Future<Map<String, String?>> _getAuthHeaders() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString("accessToken");
    final userData = prefs.getString("user");

    if (token == null || userData == null) return {"Authorization": null, "userId": null};

    final user = jsonDecode(userData);
    final userId = user["_id"];

    return {
      "Authorization": "Bearer $token",
      "userId": userId,
    };
  }

  /// Fetch chat history
  static Future<List<ChatMessage>> fetchChatHistory() async {
    final headers = await _getAuthHeaders();
    if (headers["Authorization"] == null) throw Exception("User not authenticated");

    final response = await http.get(
      Uri.parse(getMessagesUrl),
      headers: {"Authorization": headers["Authorization"]!},
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['messages'] as List).map((msg) => ChatMessage.fromJson(msg)).toList();
    } else {
      throw Exception('Failed to load chat history');
    }
  }

  /// Send a message
  static Future<ChatMessage> sendMessage(String message) async {
    final headers = await _getAuthHeaders();
    if (headers["Authorization"] == null || headers["userId"] == null) {
      throw Exception("User not authenticated");
    }

    final response = await http.post(
      Uri.parse(sendMessageUrl),
      headers: {
        "Content-Type": "application/json",
        "Authorization": headers["Authorization"]!,
      },
      body: jsonEncode({"userId": headers["userId"], "message": message}),
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return ChatMessage.fromJson(data['chat']['messages'].last);
    } else {
      throw Exception('Failed to send message');
    }
  }
}
