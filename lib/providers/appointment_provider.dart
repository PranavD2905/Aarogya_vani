import 'package:flutter/material.dart';
import '../models/appointment.dart';
import '../models/doctor.dart';

class AppointmentProvider extends ChangeNotifier {
  final List<Appointment> _appointments = [];
  DateTime? _selectedDate;
  bool _isLoading = false;
  String? _error;

  List<Appointment> get appointments => List.unmodifiable(_appointments);
  DateTime? get selectedDate => _selectedDate;
  bool get isLoading => _isLoading;
  String? get error => _error;

  List<Appointment> get upcomingAppointments {
    final now = DateTime.now();
    return _appointments
        .where(
          (appointment) =>
              appointment.date.isAfter(now) &&
              appointment.status == AppointmentStatus.scheduled,
        )
        .toList()
      ..sort((a, b) => a.date.compareTo(b.date));
  }

  List<Appointment> get filteredAppointments {
    if (_selectedDate == null) return upcomingAppointments;

    return upcomingAppointments.where((appointment) {
      return appointment.date.year == _selectedDate!.year &&
          appointment.date.month == _selectedDate!.month &&
          appointment.date.day == _selectedDate!.day;
    }).toList();
  }

  void addAppointment(Appointment appointment) {
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

  void rescheduleAppointment(String appointmentId, DateTime newDateTime) {
    final index = _appointments.indexWhere((a) => a.id == appointmentId);
    if (index != -1) {
      final appointment = _appointments[index];
      _appointments[index] = Appointment(
        id: appointment.id,
        doctor: appointment.doctor,
        date: newDateTime,
        disease: appointment.disease,
        details: appointment.details,
        severity: appointment.severity,
        type: appointment.type,
        status: AppointmentStatus.rescheduled,
        patientName: appointment.patientName,
      );
      notifyListeners();
    }
  }

  void setSelectedDate(DateTime? date) {
    _selectedDate = date;
    notifyListeners();
  }

  // Load initial appointments (mock data for now)
  Future<void> loadAppointments(String doctorId) async {
    try {
      _isLoading = true;
      _error = null;
      notifyListeners();

      // Mock appointments
      // Create a mock doctor
      final mockDoctor = Doctor(
        id: doctorId,
        name: 'Dr. Smith',
        specialization: 'General',
        rating: 4.5,
        imageUrl: 'assets/images/doctor.png',
      );

      _appointments.addAll([
        Appointment(
          id: '1',
          doctor: mockDoctor,
          date: DateTime.now().add(const Duration(hours: 1)),
          disease: 'Fever',
          details: 'High temperature, headache',
          severity: 'Medium',
          type: AppointmentType.video,
          status: AppointmentStatus.scheduled,
          patientName: 'John Doe', // Mock patient name
        ),
        Appointment(
          id: '2',
          doctor: mockDoctor,
          date: DateTime.now().add(const Duration(hours: 3)),
          disease: 'Cough',
          details: 'Dry cough, sore throat',
          severity: 'Low',
          type: AppointmentType.audio,
          status: AppointmentStatus.scheduled,
          patientName: 'Jane Smith', // Mock patient name
        ),
      ]);

      _isLoading = false;
      notifyListeners();
    } catch (e) {
      _error = e.toString();
      _isLoading = false;
      notifyListeners();
    }
  }

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
