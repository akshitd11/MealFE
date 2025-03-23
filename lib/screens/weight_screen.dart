import 'package:flutter/material.dart';
import 'package:meal_ui/screens/age_screen.dart';

class WeightScreen extends StatefulWidget {
  const WeightScreen({Key? key}) : super(key: key);

  @override
  _WeightScreenState createState() => _WeightScreenState();
}

class _WeightScreenState extends State<WeightScreen> {
  /// Currently selected unit: 'kg' or 'lbs'
  String _selectedUnit = 'kg';

  /// For kilograms: allow 30..200 kg.
  int _selectedKg = 70; // default

  /// For pounds: allow 66..440 lbs.
  int _selectedLbs = 154; // default

  /// Dimensions used for the ListWheelScrollView pickers.
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
              'What is your weight?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your weight helps us calculate your\n'
              'daily calorie needs',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const Spacer(),

            /// Unit selection by tapping labels
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildUnitLabel('kg'),
                const SizedBox(width: 16),
                _buildUnitLabel('lbs'),
              ],
            ),
            const SizedBox(height: 24),

            /// Show either the kg picker or the lbs picker
            if (_selectedUnit == 'kg')
              _buildKgPicker()
            else
              _buildLbsPicker(),
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
               Navigator.push(
                        context,
                        MaterialPageRoute(builder: (context) => const AgeScreen()),
                );
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

  /// Builds the label for a unit ("kg" or "lbs") that toggles selection on tap.
  Widget _buildUnitLabel(String unit) {
    final bool isActive = _selectedUnit == unit;
    return GestureDetector(
      onTap: () => setState(() => _selectedUnit = unit),
      child: Text(
        unit,
        style: TextStyle(
          fontSize: 18,
          color: isActive ? Colors.green : Colors.black,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  /// Builds a single wheel picker for kilograms, 30..200.
  Widget _buildKgPicker() {
    return Column(
      children: [
        SizedBox(
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
                    // Ensure the range is 30..200
                    _selectedKg = 30 + index;
                  });
                },
                childDelegate: ListWheelChildBuilderDelegate(
                  builder: (context, index) {
                    final kgValue = 30 + index;
                    if (kgValue > 200) return null;
                    return Center(
                      child: Text(
                        '$kgValue',
                        style: const TextStyle(fontSize: 20),
                      ),
                    );
                  },
                  childCount: 171, // 30 to 200 inclusive
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text('Selected: $_selectedKg kg', style: const TextStyle(fontSize: 16)),
      ],
    );
  }

  /// Builds a single wheel picker for pounds, 66..440.
  Widget _buildLbsPicker() {
    return Column(
      children: [
        SizedBox(
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
                    // Ensure the range is 66..440
                    _selectedLbs = 66 + index;
                  });
                },
                childDelegate: ListWheelChildBuilderDelegate(
                  builder: (context, index) {
                    final lbsValue = 66 + index;
                    if (lbsValue > 440) return null;
                    return Center(
                      child: Text(
                        '$lbsValue',
                        style: const TextStyle(fontSize: 20),
                      ),
                    );
                  },
                  childCount: 375, // 66 to 440 inclusive
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text('Selected: $_selectedLbs lbs', style: const TextStyle(fontSize: 16)),
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