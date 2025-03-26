import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ResetPasswordScreen extends StatefulWidget {
  const ResetPasswordScreen({Key? key}) : super(key: key);

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final FocusNode _codeFocusNode = FocusNode();
  final FocusNode _newPasswordFocusNode = FocusNode();
  final FocusNode _repeatPasswordFocusNode = FocusNode();
  bool _isCodeFocused = false;
  bool _isNewPasswordFocused = false;
  bool _isRepeatPasswordFocused = false;
  bool _isNewPasswordVisible = false;
  bool _isRepeatPasswordVisible = false;

  final int otpLength = 6;
  late List<TextEditingController> controllers;
  late List<FocusNode> focusNodes;

  @override
  void initState() {
    super.initState();
    controllers = List.generate(
      otpLength,
      (_) => TextEditingController(),
    );
    focusNodes = List.generate(
      otpLength,
      (_) => FocusNode(),
    );
    _codeFocusNode.addListener(_onCodeFocusChange);
    _newPasswordFocusNode.addListener(_onNewPasswordFocusChange);
    _repeatPasswordFocusNode.addListener(_onRepeatPasswordFocusChange);
  }

  void _onCodeFocusChange() {
    setState(() {
      _isCodeFocused = _codeFocusNode.hasFocus;
    });
  }

  void _onNewPasswordFocusChange() {
    setState(() {
      _isNewPasswordFocused = _newPasswordFocusNode.hasFocus;
    });
  }

  void _onRepeatPasswordFocusChange() {
    setState(() {
      _isRepeatPasswordFocused = _repeatPasswordFocusNode.hasFocus;
    });
  }

  @override
  void dispose() {
    for (var controller in controllers) {
      controller.dispose();
    }
    for (var node in focusNodes) {
      node.dispose();
    }
    _codeFocusNode.removeListener(_onCodeFocusChange);
    _newPasswordFocusNode.removeListener(_onNewPasswordFocusChange);
    _repeatPasswordFocusNode.removeListener(_onRepeatPasswordFocusChange);
    _codeFocusNode.dispose();
    _newPasswordFocusNode.dispose();
    _repeatPasswordFocusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 70,
        titleSpacing: 16,
        title: const Text('Reset password'),
        backgroundColor: Colors.white,
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
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
                    const Text(
                      'Please enter the password reset code that we have sent to your email, micksenpai@gmail.com.',
                      style: TextStyle(color: Colors.grey, fontSize: 16),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: List.generate(
                        otpLength,
                        (index) => SizedBox(
                          width: 50,
                          height: 50,
                          child: RawKeyboardListener(
                            focusNode: FocusNode(),
                            onKey: (RawKeyEvent event) {
                              if (event is RawKeyDownEvent &&
                                  event.logicalKey == LogicalKeyboardKey.backspace &&
                                  controllers[index].text.isEmpty &&
                                  index > 0) {
                                controllers[index - 1].clear();
                                focusNodes[index - 1].requestFocus();
                              }
                            },
                            child: TextFormField(
                              controller: controllers[index],
                              focusNode: focusNodes[index],
                              keyboardType: TextInputType.number,
                              textAlign: TextAlign.center,
                              maxLength: 1,
                              decoration: InputDecoration(
                                counterText: "",
                                contentPadding: EdgeInsets.zero,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: Colors.grey),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(8),
                                  borderSide: BorderSide(color: Colors.green),
                                ),
                              ),
                              style: const TextStyle(fontSize: 20),
                              onChanged: (value) {
                                if (value.isNotEmpty) {
                                  if (index + 1 <= otpLength) {
                                    
                                    focusNodes[index + 1].requestFocus();
                                  } else {
                                    controllers[index].text = value[0];
                                    focusNodes[index].unfocus();
                                  }
                                }
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(height: 24),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        focusNode: _newPasswordFocusNode,
                        obscureText: !_isNewPasswordVisible,
                        decoration: InputDecoration(
                          labelText: 'New password',
                          labelStyle: TextStyle(color: _isNewPasswordFocused ? Colors.green : Colors.grey),
                          prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isNewPasswordVisible ? Icons.visibility : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _isNewPasswordVisible = !_isNewPasswordVisible;
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
                    const SizedBox(height: 16),
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(8),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: TextField(
                        focusNode: _repeatPasswordFocusNode,
                        obscureText: !_isRepeatPasswordVisible,
                        decoration: InputDecoration(
                          labelText: 'Repeat password',
                          labelStyle: TextStyle(color: _isRepeatPasswordFocused ? Colors.green : Colors.grey),
                          prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                          suffixIcon: IconButton(
                            icon: Icon(
                              _isRepeatPasswordVisible ? Icons.visibility : Icons.visibility_off,
                              color: Colors.grey,
                            ),
                            onPressed: () {
                              setState(() {
                                _isRepeatPasswordVisible = !_isRepeatPasswordVisible;
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
            Column(
              children: [
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      // Handle reset password action
                      print('Reset button pressed');
                    },
                    style: ElevatedButton.styleFrom(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      backgroundColor: const Color(0xFF17A2B8),
                    ),
                    child: const Text(
                      'Reset',
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