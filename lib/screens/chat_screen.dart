import 'package:flutter/material.dart';
import 'package:meal_ui/services/api_service.dart';
import 'package:meal_ui/widgets/custom_bottom_nav_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = []; // Stores messages (text, image, or response)
  bool _isRecording = false;

  Future<void> _openCamera() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.camera);

    if (image != null) {
      // Show a confirmation dialog
      final bool? confirm = await showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Confirm Image'),
            content: Image.file(
              File(image.path),
              fit: BoxFit.cover,
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false), // Cancel
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true), // Confirm
                child: const Text('Send'),
              ),
            ],
          );
        },
      );

      if (confirm == true) {
        setState(() {
          _messages.insert(0, {'type': 'image', 'content': image.path});
        });
      }
    }
  }

  void _startRecording() {
    setState(() {
      _isRecording = true;
    });
    // Add audio recording logic here
    print('Recording started...');
  }

  void _stopRecording() {
    setState(() {
      _isRecording = false;
    });
    // Add logic to stop and save the recording
    print('Recording stopped.');
  }

  void _sendMessage() async {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      // Insert user's message (right aligned)
      setState(() {
        _messages.insert(0, {'type': 'text', 'content': message});
      });
      _messageController.clear();

      // Insert the "thinking" bubble (left aligned)
      setState(() {
        _messages.insert(0, {'type': 'thinking', 'content': 'Thinking...'});
      });

      try {
        final response = await ApiService.sendMessage(message: message);
        final macros = response['macros'] ?? {};

        // Attach the original chat prompt to the macros
        macros['prompt'] = message;

        setState(() {
          // Remove the "thinking" bubble
          _messages.removeWhere((msg) => msg['type'] == 'thinking');
          // Insert the API response message with type "response" (storing the whole macros map)
          _messages.insert(0, {'type': 'response', 'content': macros});
        });
      } catch (error) {
        setState(() {
          _messages.removeWhere((msg) => msg['type'] == 'thinking');
          _messages.insert(0, {
            'type': 'response',
            'content': {'description': 'Error occurred', 'prompt': message}
          });
        });
        print('Error: $error');
      }
    }
  }

  // Function to handle the POST API call when the Log button is pressed
  void _callPostApi(Map<String, dynamic> macros) async {
    try {
      // Create the POST body as a Map instead of a List
      final postLogBody = {
        "prompt": macros['prompt'] ?? 'Meal logged', // The original chat prompt
        "description": macros['description'] ?? 'No description available',
        "calories": macros['calories'] ?? 0.0,
        "protein": macros['protein'] ?? 0.0,
        "carbs": macros['carbs'] ?? 0.0,
        "fat": macros['fat'] ?? 0.0,
      };

      final postResponse = await ApiService.postLog(message: postLogBody);
      print('Post API response: $postResponse');
    } catch (error) {
      print('Error calling post API: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF17A2B8),
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: const NetworkImage('https://via.placeholder.com/150'),
              backgroundColor: Colors.grey[300],
            ),
            const SizedBox(width: 10),
            const Text(
              'Journal',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.call, color: Colors.white),
            onPressed: () {
              // Add call functionality here
            },
          ),
          IconButton(
            icon: const Icon(Icons.videocam, color: Colors.white),
            onPressed: () {
              // Add video call functionality here
            },
          ),
          IconButton(
            icon: const Icon(Icons.more_vert, color: Colors.white),
            onPressed: () {
              // Add more options functionality here
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          // Chat background (optional)
          Container(
            color: Colors.grey[200],
          ),
          // Chat messages
          Padding(
            padding: const EdgeInsets.only(bottom: 70),
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                if (message['type'] == 'text') {
                  return _buildChatBubble(message['content']);
                } else if (message['type'] == 'image') {
                  return _buildImageBubble(message['content']);
                } else if (message['type'] == 'thinking') {
                  return _buildThinkingBubble(message['content']);
                } else if (message['type'] == 'response') {
                  // Pass the macros map directly to build the response bubble
                  return _buildResponseBubble(message['content']);
                }
                return const SizedBox.shrink();
              },
            ),
          ),
          // Message input box
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
              color: Colors.white,
              child: Row(
                children: [
                  IconButton(
                    icon: const Icon(Icons.camera_alt, color: Color(0xFF17A2B8)),
                    onPressed: _openCamera,
                  ),
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      onSubmitted: (value) {
                        _sendMessage();
                      },
                      decoration: InputDecoration(
                        hintText: 'Type a message...',
                        hintStyle: const TextStyle(color: Colors.grey),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(30),
                          borderSide: BorderSide.none,
                        ),
                        filled: true,
                        fillColor: Colors.grey[100],
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      ),
                    ),
                  ),
                  _messageController.text.isEmpty
                      ? IconButton(
                          icon: Icon(
                            _isRecording ? Icons.stop : Icons.mic,
                            color: const Color(0xFF17A2B8),
                          ),
                          onPressed: _isRecording ? _stopRecording : _startRecording,
                        )
                      : IconButton(
                          icon: const Icon(Icons.send, color: Color(0xFF17A2B8)),
                          onPressed: _sendMessage,
                        ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: const CustomBottomNavBar(
        currentIndex: 2,
      ),
    );
  }

  /// Helper method to build chat bubbles for user text messages (right aligned)
  Widget _buildChatBubble(String message) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF17A2B8),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  /// Helper method to build chat bubbles for images (right aligned)
  Widget _buildImageBubble(String imagePath) {
    final File imageFile = File(imagePath);
    final Uint8List imageBytes = imageFile.readAsBytesSync();

    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(20),
          child: Image.memory(
            imageBytes,
            width: 200,
            height: 200,
            fit: BoxFit.cover,
          ),
        ),
      ),
    );
  }

  /// Helper method to build chat bubbles for thinking messages (left aligned)
  Widget _buildThinkingBubble(String message) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.grey[300],
          borderRadius: BorderRadius.circular(20),
        ),
        child: Text(
          message,
          style: const TextStyle(
            color: Colors.black,
            fontSize: 16,
          ),
        ),
      ),
    );
  }

  /// Helper method to build chat bubbles for API responses (left aligned)
  Widget _buildResponseBubble(Map<String, dynamic> macros) {
    final description = macros['description'] ?? 'No description available';
    return Align(
      alignment: Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // API response bubble
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              description,
              style: const TextStyle(
                color: Colors.black,
                fontSize: 16,
              ),
            ),
          ),
          // Log button bubble
          Container(
            margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            child: GestureDetector(
              onTap: () {
                _callPostApi(macros);
              },
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
                decoration: BoxDecoration(
                  color: const Color.fromARGB(122, 77, 84, 90),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'Log',
                  style: TextStyle(
                    color: Colors.black,
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
