import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class GeminiChatScreen extends StatefulWidget {
  @override
  _GeminiChatScreenState createState() => _GeminiChatScreenState();
}

class _GeminiChatScreenState extends State<GeminiChatScreen> {
  final TextEditingController _controller = TextEditingController();
  List<Map<String, String>> messages = [];
  final String apiKey = "AIzaSyBTUjMdjy1N-Naqhcent6wqLrWHeTu4lYg"; // 🔹 Replace with your actual key

  Future<void> sendMessage(String userMessage) async {
    final String url =
        "https://generativelanguage.googleapis.com/v1/models/gemini-pro:generateText?key=$apiKey"; // ✅ Fixed API URL

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          // Check if this body format works with Gemini API
          "prompt": userMessage,
          "maxTokens": 150,  // optional: set token limit for response
        }),
      );

      print("Response Status: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        var data = jsonDecode(response.body);

        // Log the entire response to inspect its structure
        print("Response Data: $data");

        String botReply = "No response received.";

        // Check if the response contains 'text' field or 'choices'
        if (data.containsKey('choices') && data['choices'].isNotEmpty) {
          botReply = data['choices'][0]['text'] ?? "No valid response from API.";
        } else if (data.containsKey('generated_text')) {
          botReply = data['generated_text'] ?? "No valid response from API.";
        }

        setState(() {
          messages.add({"role": "user", "text": userMessage});
          messages.add({"role": "bot", "text": botReply});
        });
      } else {
        setState(() {
          messages.add({"role": "bot", "text": "Error: ${response.body}"}); // Show error message
        });
      }
    } catch (e) {
      setState(() {
        messages.add({"role": "bot", "text": "Connection Error: $e"}); // Handle network issues
      });
      print("Error: $e");  // Log the error for debugging
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("AI Assistant")),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: messages.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(messages[index]["text"]!,
                      style: TextStyle(
                          color: messages[index]["role"] == "user"
                              ? Colors.blue
                              : Colors.red)),
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: TextField(controller: _controller, decoration: InputDecoration(hintText: "Type a message")),
                ),
                IconButton(
                  icon: Icon(Icons.send),
                  onPressed: () {
                    if (_controller.text.isNotEmpty) {
                      sendMessage(_controller.text);
                      _controller.clear();
                    }
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}