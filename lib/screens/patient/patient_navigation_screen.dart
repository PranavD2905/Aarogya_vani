import 'package:flutter/material.dart';
import 'home_screen.dart';
import 'appointment_history_screen.dart';
import 'prescription_screen.dart';
import 'profile_screen.dart';
import '../../models/patient_profile.dart';

class PatientNavigationScreen extends StatefulWidget {
  const PatientNavigationScreen({Key? key}) : super(key: key);

  @override
  State<PatientNavigationScreen> createState() =>
      _PatientNavigationScreenState();
}

class _PatientNavigationScreenState extends State<PatientNavigationScreen> {
  int _currentIndex = 0;
  late final List<Widget> _screens;

  @override
  void initState() {
    super.initState();

    // Provide a placeholder PatientProfile until real data is loaded.
    // This avoids a missing required parameter error when constructing ProfileScreen.
    _screens = [
      const HomeScreen(),
      const AppointmentHistoryScreen(),
      const PrescriptionScreen(),
      ProfileScreen(
        profile: PatientProfile(
          id: '',
          name: 'Your Name',
          photoUrl: '',
          dateOfBirth: DateTime(2000, 1, 1),
          bloodGroup: '',
          sex: '',
          phoneNumber: '',
          email: '',
          address: '',
        ),
      ),
    ];
  }

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
