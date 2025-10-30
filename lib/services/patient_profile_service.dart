import 'dart:io';
import 'dart:convert';
import 'package:path_provider/path_provider.dart';
import '../models/patient_profile.dart';

class PatientProfileService {
  // Get the application documents directory for local storage
  Future<Directory> get _localDir async {
    final directory = await getApplicationDocumentsDirectory();
    return directory;
  }

  // Upload profile image locally
  Future<String> uploadProfileImage(File imageFile, String patientId) async {
    try {
      final directory = await _localDir;
      final profileImagesDir = Directory(
        '${directory.path}/patient_profiles/$patientId',
      );
      await profileImagesDir.create(recursive: true);

      final fileName = 'profile_image.jpg';
      final localImageFile = File('${profileImagesDir.path}/$fileName');

      // Copy the image file to local storage
      await imageFile.copy(localImageFile.path);

      return localImageFile.path;
    } catch (e) {
      print('Error saving profile image: $e');
      rethrow;
    }
  }

  // Save patient profile locally
  Future<void> savePatientProfile(PatientProfile profile) async {
    try {
      final directory = await _localDir;
      final file = File(
        '${directory.path}/patient_profiles/${profile.id}/profile.json',
      );
      await file.create(recursive: true);
      await file.writeAsString(jsonEncode(profile.toMap()));
    } catch (e) {
      print('Error saving patient profile: $e');
      rethrow;
    }
  }

  // Get patient profile from local storage
  Future<PatientProfile?> getPatientProfile(String patientId) async {
    try {
      final directory = await _localDir;
      final file = File(
        '${directory.path}/patient_profiles/$patientId/profile.json',
      );

      if (await file.exists()) {
        final jsonString = await file.readAsString();
        final data = jsonDecode(jsonString);
        return PatientProfile.fromMap(Map<String, dynamic>.from(data));
      }
      return null;
    } catch (e) {
      print('Error getting patient profile: $e');
      rethrow;
    }
  }

  // Update patient profile (same as save since we're using local storage)
  Future<void> updatePatientProfile(PatientProfile profile) async {
    await savePatientProfile(profile);
  }
}
