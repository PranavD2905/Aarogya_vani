import 'doctor.dart';

enum AppointmentType { audio, video }

enum AppointmentStatus {
  pending, // Initial state when appointment is created
  scheduled, // When doctor accepts
  completed, // When appointment is done
  cancelled, // When either party cancels
  rescheduled, // When appointment is moved to another time
}

class Appointment {
  final String id;
  final Doctor doctor;
  final DateTime date;
  final String disease;
  final String details;
  final String severity;
  final AppointmentType type;
  final AppointmentStatus status;
  final String patientName; // Added patient name

  const Appointment({
    required this.id,
    required this.doctor,
    required this.date,
    required this.disease,
    required this.details,
    required this.severity,
    required this.type,
    required this.status,
    required this.patientName,
  });

  // Create a new appointment with pending status
  factory Appointment.create({
    required Doctor doctor,
    required DateTime date,
    required String disease,
    required String details,
    required String severity,
    required AppointmentType type,
    required String patientName,
  }) {
    return Appointment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      doctor: doctor,
      date: date,
      disease: disease,
      details: details,
      severity: severity,
      type: type,
      status: AppointmentStatus.pending,
      patientName: patientName,
    );
  }

  // Create a copy of this appointment with a new status
  Appointment copyWith({AppointmentStatus? newStatus}) {
    return Appointment(
      id: id,
      doctor: doctor,
      date: date,
      disease: disease,
      details: details,
      severity: severity,
      type: type,
      status: newStatus ?? status,
      patientName: patientName,
    );
  }
}
