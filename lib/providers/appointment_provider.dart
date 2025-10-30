import 'package:flutter/material.dart';
import '../models/appointment.dart';

// This is a temporary in-memory store for appointments
// In a real app, this would be replaced with a proper database or API
class AppointmentProvider extends ChangeNotifier {
  final List<Appointment> _appointments = [];

  List<Appointment> get appointments => List.unmodifiable(_appointments);

  void addAppointment(Appointment appointment) {
    // Keep the appointment as pending when first created
    _appointments.add(appointment);
    notifyListeners();
  }

  // Doctor actions
  void acceptAppointment(String appointmentId) {
    updateAppointment(appointmentId, AppointmentStatus.scheduled);
  }

  void completeAppointment(String appointmentId) {
    updateAppointment(appointmentId, AppointmentStatus.completed);
  }

  void cancelAppointment(String appointmentId) {
    updateAppointment(appointmentId, AppointmentStatus.cancelled);
  }

  // Update appointment status
  void updateAppointment(String id, AppointmentStatus newStatus) {
    final index = _appointments.indexWhere((a) => a.id == id);
    if (index != -1) {
      _appointments[index] = _appointments[index].copyWith(
        newStatus: newStatus,
      );
      notifyListeners();
    }
  }

  // Get appointments for a specific doctor
  List<Appointment> getAppointmentsForDoctor(String doctorId) {
    return _appointments.where((appt) => appt.doctor.id == doctorId).toList();
  }

  // Get pending appointments that need doctor approval
  List<Appointment> getPendingAppointments() {
    return _appointments
        .where((appt) => appt.status == AppointmentStatus.pending)
        .toList();
  }
}
