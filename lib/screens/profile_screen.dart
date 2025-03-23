import 'package:flutter/material.dart';
import 'package:meal_ui/screens/me_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
        title: const Text(
          'Profile',
          style: TextStyle(color: Colors.black),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          const SizedBox(height: 20),
          // Profile Picture and Name
          Center(
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: const NetworkImage(
                      'https://via.placeholder.com/150'), // Replace with user image
                  backgroundColor: Colors.grey[200],
                ),
                const SizedBox(height: 10),
                const Text(
                  'Micky',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),
                const Text(
                  'micksenpai@gmail.com',
                  style: TextStyle(fontSize: 16, color: Colors.green),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          // Options
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              children: [
                _buildOptionTile(
                  title: 'Me',
                  trailing: const Icon(Icons.arrow_forward_ios, color: Colors.white),
                  backgroundColor: Colors.green,
                  onTap: () {
                    Navigator.push( 
                      context,
                      MaterialPageRoute(builder: (context) => const MeScreen()),
                    );
                  },
                ),
                _buildOptionTile(
                  title: 'Calorie Intake',
                  trailing: const Text(
                    '3400 Cal',
                    style: TextStyle(color: Colors.green, fontSize: 16),
                  ),
                  backgroundColor: Colors.green[50] ?? Colors.green,
                  onTap: () {
                    // Add functionality for "Calorie Intake"
                  },
                ),
                _buildOptionTile(
                  title: 'Weight Unit',
                  trailing: const Text(
                    'Kilograms',
                    style: TextStyle(color: Colors.green, fontSize: 16),
                  ),
                  backgroundColor:  Colors.green[50] ?? Colors.green,
                  onTap: () {
                    // Add functionality for "Weight Unit"
                  },
                ),
                const Divider(height: 40),                
                // Contact Us
                ListTile(
                  leading: const Icon(Icons.email, color: Colors.green),
                  title: const Text('Contact us'),
                  onTap: () {
                    // Add functionality for "Contact us"
                  },
                ),
                // About App
                ListTile(
                  leading: const Icon(Icons.info, color: Colors.green),
                  title: const Text('About app'),
                  onTap: () {
                    // Add functionality for "About app"
                  },
                ),
                // Settings
                ListTile(
                  leading: const Icon(Icons.settings, color: Colors.green),
                  title: const Text('Settings'),
                  onTap: () {
                    // Add functionality for "Settings"
                  },
                ),
                // Logout
                ListTile(
                  leading: const Icon(Icons.logout, color: Colors.red),
                  title: const Text(
                    'Logout',
                    style: TextStyle(color: Colors.red),
                  ),
                  onTap: () {
                    // Add functionality for "Logout"
                  },
                ),
              ],
            ),
          ),
          // Version
          const Padding(
            padding: EdgeInsets.only(bottom: 16),
            child: Text(
              'Version: 0.0.6',
              style: TextStyle(color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  /// Helper method to build option tiles
  Widget _buildOptionTile({
    required String title,
    required Widget trailing,
    required Color backgroundColor,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 10),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              title,
              style: TextStyle(
                fontSize: 16,
                color: backgroundColor == Colors.green ? Colors.white : Colors.black,
              ),
            ),
            trailing,
          ],
        ),
      ),
    );
  }
}