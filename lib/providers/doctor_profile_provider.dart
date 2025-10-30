import 'package:flutter/foundation.dart';
import '../models/doctor_profile.dart';
import '../services/doctor_profile_service.dart';

class DoctorProfileProvider extends ChangeNotifier {
  final DoctorProfileService _profileService = DoctorProfileService();
  DoctorProfile? _profile;
  bool _isLoading = false;
  String? _error;

  DoctorProfile? get profile => _profile;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> loadProfile(String doctorId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      _profile = await _profileService.getDoctorProfile(doctorId);
      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateProfile(DoctorProfile profile) async {
    try {
      await _profileService.updateDoctorProfile(profile);
      _profile = profile;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }

  Future<void> updateProfileImage(String imagePath) async {
    try {
      if (_profile == null) return;

      final photoUrl = await _profileService.uploadProfileImage(
        imagePath,
        _profile!.id,
      );

      _profile = DoctorProfile(
        id: _profile!.id,
        name: _profile!.name,
        specialization: _profile!.specialization,
        qualification: _profile!.qualification,
        experience: _profile!.experience,
        photoUrl: photoUrl,
        bio: _profile!.bio,
        email: _profile!.email,
        phoneNumber: _profile!.phoneNumber,
        rating: _profile!.rating,
        totalPatients: _profile!.totalPatients,
        totalAppointments: _profile!.totalAppointments,
      );

      notifyListeners();
    } catch (e) {
      _error = e.toString();
      notifyListeners();
    }
  }
}
