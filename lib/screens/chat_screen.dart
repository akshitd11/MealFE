import 'package:flutter/material.dart';
import 'package:meal_ui/widgets/custom_bottom_nav_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'dart:typed_data';

class ChatScreen extends StatefulWidget {
  const ChatScreen({Key? key}) : super(key: key);

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _messageController = TextEditingController();
  final List<Map<String, dynamic>> _messages = []; // List to store messages (text or image)
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
          _messages.add({'type': 'image', 'content': image.path}); // Add image to messages
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

  void _sendMessage() {
    final message = _messageController.text.trim();
    if (message.isNotEmpty) {
      setState(() {
        _messages.add({'type': 'text', 'content': message}); // Add text message to the list
      });
      _messageController.clear();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: const Color(0xFF17A2B8), // Match the app's theme color
        elevation: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 20,
              backgroundImage: const NetworkImage(
                  'https://via.placeholder.com/150'), // Replace with user image
              backgroundColor: Colors.grey[300],
            ),
            const SizedBox(width: 10),
            const Text(
              'User Name', // Replace with the chat user's name
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
            color: Colors.grey[200], // Light background color
          ),
          // Chat messages
          Padding(
            padding: const EdgeInsets.only(bottom: 70), // Leave space for the input box
            child: ListView.builder(
              reverse: true, // Show the latest message at the bottom
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final message = _messages[index];
                if (message['type'] == 'text') {
                  return _buildChatBubble(message['content']);
                } else if (message['type'] == 'image') {
                  return _buildImageBubble(message['content']);
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
                  // Camera icon
                  IconButton(
                    icon: const Icon(Icons.camera_alt, color: Color(0xFF17A2B8)),
                    onPressed: _openCamera,
                  ),
                  // Text input field
                  Expanded(
                    child: TextField(
                      controller: _messageController,
                      onSubmitted: (value) {
                        _sendMessage(); // Send the message when Enter is pressed
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
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 8),
                      ),
                    ),
                  ),
                  // Audio or Send button
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
        currentIndex: 2, // Highlight the Chat tab
      ),
    );
  }

  /// Helper method to build chat bubbles for text messages
  Widget _buildChatBubble(String message) {
    return Align(
      alignment: Alignment.centerRight, // Align messages to the right
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFF17A2B8), // Match the app's theme color
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

  /// Helper method to build chat bubbles for images
  Widget _buildImageBubble(String imagePath) {
    final File imageFile = File(imagePath);
    final Uint8List imageBytes = imageFile.readAsBytesSync(); // Read the image as bytes

    return Align(
      alignment: Alignment.centerRight, // Align images to the right
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
}