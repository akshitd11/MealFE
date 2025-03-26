import 'package:flutter/material.dart';
import 'package:meal_ui/screens/profile_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:meal_ui/services/api_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({Key? key}) : super(key: key);

  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final FocusNode _nameFocusNode = FocusNode();
  final FocusNode _emailFocusNode = FocusNode();
  final FocusNode _passwordFocusNode = FocusNode();
  bool _isNameFocused = false;
  bool _isEmailFocused = false;
  bool _isPasswordFocused = false;
  bool _isPasswordVisible = false;

  File? _selectedImage; // To store the selected image

  // Variables to store user input
  String _name = '';
  String _email = '';
  String _password = '';

  @override
  void initState() {
    super.initState();
    _nameFocusNode.addListener(_onNameFocusChange);
    _emailFocusNode.addListener(_onEmailFocusChange);
    _passwordFocusNode.addListener(_onPasswordFocusChange);
  }

  void _onNameFocusChange() {
    setState(() {
      _isNameFocused = _nameFocusNode.hasFocus;
    });
  }

  void _onEmailFocusChange() {
    setState(() {
      _isEmailFocused = _emailFocusNode.hasFocus;
    });
  }

  void _onPasswordFocusChange() {
    setState(() {
      _isPasswordFocused = _passwordFocusNode.hasFocus;
    });
  }

  Future<void> _pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? image = await picker.pickImage(source: ImageSource.gallery);

    if (image != null) {
      setState(() {
        _selectedImage = File(image.path); // Store the selected image
      });
    }
  }

  Future<void> _registerUser() async {
    if (_name.isEmpty || _email.isEmpty || _password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please fill in all fields'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    if (!_isValidEmail(_email)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please enter a valid email address'),
          backgroundColor: Colors.red,
        ),
      );
      return;
    }

    try {
      final response = await ApiService.registerUser(
        name: _name,
        email: _email,
        password: _password,
      );

      // Extract the token from the response
      final token = response['access_token'];

      // Save the token in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('auth_token', token);

      // Navigate to the next page
      print('Registration successful: $response');
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => const ProfileScreen()),
      );
    } catch (error) {
      // Display only the error message without "Exception: "
      final errorMessage = error.toString().replaceAll('Exception: ', '');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(errorMessage),
          backgroundColor: Colors.red,
        ),
      );
      print('Registration failed: $errorMessage');
    }
  }

  bool _isValidEmail(String email) {
    final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');
    return emailRegex.hasMatch(email);
  }

  @override
  void dispose() {
    _nameFocusNode.removeListener(_onNameFocusChange);
    _emailFocusNode.removeListener(_onEmailFocusChange);
    _passwordFocusNode.removeListener(_onPasswordFocusChange);
    _nameFocusNode.dispose();
    _emailFocusNode.dispose();
    _passwordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 70,
        titleSpacing: 16,
        title: const Text('Register'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        backgroundColor: Colors.white,
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Expanded(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(
                          radius: 75,
                          backgroundImage: _selectedImage != null
                              ? FileImage(_selectedImage!) // Display selected image
                              : const NetworkImage(
                                  'https://via.placeholder.com/150',
                                ) as ImageProvider, // Default placeholder
                          backgroundColor: Colors.grey[200],
                        ),
                        FloatingActionButton(
                          onPressed: _pickImage, // Open file explorer
                          mini: true,
                          backgroundColor: const Color(0xFF17A2B8),
                          child: const Icon(Icons.camera_alt, color: Colors.white),
                        ),
                      ],
                    ),
Spacer(),
Spacer(),
                    const SizedBox(height: 25),
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        onChanged: (value) => _name = value, // Capture name input
                        focusNode: _nameFocusNode,
                        decoration: InputDecoration(
                          labelText: 'Name',
                          labelStyle: TextStyle(color: _isNameFocused ? Colors.green : Colors.grey),
                          prefixIcon: const Icon(Icons.person, color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.green),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        ),
                        style: const TextStyle(color: Colors.black),
                        cursorColor: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 25),
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        onChanged: (value) => _email = value, // Capture email input
                        focusNode: _emailFocusNode,
                        decoration: InputDecoration(
                          labelText: 'Email',
                          labelStyle: TextStyle(color: _isEmailFocused ? Colors.green : Colors.grey),
                          prefixIcon: const Icon(Icons.email, color: Colors.grey),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.green),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        ),
                        style: const TextStyle(color: Colors.black),
                        cursorColor: Colors.green,
                      ),
                    ),
                    const SizedBox(height: 25),
                    Container(
                      height: 50,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            spreadRadius: 1,
                            blurRadius: 3,
                            offset: const Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        onChanged: (value) => _password = value, // Capture password input
                        focusNode: _passwordFocusNode,
                        obscureText: !_isPasswordVisible,
                        decoration: InputDecoration(
                          labelText: 'Password',
                          labelStyle: TextStyle(color: _isPasswordFocused ? Colors.green : Colors.grey),
                          prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _isPasswordVisible = !_isPasswordVisible;
                              });
                            },
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: BorderSide.none,
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8),
                            borderSide: const BorderSide(color: Colors.green),
                          ),
                          contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                        ),
                        style: const TextStyle(color: Colors.black),
                        cursorColor: Colors.green,
                      ),
                    ),
                  ],
                ),
              ),
            ),
Spacer(),
            Column(
              children: [
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  _registerUser();
                },
                style: ElevatedButton.styleFrom(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  backgroundColor: const Color(0xFF17A2B8),
                ),
                child: const Text(
                  'Register',
                  style: TextStyle(fontSize: 18),
                ),
              ),
),
              ],
            ),
          ],
        ),
      ),
    );
  }
}