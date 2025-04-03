import 'package:flutter/material.dart';

class MeScreen extends StatefulWidget {
  const MeScreen({Key? key}) : super(key: key);

  @override
  _MeScreenState createState() => _MeScreenState();
}

class _MeScreenState extends State<MeScreen> {
  // Sample initial data
  int _age = 17;
  int _heightCm = 184;
  int _heightFt = 6;
  int _heightIn = 0;
  int _weightKg = 88;
  int _weightLbs = 194;
  String _sex = "Male";
  String _lifestyle = "Active";
  String _goal = "Gain weight";
  String _heightUnit = "cm"; // cm or ft/in
  String _weightUnit = "kg"; // kg or lbs

  // ------------------------------------------
  // Generic Bottom Sheet for Goal and Lifestyle
  // ------------------------------------------
  void _showOptionsBottomSheet({
    required String title,
    required List<String> options,
    required String currentValue,
    required Function(String) onSelected,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        String tempSelectedValue = currentValue;

        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 8),
                  // --- Draggable handle ---
                  Center(
                    child: Container(
                      width: 40,
                      height: 5,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(2.5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  // --- Title ---
                  Text(
                    title,
                    style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  // --- Options ---
                  ...options.map((option) {
                    bool isSelected = (tempSelectedValue == option);
                    return GestureDetector(
                      onTap: () {
                        setModalState(() {
                          tempSelectedValue = option;
                        });
                      },
                      child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 24, vertical: 6),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        decoration: BoxDecoration(
                          color: isSelected ? Colors.green[50] : Colors.white,
                          border: Border.all(
                            color: isSelected ? Colors.green : Colors.grey[300]!,
                          ),
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Center(
                          child: Text(
                            option,
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                              color: isSelected ? Colors.green[800] : Colors.black87,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                  const SizedBox(height: 16),
                  // --- Done button ---
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      onPressed: () {
                        onSelected(tempSelectedValue);
                        Navigator.pop(context);
                      },
                      child: const Text(
                        "Done",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ------------------------------------------
  // Bottom sheet for editing Height
  // ------------------------------------------
  void _showHeightBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    "Height",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  // Unit Selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setModalState(() {
                            _heightUnit = "cm";
                          });
                        },
                        child: Text(
                          "cm",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _heightUnit == "cm" ? Colors.green : Colors.grey,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: () {
                          setModalState(() {
                            _heightUnit = "ft/in";
                          });
                        },
                        child: Text(
                          "ft/in",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _heightUnit == "ft/in" ? Colors.green : Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Scale Selector with Green Lines
                  Stack(
                    children: [
                      if (_heightUnit == "cm")
                        SizedBox(
                          height: 150,
                          child: Stack(
                            children: [
                              // Green Highlight Lines
                              Positioned(
                                left: MediaQuery.of(context).size.width * 0.4,
                                right: MediaQuery.of(context).size.width * 0.4,
                                top: 50, // Adjusted to create more space
                                child: Container(height: 2, color: Colors.green),
                              ),
                              Positioned(
                                left: MediaQuery.of(context).size.width * 0.4,
                                right: MediaQuery.of(context).size.width * 0.4,
                                top: 100, // Adjusted to create more space
                                child: Container(height: 2, color: Colors.green),
                              ),
                              // ListWheelScrollView for cm
                              ListWheelScrollView.useDelegate(
                                itemExtent: 50,
                                physics: const FixedExtentScrollPhysics(),
                                onSelectedItemChanged: (index) {
                                  setModalState(() {
                                    _heightCm = 100 + index; // Range: 100-250 cm
                                  });
                                },
                                childDelegate: ListWheelChildBuilderDelegate(
                                  builder: (context, index) {
                                    return Center(
                                      child: Text(
                                        "${100 + index} cm",
                                        style: const TextStyle(fontSize: 16),
                                      ),
                                    );
                                  },
                                  childCount: 151, // 100 to 250 inclusive
                                ),
                              ),
                            ],
                          ),
                        )
                      else
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            // Feet Selector
                            SizedBox(
                              width: 100,
                              height: 150,
                              child: Stack(
                                children: [
                                  // Green Highlight Lines
                                  Positioned(
                                    left: 0,
                                    right: 0,
                                    top: 50, // Adjusted to create more space
                                    child: Container(height: 2, color: Colors.green),
                                  ),
                                  Positioned(
                                    left: 0,
                                    right: 0,
                                    top: 100, // Adjusted to create more space
                                    child: Container(height: 2, color: Colors.green),
                                  ),
                                  // ListWheelScrollView for feet
                                  ListWheelScrollView.useDelegate(
                                    itemExtent: 50,
                                    physics: const FixedExtentScrollPhysics(),
                                    onSelectedItemChanged: (index) {
                                      setModalState(() {
                                        _heightFt = 3 + index; // Range: 3-8 ft
                                      });
                                    },
                                    childDelegate: ListWheelChildBuilderDelegate(
                                      builder: (context, index) {
                                        return Center(
                                          child: Text(
                                            "${3 + index} ft",
                                            style: const TextStyle(fontSize: 16),
                                          ),
                                        );
                                      },
                                      childCount: 6, // 3 to 8 inclusive
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Inches Selector
                            SizedBox(
                              width: 100,
                              height: 150,
                              child: Stack(
                                children: [
                                  // Green Highlight Lines
                                  Positioned(
                                    left: 0,
                                    right: 0,
                                    top: 50, // Adjusted to create more space
                                    child: Container(height: 2, color: Colors.green),
                                  ),
                                  Positioned(
                                    left: 0,
                                    right: 0,
                                    top: 100, // Adjusted to create more space
                                    child: Container(height: 2, color: Colors.green),
                                  ),
                                  // ListWheelScrollView for inches
                                  ListWheelScrollView.useDelegate(
                                    itemExtent: 50,
                                    physics: const FixedExtentScrollPhysics(),
                                    onSelectedItemChanged: (index) {
                                      setModalState(() {
                                        _heightIn = index; // Range: 0-11 in
                                      });
                                    },
                                    childDelegate: ListWheelChildBuilderDelegate(
                                      builder: (context, index) {
                                        return Center(
                                          child: Text(
                                            "$index in",
                                            style: const TextStyle(fontSize: 16),
                                          ),
                                        );
                                      },
                                      childCount: 12, // 0 to 11 inclusive
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          // Save the selected height
                        });
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Done",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ------------------------------------------
  // Bottom sheet for editing Weight
  // ------------------------------------------
  void _showWeightBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (BuildContext context, StateSetter setModalState) {
            return Padding(
              padding: EdgeInsets.only(
                bottom: MediaQuery.of(context).viewInsets.bottom,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 16),
                  const Text(
                    "Weight",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 16),
                  // Unit Selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      GestureDetector(
                        onTap: () {
                          setModalState(() {
                            _weightUnit = "kg";
                          });
                        },
                        child: Text(
                          "kg",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _weightUnit == "kg" ? Colors.green : Colors.grey,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      GestureDetector(
                        onTap: () {
                          setModalState(() {
                            _weightUnit = "lbs";
                          });
                        },
                        child: Text(
                          "lbs",
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _weightUnit == "lbs" ? Colors.green : Colors.grey,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  // Scale Selector with Green Lines
                  Stack(
                    children: [
                      if (_weightUnit == "kg")
                        SizedBox(
                          height: 150,
                          child: ListWheelScrollView.useDelegate(
                            itemExtent: 50,
                            physics: const FixedExtentScrollPhysics(),
                            onSelectedItemChanged: (index) {
                              setModalState(() {
                                _weightKg = 30 + index; // Range: 30-200 kg
                              });
                            },
                            childDelegate: ListWheelChildBuilderDelegate(
                              builder: (context, index) {
                                return Center(
                                  child: Text(
                                    "${30 + index} kg",
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                );
                              },
                              childCount: 171, // 30 to 200 inclusive
                            ),
                          ),
                        )
                      else
                        SizedBox(
                          height: 150,
                          child: ListWheelScrollView.useDelegate(
                            itemExtent: 50,
                            physics: const FixedExtentScrollPhysics(),
                            onSelectedItemChanged: (index) {
                              setModalState(() {
                                _weightLbs = 66 + index; // Range: 66-440 lbs
                              });
                            },
                            childDelegate: ListWheelChildBuilderDelegate(
                              builder: (context, index) {
                                return Center(
                                  child: Text(
                                    "${66 + index} lbs",
                                    style: const TextStyle(fontSize: 16),
                                  ),
                                );
                              },
                              childCount: 375, // 66 to 440 inclusive
                            ),
                          ),
                        ),
                      // Green Lines
                      Positioned(
                        top: 50, // Position above the selected item
                        left: MediaQuery.of(context).size.width * 0.4, // Reduced width
                        right: MediaQuery.of(context).size.width * 0.4,
                        child: Container(
                          height: 2,
                          color: Colors.green,
                        ),
                      ),
                      Positioned(
                        top: 100, // Position below the selected item
                        left: MediaQuery.of(context).size.width * 0.4, // Reduced width
                        right: MediaQuery.of(context).size.width * 0.4,
                        child: Container(
                          height: 2,
                          color: Colors.green,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 16),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 24),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          // Save the selected weight
                        });
                        Navigator.pop(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        minimumSize: const Size.fromHeight(48),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        "Done",
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                ],
              ),
            );
          },
        );
      },
    );
  }

  // ------------------------------------------
  // Build the main profile screen
  // ------------------------------------------
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Me")),
      body: Column(
        children: [
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildInfoTile(
                  title: 'Goal',
                  value: _goal,
                  onTap: () {
                    _showOptionsBottomSheet(
                      title: 'Goal',
                      options: ["Lose weight", "Keep weight", "Gain weight"],
                      currentValue: _goal,
                      onSelected: (newValue) {
                        setState(() {
                          _goal = newValue;
                        });
                      },
                    );
                  },
                ),
                _buildInfoTile(
                  title: 'Age',
                  value: '$_age years',
                  onTap: _showAgeBottomSheet,
                ),
                _buildInfoTile(
                  title: 'Height',
                  value: _heightUnit == "cm"
                      ? "$_heightCm cm"
                      : "$_heightFt ft $_heightIn in",
                  onTap: _showHeightBottomSheet,
                ),
                _buildInfoTile(
                  title: 'Weight',
                  value: _weightUnit == "kg" ? "$_weightKg kg" : "$_weightLbs lbs",
                  onTap: _showWeightBottomSheet,
                ),
                _buildInfoTile(
                  title: 'Gender',
                  value: _sex,
                  onTap: _showSexBottomSheet,
                ),
                _buildInfoTile(
                  title: 'Lifestyle',
                  value: _lifestyle,
                  onTap: () {
                    _showOptionsBottomSheet(
                      title: 'Lifestyle',
                      options: [
                        "Sedentary",
                        "Lightly Active",
                        "Active",
                        "Very Active",
                      ],
                      currentValue: _lifestyle,
                      onSelected: (newValue) {
                        setState(() {
                          _lifestyle = newValue;
                        });
                      },
                    );
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton(
                onPressed: () {
                  // Add functionality for saving changes
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(fontSize: 16, color: Colors.white),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  /// Helper method to build information tiles
  Widget _buildInfoTile({
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        margin: const EdgeInsets.only(bottom: 10),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.grey, width: 0.5)),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: const TextStyle(fontSize: 16, color: Colors.black),
            ),
            Text(
              value,
              style: const TextStyle(fontSize: 16, color: Colors.green),
            ),
          ],
        ),
      ),
    );
  }

  // ------------------------------------------
  // Bottom sheet for editing Age
  // ------------------------------------------
  void _showAgeBottomSheet() {
    final TextEditingController ageController = TextEditingController(
      text: _age.toString(),
    );

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (BuildContext context) {
        return Padding(
          padding: EdgeInsets.only(
            bottom: MediaQuery.of(context).viewInsets.bottom,
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 16),
              const Text(
                "Age",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 8,
                ),
                child: TextField(
                  controller: ageController,
                  keyboardType: TextInputType.number,
                  decoration: const InputDecoration(
                    labelText: "Years",
                    border: OutlineInputBorder(),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 24),
                child: ElevatedButton(
                  onPressed: () {
                    setState(() {
                      _age = int.tryParse(ageController.text) ?? _age;
                    });
                    Navigator.pop(context);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    minimumSize: const Size.fromHeight(48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  child: const Text(
                    "Done",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        );
      },
    );
  }

  // ------------------------------------------
  // Bottom sheet for editing Gender
  // ------------------------------------------
  void _showSexBottomSheet() {
    _showOptionsBottomSheet(
      title: 'Sex',
      options: ["Male", "Female"],
      currentValue: _sex,
      onSelected: (newValue) {
        setState(() {
          _sex = newValue;
        });
      },
    );
  }
}
