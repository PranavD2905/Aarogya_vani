import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/colors.dart';
import '../../models/doctor.dart';
import '../../models/appointment.dart';
import '../../providers/appointment_provider.dart';

class BookAppointmentScreen extends StatefulWidget {
  final Doctor doctor;
  const BookAppointmentScreen({Key? key, required this.doctor})
    : super(key: key);

  @override
  State<BookAppointmentScreen> createState() => _BookAppointmentScreenState();
}

class _BookAppointmentScreenState extends State<BookAppointmentScreen> {
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  String _callType = 'Video';
  final _diseaseController = TextEditingController();
  final _detailsController = TextEditingController();
  String _severity = 'Basic';
  final _formKey = GlobalKey<FormState>();

  Future<void> _pickDate() async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: now,
      firstDate: now,
      lastDate: now.add(const Duration(days: 365)),
    );
    if (picked != null) {
      setState(() => _selectedDate = picked);
    }
  }

  Future<void> _pickTime() async {
    final now = TimeOfDay.now();
    final picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? now,
    );
    if (picked != null) {
      // Enforce business hours: 09:00 - 17:00
      int toMinutes(TimeOfDay t) => t.hour * 60 + t.minute;
      final start = TimeOfDay(hour: 9, minute: 0);
      final end = TimeOfDay(hour: 17, minute: 0);
      if (toMinutes(picked) < toMinutes(start) ||
          toMinutes(picked) > toMinutes(end)) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Please select a time between 09:00 and 17:00'),
          ),
        );
        return;
      }

      setState(() => _selectedTime = picked);
    }
  }

  void _submit() {
    if (_formKey.currentState?.validate() != true) return;
    if (_selectedDate == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a date for the appointment'),
        ),
      );
      return;
    }

    if (_selectedTime == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a time for the appointment'),
        ),
      );
      return;
    }

    // Create the appointment
    final date = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    final appointment = Appointment.create(
      doctor: widget.doctor,
      date: date,
      disease: _diseaseController.text,
      details: _detailsController.text,
      severity: _severity,
      patientName: widget.doctor.name, // TODO: Replace with actual patient name
      type: _callType == 'Video'
          ? AppointmentType.video
          : AppointmentType.audio,
    );

    // Add the appointment to the provider
    Provider.of<AppointmentProvider>(
      context,
      listen: false,
    ).addAppointment(appointment);

    showDialog<void>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Appointment Booked!'),
        content: Text(
          'Your appointment with ${widget.doctor.name} is confirmed for ${_selectedDate!.toLocal().toString().split(' ')[0]} at ${_selectedTime!.format(context)}.\n\nDetails:\nSeverity: $_severity\nMode: $_callType',
        ),
        actions: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primaryRed,
              foregroundColor: Colors.white,
            ),
            onPressed: () {
              Navigator.of(context).pop(); // close dialog
              Navigator.of(context).pop(); // go back to home

              // Show success message
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Appointment booked successfully!'),
                  backgroundColor: Colors.green,
                ),
              );
            },
            child: const Text('OK', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _diseaseController.dispose();
    _detailsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // Custom header instead of AppBar for improved aesthetics
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 14),
              color: AppColors.primaryRed,
              child: Row(
                children: [
                  IconButton(
                    onPressed: () => Navigator.of(context).pop(),
                    icon: const Icon(Icons.arrow_back, color: Colors.white),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Book Appointment',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const Spacer(),
                  Text(
                    widget.doctor.name,
                    style: const TextStyle(color: Colors.white),
                  ),
                ],
              ),
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: ListView(
                    children: [
                      Text(
                        'Doctor: ${widget.doctor.name}',
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Date picker
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Select Date'),
                        subtitle: Text(
                          _selectedDate == null
                              ? 'No date chosen'
                              : _selectedDate!.toLocal().toString().split(
                                  ' ',
                                )[0],
                        ),
                        trailing: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryRed,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: _pickDate,
                          child: const Text(
                            'Choose',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Time picker
                      ListTile(
                        contentPadding: EdgeInsets.zero,
                        title: const Text('Select Time'),
                        subtitle: Text(
                          _selectedTime == null
                              ? 'No time chosen'
                              : _selectedTime!.format(context),
                        ),
                        trailing: ElevatedButton(
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppColors.primaryRed,
                            foregroundColor: Colors.white,
                          ),
                          onPressed: _pickTime,
                          child: const Text(
                            'Choose',
                            style: TextStyle(color: Colors.white),
                          ),
                        ),
                      ),
                      const SizedBox(height: 12),
                      // Severity dropdown
                      DropdownButtonFormField<String>(
                        value: _severity,
                        decoration: const InputDecoration(
                          labelText: 'Disease Severity',
                          border: OutlineInputBorder(),
                        ),
                        items: const [
                          DropdownMenuItem(
                            value: 'Basic',
                            child: Text('Basic'),
                          ),
                          DropdownMenuItem(
                            value: 'Medium',
                            child: Text('Medium'),
                          ),
                          DropdownMenuItem(
                            value: 'Critical',
                            child: Text('Critical'),
                          ),
                        ],
                        onChanged: (v) =>
                            setState(() => _severity = v ?? 'Basic'),
                      ),
                      const SizedBox(height: 12),
                      // Disease
                      TextFormField(
                        controller: _diseaseController,
                        decoration: const InputDecoration(
                          labelText: 'Disease',
                          border: OutlineInputBorder(),
                        ),
                        validator: (v) => (v == null || v.trim().isEmpty)
                            ? 'Please enter disease'
                            : null,
                      ),
                      const SizedBox(height: 12),
                      // Details
                      TextFormField(
                        controller: _detailsController,
                        decoration: const InputDecoration(
                          labelText: 'Disease Details',
                          border: OutlineInputBorder(),
                        ),
                        maxLines: 5,
                      ),
                      const SizedBox(height: 12),
                      // Consultation type (Video / Audio)
                      const Text('Consultation Type'),
                      const SizedBox(height: 8),
                      Wrap(
                        spacing: 8,
                        children: [
                          ChoiceChip(
                            label: const Text('Video'),
                            selected: _callType == 'Video',
                            onSelected: (s) => setState(() {
                              if (s) _callType = 'Video';
                            }),
                          ),
                          ChoiceChip(
                            label: const Text('Audio'),
                            selected: _callType == 'Audio',
                            onSelected: (s) => setState(() {
                              if (s) _callType = 'Audio';
                            }),
                          ),
                        ],
                      ),
                      const SizedBox(height: 20),
                      // Submit
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryRed,
                          foregroundColor: Colors.white,
                          minimumSize: const Size(double.infinity, 50),
                        ),
                        onPressed: _submit,
                        child: const Text(
                          'Submit',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
