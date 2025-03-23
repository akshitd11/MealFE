import 'package:flutter/material.dart';
import 'package:meal_ui/screens/weight_screen.dart';

class HeightScreen extends StatefulWidget {
  const HeightScreen({Key? key}) : super(key: key);

  @override
  _HeightScreenState createState() => _HeightScreenState();
}

class _HeightScreenState extends State<HeightScreen> {
  /// Currently selected unit: 'cm' or 'ft'
  String _selectedUnit = 'cm';

  /// For centimeters: allow 100..274 cm.
  int _selectedCm = 170; // default

  /// For feet/inches: allow 3..9 ft and 0..11 in.
  int _selectedFt = 5; // default
  int _selectedIn = 6; // default

  /// Dimensions used for the ListWheelScrollView pickers.
  final double _pickerHeight = 150;
  final double _itemExtent = 50;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      // Use the same outer padding as in the first code.
      body: Padding(
        padding:
            const EdgeInsets.only(top: 30.0, left: 16.0, right: 16.0, bottom: 16.0),
        child: Column(
          children: [
            const SizedBox(height: 16),
            const Text(
              'How tall are you?',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'The taller you are, the more calories\n'
              'your body needs',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            const Spacer(),

            /// Unit selection by tapping labels
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                _buildUnitLabel('cm'),
                const SizedBox(width: 16),
                _buildUnitLabel('ft'), // Labeled as "ft/in"
              ],
            ),
            const SizedBox(height: 24),

            /// Show either the cm picker or the ft/in pickers
            if (_selectedUnit == 'cm')
              _buildCmPicker()
            else
              _buildFtInPicker(),
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
                    MaterialPageRoute(builder: (context) => const WeightScreen()),
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

  /// Builds the label for a unit ("cm" or "ft/in") that toggles selection on tap.
  Widget _buildUnitLabel(String unit) {
    final bool isActive = _selectedUnit == unit;
    return GestureDetector(
      onTap: () => setState(() => _selectedUnit = unit),
      child: Text(
        unit == 'ft' ? 'ft/in' : unit, // Display "ft/in" instead of just "ft"
        style: TextStyle(
          fontSize: 18,
          color: isActive ? Colors.green : Colors.black,
          fontWeight: isActive ? FontWeight.bold : FontWeight.normal,
        ),
      ),
    );
  }

  /// Builds a single wheel picker for centimeters, 100..274.
  Widget _buildCmPicker() {
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
                    // Ensure the range is 100..274
                    _selectedCm = 100 + index;
                  });
                },
                childDelegate: ListWheelChildBuilderDelegate(
                  builder: (context, index) {
                    final cmValue = 100 + index;
                    if (cmValue > 274) return null;
                    return Center(
                      child: Text(
                        '$cmValue',
                        style: const TextStyle(fontSize: 20),
                      ),
                    );
                  },
                  childCount: 175, // 100 to 274 inclusive
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text('Selected: $_selectedCm cm', style: const TextStyle(fontSize: 16)),
      ],
    );
  }

  /// Builds two wheel pickers side by side for feet (3..9) and inches (0..11).
  Widget _buildFtInPicker() {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Feet Picker
            SizedBox(
              width: 60,
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
                        _selectedFt = 3 + index;
                      });
                    },
                    childDelegate: ListWheelChildBuilderDelegate(
                      builder: (context, index) {
                        final ftValue = 3 + index;
                        if (ftValue > 9) return null;
                        return Center(
                          child: Text(
                            '$ftValue',
                            style: const TextStyle(fontSize: 20),
                          ),
                        );
                      },
                      childCount: 7, // 3 to 9 inclusive
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Text('ft', style: TextStyle(fontSize: 18)),
            const SizedBox(width: 24),
            // Inches Picker
            SizedBox(
              width: 60,
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
                        _selectedIn = index;
                      });
                    },
                    childDelegate: ListWheelChildBuilderDelegate(
                      builder: (context, index) {
                        if (index > 11) return null;
                        return Center(
                          child: Text(
                            '$index',
                            style: const TextStyle(fontSize: 20),
                          ),
                        );
                      },
                      childCount: 12, // 0 to 11 inclusive
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: 8),
            const Text('in', style: TextStyle(fontSize: 18)),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Selected: $_selectedFt ft $_selectedIn in',
          style: const TextStyle(fontSize: 16),
        ),
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
