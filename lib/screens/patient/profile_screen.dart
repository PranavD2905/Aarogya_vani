import 'package:flutter/material.dart';
import '../../models/patient_profile.dart';
import '../../constants/colors.dart';

class ProfileScreen extends StatelessWidget {
  final PatientProfile
  profile; // This will be passed from the previous screen or fetched from Firebase

  const ProfileScreen({Key? key, required this.profile}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            icon: const Icon(Icons.edit),
            onPressed: () {
              // TODO: Implement edit profile functionality
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            const SizedBox(height: 20),
            // Profile Picture
            Center(
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: NetworkImage(profile.photoUrl),
                    backgroundColor: Colors.grey[200],
                    child: profile.photoUrl.isEmpty
                        ? const Icon(Icons.person, size: 60, color: Colors.grey)
                        : null,
                  ),
                ],
              ),
            ),
            const SizedBox(height: 20),
            // Name
            Text(
              profile.name,
              style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 30),
            // Profile Information Cards
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                children: [
                  _buildInfoCard('Patient ID', profile.id, Icons.badge),
                  _buildInfoCard(
                    'Date of Birth',
                    '${profile.dateOfBirth.day}/${profile.dateOfBirth.month}/${profile.dateOfBirth.year}',
                    Icons.cake,
                  ),
                  _buildInfoCard(
                    'Blood Group',
                    profile.bloodGroup,
                    Icons.bloodtype,
                  ),
                  _buildInfoCard('Sex', profile.sex, Icons.person),
                  _buildInfoCard(
                    'Phone Number',
                    profile.phoneNumber,
                    Icons.phone,
                  ),
                  _buildInfoCard('Email', profile.email, Icons.email),
                  _buildInfoCard('Address', profile.address, Icons.location_on),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInfoCard(String title, String value, IconData icon) {
    return Card(
      margin: const EdgeInsets.only(bottom: 16.0),
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          children: [
            Icon(icon, color: AppColors.primaryRed),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(fontSize: 14, color: Colors.grey),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
