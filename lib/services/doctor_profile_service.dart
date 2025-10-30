import 'dart:convert';
import 'dart:io';
import 'package:path_provider/path_provider.dart';
import '../models/doctor_profile.dart';

class DoctorProfileService {
  Future<Directory> get _localDir async {
    final directory = await getApplicationDocumentsDirectory();
    return directory;
  }

  Future<String> uploadProfileImage(String imagePath, String doctorId) async {
    try {
      final directory = await _localDir;
      final profileImagesDir = Directory(
        '${directory.path}/doctor_profiles/$doctorId',
      );
      await profileImagesDir.create(recursive: true);

      final File imageFile = File(imagePath);
      final String fileName = 'profile_image.jpg';
      final File localImageFile = File('${profileImagesDir.path}/$fileName');

      // Copy the image file to local storage
      await imageFile.copy(localImageFile.path);

      return localImageFile.path;
    } catch (e) {
      print('Error uploading profile image: $e');
      rethrow;
    }
  }

  Future<void> updateDoctorProfile(DoctorProfile profile) async {
    try {
      final directory = await _localDir;
      final file = File(
        '${directory.path}/doctor_profiles/${profile.id}/profile.json',
      );
      await file.create(recursive: true);
      await file.writeAsString(jsonEncode(profile.toMap()));
    } catch (e) {
      print('Error updating doctor profile: $e');
      rethrow;
    }
  }

  Future<DoctorProfile?> getDoctorProfile(String doctorId) async {
    try {
      final directory = await _localDir;
      final file = File(
        '${directory.path}/doctor_profiles/$doctorId/profile.json',
      );

      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final data = jsonDecode(jsonString);
        return DoctorProfile.fromMap(Map<String, dynamic>.from(data));
      }
      return null;
    } catch (e) {
      print('Error getting doctor profile: $e');
      rethrow;
    }
  }
}
