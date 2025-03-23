import 'package:flutter/material.dart';
import 'package:meal_ui/screens/activity_screen.dart';

class GenderScreen extends StatefulWidget {
  const GenderScreen({Key? key}) : super(key: key);

  @override
  _GenderScreenState createState() => _GenderScreenState();
}

class _GenderScreenState extends State<GenderScreen> {
  String _selectedGoal = '';

  void _setSelectedGoal(String goal) {
    setState(() {
      _selectedGoal = goal;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding( 
        padding: const EdgeInsets.only(top: 30.0, left: 16.0, right: 16.0, bottom: 16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            const SizedBox(height: 16),
            const Text(
              "What's your gender?",
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text.rich(
              TextSpan(
                text: 'Male bodies need more calories\n',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 32),
            const Spacer(),
            Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _setSelectedGoal('Male'),
                    style: ButtonStyle(
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      backgroundColor: WidgetStateProperty .all(Colors.transparent),
                      side: WidgetStateProperty.resolveWith((states) {
                        if (_selectedGoal == 'Male') {
                          return const BorderSide(color: Colors.green);
                        }
                        return const BorderSide(color: Colors.transparent);
                      }),
                      overlayColor: WidgetStateProperty.all(Colors.transparent), // Remove overlay color
                      elevation: WidgetStateProperty.all(0), // Remove shadow
                    ),
                    child: const Text(
                      'Male',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () => _setSelectedGoal('Female'),
                    style: ButtonStyle(
                      shape: WidgetStateProperty.all(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      backgroundColor: WidgetStateProperty.all(Colors.transparent),
                      side: WidgetStateProperty.resolveWith((states) {
                        if (_selectedGoal == 'Female') {
                          return const BorderSide(color: Colors.green);
                        }
                        return const BorderSide(color: Colors.transparent);
                      }),
                      overlayColor: WidgetStateProperty.all(Colors.transparent), // Remove overlay color
                      elevation: WidgetStateProperty.all(0), // Remove shadow
                    ),
                    child: const Text(
                      'Female',
                      style: TextStyle(color: Colors.black, fontSize: 20),
                    ),
                  ),
                ),
               
              ],
            ),
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
                  MaterialPageRoute(builder: (context) => const ActivityScreen()),
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
}