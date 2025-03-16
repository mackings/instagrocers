import 'dart:async';

import 'package:flutter/material.dart';
import 'package:instagrocers/Chat/Api/chatservice.dart';
import 'package:instagrocers/Chat/models/chatmodel.dart';
import 'package:instagrocers/Gen/customtext.dart';
import 'package:intl/intl.dart';
import 'package:skeletonizer/skeletonizer.dart';




class ChatHome extends StatefulWidget {
  const ChatHome({super.key});

  @override
  State<ChatHome> createState() => _ChatHomeState();
}

class _ChatHomeState extends State<ChatHome> {
  final TextEditingController _controller = TextEditingController();
  final List<ChatMessage> _messages = [];
  final ScrollController _scrollController = ScrollController();
  Timer? _chatTimer;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadChatHistory();
    _startAutoRefresh();
  }

  void _startAutoRefresh() {
    _chatTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _fetchNewMessages();
    });
  }

  Future<void> _loadChatHistory() async {
    setState(() => _isLoading = true);
    try {
      final messages = await ChatService.fetchChatHistory();
      setState(() {
        _messages.clear();
        _messages.addAll(messages);
      });
      _scrollToBottom();
    } catch (e) {
      debugPrint("Error loading chat history: $e");
    } finally {
      setState(() => _isLoading = false);
    }
  }

  Future<void> _fetchNewMessages() async {
    try {
      final newMessages = await ChatService.fetchChatHistory();
      if (newMessages.isNotEmpty) {
        setState(() {
          for (var message in newMessages) {
            if (!_messages.any((m) => m.timestamp == message.timestamp)) {
              _messages.add(message);
            }
          }
        });
        _scrollToBottom();
      }
    } catch (e) {
      debugPrint("Error fetching new messages: $e");
    }
  }

  void _sendMessage() async {
    if (_controller.text.isEmpty) return;

    String messageText = _controller.text;
    String timestamp = DateTime.now().toString();
    _controller.clear();

    setState(() {
      _messages.add(ChatMessage(
        sender: "user",
        text: messageText,
        timestamp: timestamp,
      ));
    });

    _scrollToBottom();

    try {
      ChatMessage botResponse = await ChatService.sendMessage(messageText);
      setState(() {
        _messages.add(botResponse);
      });
      _scrollToBottom();
    } catch (e) {
      debugPrint("Error sending message: $e");
    }
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  void dispose() {
    _chatTimer?.cancel();
    _controller.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: CustomText(text: "InstaBot")),
      body: Padding(
        padding: const EdgeInsets.only(left: 15, right: 15),
        child: Column(
          children: [
            Expanded(
              child: RefreshIndicator(
                onRefresh: _loadChatHistory,
                child: _isLoading
                    ? Skeletonizer(
                        enabled: _isLoading,
                        child: ListView.builder(
                          itemCount: 5, // Display 5 loading skeletons
                          itemBuilder: (context, index) {
                            return _buildSkeletonMessage();
                          },
                        ),
                      )
                    : ListView.builder(
                        controller: _scrollController,
                        itemCount: _messages.length,
                        itemBuilder: (context, index) {
                          final message = _messages[index];
                          bool isUser = message.sender == "user";
                          return _buildChatBubble(message, isUser);
                        },
                      ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: _controller,
                      decoration: InputDecoration(
                        hintText: "Type a message...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ),
                  IconButton(
                    icon: const Icon(Icons.send, color: Colors.blue),
                    onPressed: _sendMessage,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildChatBubble(ChatMessage message, bool isUser) {
    return Row(
      mainAxisAlignment: isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
      children: [
        if (!isUser) // Bot Icon (Left Side)
          const CircleAvatar(
            backgroundColor: Colors.grey,
            child: Icon(Icons.android, color: Colors.white),
          ),
        const SizedBox(width: 8),
        Flexible(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: isUser ? Colors.blueAccent : Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
              children: [
                Text(
                  message.text,
                  style: TextStyle(
                    color: isUser ? Colors.white : Colors.black,
                  ),
                  softWrap: true,
                ),
                const SizedBox(height: 5),
                Text(
                  _formatTimestamp(message.timestamp),
                  style: TextStyle(
                    fontSize: 12,
                    color: isUser ? Colors.white70 : Colors.black54,
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  Widget _buildSkeletonMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        const CircleAvatar(backgroundColor: Colors.grey),
        const SizedBox(width: 8),
        Expanded(
          child: Container(
            margin: const EdgeInsets.symmetric(vertical: 5),
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(10),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  height: 12,
                  width: double.infinity,
                  color: Colors.grey[400],
                ),
                const SizedBox(height: 5),
                Container(
                  height: 12,
                  width: 80,
                  color: Colors.grey[400],
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 8),
      ],
    );
  }

  String _formatTimestamp(String timestamp) {
    try {
      DateTime dateTime = DateTime.parse(timestamp).toLocal();
      return DateFormat("d MMM, h:mm a").format(dateTime);
    } catch (e) {
      return timestamp;
    }
  }
}
