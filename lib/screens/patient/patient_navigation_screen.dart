import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'appointment_history_screen.dart';
import 'prescription_screen.dart';
import 'profile_screen.dart';

class PatientNavigationScreen extends StatefulWidget {
  const PatientNavigationScreen({Key? key}) : super(key: key);

  @override
  State<PatientNavigationScreen> createState() =>
      _PatientNavigationScreenState();
}

class _PatientNavigationScreenState extends State<PatientNavigationScreen> {
  int _currentIndex = 0;

  final List<Widget> _screens = [
    const HomeScreen(),
    const AppointmentHistoryScreen(),
    const PrescriptionScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _screens[_currentIndex],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _currentIndex,
        onTap: (index) {
          setState(() {
            _currentIndex = index;
          });
        },
        type: BottomNavigationBarType.fixed,
        items: const [
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(
            icon: Icon(Icons.history),
            label: 'Appointments',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.receipt),
            label: 'Prescription',
          ),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
