import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../providers/doctor_profile_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class DoctorProfileScreen extends StatelessWidget {
  const DoctorProfileScreen({Key? key}) : super(key: key);

  Future<void> _pickImage(BuildContext context) async {
    final provider = Provider.of<DoctorProfileProvider>(context, listen: false);
    final ImagePicker picker = ImagePicker();

    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        await provider.updateProfileImage(image.path);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Error updating profile image: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Consumer<DoctorProfileProvider>(
        builder: (context, provider, child) {
          if (provider.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (provider.error != null) {
            return Center(child: Text(provider.error!));
          }

          final profile = provider.profile;
          if (profile == null) {
            return const Center(child: Text('No profile data available'));
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 40),
                Center(
                  child: Stack(
                    children: [
                      CircleAvatar(
                        radius: 60,
                        backgroundImage: profile.photoUrl.isNotEmpty
                            ? FileImage(File(profile.photoUrl)) as ImageProvider
                            : const AssetImage('assets/default_avatar.png'),
                      ),
                      Positioned(
                        bottom: 0,
                        right: 0,
                        child: IconButton(
                          onPressed: () => _pickImage(context),
                          icon: const Icon(Icons.camera_alt),
                          style: IconButton.styleFrom(
                            backgroundColor: Theme.of(context).primaryColor,
                            foregroundColor: Colors.white,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                _buildInfoSection('Personal Information', [
                  _buildInfoTile('Name', profile.name),
                  _buildInfoTile('Specialization', profile.specialization),
                  _buildInfoTile('Qualification', profile.qualification),
                  _buildInfoTile('Experience', profile.experience),
                ]),
                const SizedBox(height: 16),
                _buildInfoSection('Contact Information', [
                  _buildInfoTile('Email', profile.email),
                  _buildInfoTile('Phone', profile.phoneNumber),
                ]),
                const SizedBox(height: 16),
                _buildInfoSection('Statistics', [
                  _buildInfoTile('Rating', '${profile.rating} ⭐'),
                  _buildInfoTile(
                    'Total Patients',
                    profile.totalPatients.toString(),
                  ),
                  _buildInfoTile(
                    'Total Appointments',
                    profile.totalAppointments.toString(),
                  ),
                ]),
                const SizedBox(height: 16),
                _buildInfoSection('About', [
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(profile.bio),
                  ),
                ]),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildInfoSection(String title, List<Widget> children) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        const SizedBox(height: 8),
        Card(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(children: children),
          ),
        ),
      ],
    );
  }

  Widget _buildInfoTile(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.grey)),
          Text(value, style: const TextStyle(fontWeight: FontWeight.w500)),
        ],
      ),
    );
  }
}
