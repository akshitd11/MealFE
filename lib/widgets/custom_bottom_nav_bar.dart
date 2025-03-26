import 'package:flutter/material.dart';
import 'package:meal_ui/screens/chat_screen.dart';
import 'package:meal_ui/screens/profile_screen.dart';
import 'package:meal_ui/screens/dashboard_screen.dart';
import 'package:meal_ui/screens/welcome_screen.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex; // To highlight the active tab

  const CustomBottomNavBar({
    Key? key,
    required this.currentIndex,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: const Color(0xFFE8F9F4),
      selectedItemColor: const Color(0xFF17A2B8),
      unselectedItemColor: Colors.grey,
      currentIndex: currentIndex,
      onTap: (index) {
        // Handle navigation based on the selected index
        if (index == currentIndex) return; // Prevent unnecessary navigation

        switch (index) {
          case 0:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
            break;
          case 1:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const DashboardScreen()),
            );
            break;
          case 2:
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ChatScreen()),
            );
            break;
        }
      },
      items: const [
        BottomNavigationBarItem(
          icon: Icon(Icons.book),
          label: 'Profile',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.pie_chart),
          label: 'Dashboard',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.bar_chart),
          label: 'Journal',
        ),
      ],
    );
  }
}