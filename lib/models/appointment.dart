import 'doctor.dart';

enum AppointmentType { audio, video }

enum AppointmentStatus {
  scheduled, // When doctor accepts
  completed, // When appointment is done
  cancelled, // When either party cancels
  rescheduled, // When appointment is moved to another time
}

enum CallType { video, audio }

class Appointment {
  final String id;
  final Doctor doctor;
  final DateTime date;
  final String disease;
  final String details;
  final String severity;
  final CallType callType;
  final AppointmentStatus status;

  const Appointment({
    required this.id,
    required this.doctor,
    required this.date,
    required this.disease,
    required this.details,
    required this.severity,
    required this.callType,
    required this.status,
  });

  // Create a new appointment with pending status
  factory Appointment.create({
    required Doctor doctor,
    required DateTime date,
    required String disease,
    required String details,
    required String severity,
    required CallType callType,
  }) {
    return Appointment(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      doctor: doctor,
      date: date,
      disease: disease,
      details: details,
      severity: severity,
      callType: callType,
      status: AppointmentStatus.pending,
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
      callType: callType,
      status: newStatus ?? status,
    );
  }
}
