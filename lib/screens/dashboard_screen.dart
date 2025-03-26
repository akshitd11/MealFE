import 'package:flutter/material.dart';
import 'package:meal_ui/widgets/custom_bottom_nav_bar.dart';
import 'profile_screen.dart'; // Ensure this file contains the ProfileScreen class definition

class DashboardScreen extends StatelessWidget {
  const DashboardScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                CircleAvatar(
                  radius: 20,
                  backgroundImage: const NetworkImage(
                      'https://via.placeholder.com/150'), // Replace with user image
                  backgroundColor: Colors.grey[200],
                ),
                const SizedBox(width: 10),
                const Text(
                  'Micky',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                const Text(
                  'Today',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(width: 10),
                IconButton(
                  icon: const Icon(Icons.calendar_today, color: Colors.green),
                  onPressed: () {
                    // Add calendar functionality here
                  },
                ),
              ],
            ),
          ],
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Nutrients Indicator',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(12),
              ),
              child: Column(
                children: [
                  _buildNutrientRow(
                    label: 'Proteins',
                    current: 150,
                    total: 225,
                    color: Colors.red,
                  ),
                  const SizedBox(height: 10),
                  _buildNutrientRow(
                    label: 'Fats',
                    current: 30,
                    total: 118,
                    color: Colors.orange,
                  ),
                  const SizedBox(height: 10),
                  _buildNutrientRow(
                    label: 'Carbs',
                    current: 319,
                    total: 340,
                    color: Colors.green,
                  ),
                  const SizedBox(height: 20),
                  _buildNutrientRow(
                    label: 'Calories',
                    current: 2456,
                    total: 3400,
                    color: Colors.green,
                    isWide: true,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CustomBottomNavBar(
        currentIndex: 1, // Highlight the Dashboard tab
      ),
    );
  }

  Widget _buildNutrientRow({
    required String label,
    required int current,
    required int total,
    required Color color,
    bool isWide = false,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              '$current / $total',
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                color: Colors.black,
              ),
            ),
          ],
        ),
        const SizedBox(height: 5),
        LinearProgressIndicator(
          value: current / total,
          backgroundColor: Colors.grey[300],
          color: color,
          minHeight: isWide ? 8 : 5,
        ),
      ],
    );
  }
}