import 'package:flutter/material.dart';
import '../../constants/colors.dart';
import '../../models/doctor.dart';
import 'book_appointment_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController _searchController = TextEditingController();
  int _pressedIndex = -1;
  List<Doctor> doctors = [
    Doctor(
      id: 'doc1',
      name: 'Dr. John Doe',
      specialization: 'Cardiologist',
      rating: 4.5,
      imageUrl: 'assets/images/doctor1.png',
    ),
    Doctor(
      id: 'doc2',
      name: 'Dr. Jane Smith',
      specialization: 'Pediatrician',
      rating: 4.8,
      imageUrl: 'assets/images/doctor2.png',
    ),
    Doctor(
      id: 'doc3',
      name: 'Dr. Sarah Wilson',
      specialization: 'Dermatologist',
      rating: 4.7,
      imageUrl: 'assets/images/doctor3.png',
    ),
    Doctor(
      id: 'doc4',
      name: 'Dr. Michael Chen',
      specialization: 'Neurologist',
      rating: 4.9,
      imageUrl: 'assets/images/doctor4.png',
    ),
    // Add more doctors as needed
  ];

  List<Doctor> filteredDoctors = [];

  @override
  void initState() {
    super.initState();
    filteredDoctors = doctors;
  }

  void _filterDoctors(String query) {
    setState(() {
      filteredDoctors = doctors
          .where(
            (doctor) =>
                doctor.name.toLowerCase().contains(query.toLowerCase()) ||
                doctor.specialization.toLowerCase().contains(
                  query.toLowerCase(),
                ),
          )
          .toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Search Bar
              TextField(
                controller: _searchController,
                onChanged: _filterDoctors,
                decoration: InputDecoration(
                  hintText: 'Search doctors...',
                  prefixIcon: const Icon(Icons.search),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  filled: true,
                  fillColor: Colors.grey[100],
                ),
              ),
              const SizedBox(height: 20),
              // Doctors List
              Expanded(
                child: ListView.builder(
                  itemCount: filteredDoctors.length,
                  itemBuilder: (context, index) {
                    final doctor = filteredDoctors[index];
                    return Card(
                      margin: const EdgeInsets.only(bottom: 16),
                      elevation: 2,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Row(
                          children: [
                            // Doctor Image
                            CircleAvatar(
                              radius: 30,
                              backgroundImage: AssetImage(doctor.imageUrl),
                              onBackgroundImageError: (_, __) {
                                // Fallback for image load errors
                              },
                              child: Icon(
                                Icons.person,
                                size: 40,
                                color: Colors.grey[400],
                              ),
                            ),
                            const SizedBox(width: 16),
                            // Doctor Info
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    doctor.name,
                                    style: const TextStyle(
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                  const SizedBox(height: 4),
                                  Text(
                                    doctor.specialization,
                                    style: TextStyle(color: Colors.grey[600]),
                                  ),
                                  const SizedBox(height: 4),
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.star,
                                        color: Colors.amber,
                                        size: 20,
                                      ),
                                      const SizedBox(width: 4),
                                      Text(
                                        doctor.rating.toString(),
                                        style: TextStyle(
                                          color: Colors.grey[600],
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            // Action Buttons
                            Column(
                              children: [
                                ElevatedButton(
                                  onPressed: () async {
                                    // Visual indicator: briefly change the button appearance
                                    setState(() => _pressedIndex = index);
                                    await Future.delayed(
                                      const Duration(milliseconds: 160),
                                    );
                                    debugPrint(
                                      'Book button tapped for ${doctor.name}',
                                    );
                                    try {
                                      await Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              BookAppointmentScreen(
                                                doctor: doctor,
                                              ),
                                        ),
                                      );
                                    } catch (e, st) {
                                      debugPrint('Navigation error: $e\n$st');
                                      ScaffoldMessenger.of(
                                        context,
                                      ).showSnackBar(
                                        SnackBar(
                                          content: Text(
                                            'Could not open booking screen: $e',
                                          ),
                                        ),
                                      );
                                    } finally {
                                      setState(() => _pressedIndex = -1);
                                    }
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: _pressedIndex == index
                                        ? AppColors.primaryRed.withOpacity(0.7)
                                        : AppColors.primaryRed,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                  ),
                                  child: const Text(
                                    'Book',
                                    style: TextStyle(color: Colors.white),
                                  ),
                                ),
                                const SizedBox(height: 8),
                                OutlinedButton(
                                  onPressed: () {
                                    // TODO: Implement chat
                                  },
                                  style: OutlinedButton.styleFrom(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 16,
                                    ),
                                  ),
                                  child: const Text('Chat'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
