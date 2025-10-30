import 'package:flutter/material.dart';
import 'doctor_home_screen.dart';
import 'doctor_inbox_screen.dart';
import 'doctor_patients_screen.dart';
import 'doctor_profile_screen.dart';

class DoctorNavigationScreen extends StatefulWidget {
  const DoctorNavigationScreen({Key? key}) : super(key: key);

  @override
  State<DoctorNavigationScreen> createState() => _DoctorNavigationScreenState();
}

class _DoctorNavigationScreenState extends State<DoctorNavigationScreen> {
  int _currentIndex = 0;
  final List<Widget> _screens = [
    const DoctorHomeScreen(),
    const DoctorInboxScreen(),
    const DoctorPatientsScreen(),
    const DoctorProfileScreen(),
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
          BottomNavigationBarItem(icon: Icon(Icons.dashboard), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.message), label: 'Inbox'),
          BottomNavigationBarItem(icon: Icon(Icons.people), label: 'Patients'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}
