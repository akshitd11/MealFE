import 'package:flutter/material.dart';

class AgeScreen extends StatefulWidget {
  const AgeScreen({Key? key}) : super(key: key);

  @override
  _AgeScreenState createState() => _AgeScreenState();
}

class _AgeScreenState extends State<AgeScreen> {
  /// For age: allow 1..120 years.
  int _selectedAge = 25; // default

  /// Dimensions used for the ListWheelScrollView picker.
  final double _pickerHeight = 150;
  final double _itemExtent = 50;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.only(top: 30.0, left: 16.0, right: 16.0, bottom: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            const Text(
              'What is your age?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your age helps us personalize your\n'
              'health recommendations',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const Spacer(),
            /// Age picker
            _buildAgePicker(),
            const Spacer(), 
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 25),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text(
                "Back",
                style: TextStyle(color: Colors.grey, fontSize: 16),
              ),
            ),
            FloatingActionButton(
              onPressed: () {
                // Navigation or other functionality here.
              },
              backgroundColor: const Color(0xFF17A2B8),
              shape: const CircleBorder(),
              child: const Icon(Icons.arrow_forward, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  /// Builds a single wheel picker for age, 1..120.
  Widget _buildAgePicker() {
    return Column(
      children: [
        Center( // Ensures the picker is centered
          child: SizedBox(
            width: 80,
            height: _pickerHeight,
            child: Stack(
              children: [
                _buildGreenHighlightLines(),
                ListWheelScrollView.useDelegate(
                  itemExtent: _itemExtent,
                  perspective: 0.003,
                  diameterRatio: 2.0,
                  physics: const FixedExtentScrollPhysics(),
                  magnification: 1.2,
                  useMagnifier: true,
                  onSelectedItemChanged: (index) {
                    setState(() {
                      // Ensure the range is 1..120
                      _selectedAge = 1 + index;
                    });
                  },
                  childDelegate: ListWheelChildBuilderDelegate(
                    builder: (context, index) {
                      final ageValue = 1 + index;
                      if (ageValue > 100) return null;
                      return Center(
                        child: Text(
                          '$ageValue',
                          style: const TextStyle(fontSize: 20),
                        ),
                      );
                    },
                    childCount: 120, // 1 to 120 inclusive
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        Text('Selected: $_selectedAge years', style: const TextStyle(fontSize: 16)),
      ],
    );
  }

  /// Builds two horizontal green lines that highlight the center item.
  Widget _buildGreenHighlightLines() {
    return Stack(
      children: [
        Positioned(
          left: 0,
          right: 0,
          top: (_pickerHeight / 2) - (_itemExtent / 2),
          child: Container(height: 2, color: Colors.green),
        ),
        Positioned(
          left: 0,
          right: 0,
          top: (_pickerHeight / 2) + (_itemExtent / 2),
          child: Container(height: 2, color: Colors.green),
        ),
      ],
    );
  }
}