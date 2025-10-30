import 'package:flutter/material.dart';
import '../models/appointment.dart';

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
              appointment.dateTime.isAfter(now) &&
              appointment.status == AppointmentStatus.scheduled,
        )
        .toList()
      ..sort((a, b) => a.dateTime.compareTo(b.dateTime));
  }

  List<Appointment> get filteredAppointments {
    if (_selectedDate == null) return upcomingAppointments;

    return upcomingAppointments.where((appointment) {
      return appointment.dateTime.year == _selectedDate!.year &&
          appointment.dateTime.month == _selectedDate!.month &&
          appointment.dateTime.day == _selectedDate!.day;
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
        patientId: appointment.patientId,
        patientName: appointment.patientName,
        doctorId: appointment.doctorId,
        dateTime: newDateTime,
        disease: appointment.disease,
        symptoms: appointment.symptoms,
        type: appointment.type,
        status: AppointmentStatus.rescheduled,
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
      _appointments.addAll([
        Appointment(
          id: '1',
          patientId: 'p1',
          patientName: 'John Doe',
          doctorId: doctorId,
          dateTime: DateTime.now().add(const Duration(hours: 1)),
          disease: 'Fever',
          symptoms: 'High temperature, headache',
          type: AppointmentType.video,
        ),
        Appointment(
          id: '2',
          patientId: 'p2',
          patientName: 'Jane Smith',
          doctorId: doctorId,
          dateTime: DateTime.now().add(const Duration(hours: 3)),
          disease: 'Cough',
          symptoms: 'Dry cough, sore throat',
          type: AppointmentType.audio,
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
