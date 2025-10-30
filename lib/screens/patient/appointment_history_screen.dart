import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../constants/colors.dart';
import '../../models/appointment.dart';
import '../../providers/appointment_provider.dart';
import '../../services/agora_service.dart';
import '../call/video_call_screen.dart';
import '../call/audio_call_screen.dart';

class AppointmentHistoryScreen extends StatelessWidget {
  const AppointmentHistoryScreen({Key? key}) : super(key: key);

  // Show appropriate icon for call type
  Widget _buildCallIcon(CallType type) {
    return Icon(
      type == CallType.video ? Icons.videocam : Icons.phone,
      color: Colors.white,
    );
  }

  // Get color based on appointment status
  Color _getStatusColor(AppointmentStatus status) {
    switch (status) {
      case AppointmentStatus.pending:
        return Colors.orange;
      case AppointmentStatus.scheduled:
        return Colors.green;
      case AppointmentStatus.completed:
        return Colors.blue;
      case AppointmentStatus.cancelled:
        return Colors.red;
    }
  }

  Future<void> _handleCall(
    BuildContext context,
    Appointment appointment,
  ) async {
    if (appointment.status != AppointmentStatus.scheduled) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Call is only available for scheduled appointments'),
        ),
      );
      return;
    }

    try {
      // Generate channel name and get token
      final channelName = AgoraService.generateChannelName(
        doctorId: appointment.doctor.id,
        patientId: 'patient123', // TODO: Replace with actual patient ID
      );
      final token = await AgoraService.getToken(
        channelName: channelName,
        uid: 0,
      );

      if (appointment.callType == CallType.video) {
        // Start video call
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => VideoCallScreen(
              doctor: appointment.doctor,
              channelName: channelName,
              token: token,
            ),
          ),
        );
      } else {
        // Start audio call
        await Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => AudioCallScreen(
              doctor: appointment.doctor,
              channelName: channelName,
              token: token,
            ),
          ),
        );
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Failed to start call: ${e.toString()}'),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Consumer<AppointmentProvider>(
          builder: (context, provider, child) {
            final appointments = provider.appointments;
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 14,
                  ),
                  color: AppColors.primaryRed,
                  child: const Text(
                    'Appointments',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                if (appointments.isEmpty)
                  const Expanded(
                    child: Center(
                      child: Text(
                        'No appointments yet',
                        style: TextStyle(color: Colors.grey, fontSize: 16),
                      ),
                    ),
                  )
                else
                  Expanded(
                    child: ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: appointments.length,
                      itemBuilder: (context, index) {
                        final appointment = appointments[index];
                        return Card(
                          margin: const EdgeInsets.only(bottom: 16),
                          child: Padding(
                            padding: const EdgeInsets.all(16),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            appointment.doctor.name,
                                            style: const TextStyle(
                                              fontSize: 18,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            appointment.doctor.specialization,
                                            style: TextStyle(
                                              color: Colors.grey[600],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 8,
                                        vertical: 4,
                                      ),
                                      decoration: BoxDecoration(
                                        color: _getStatusColor(
                                          appointment.status,
                                        ),
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Text(
                                        appointment.status.name.toUpperCase(),
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 12,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                                const Divider(height: 24),
                                Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.calendar_today,
                                                size: 16,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                appointment.date
                                                    .toLocal()
                                                    .toString()
                                                    .split(' ')[0],
                                              ),
                                            ],
                                          ),
                                          const SizedBox(height: 8),
                                          Row(
                                            children: [
                                              const Icon(
                                                Icons.access_time,
                                                size: 16,
                                              ),
                                              const SizedBox(width: 8),
                                              Text(
                                                TimeOfDay.fromDateTime(
                                                  appointment.date,
                                                ).format(context),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (appointment.status ==
                                        AppointmentStatus.scheduled)
                                      ElevatedButton.icon(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppColors.primaryRed,
                                          foregroundColor: Colors.white,
                                        ),
                                        onPressed: () =>
                                            _handleCall(context, appointment),
                                        icon: _buildCallIcon(
                                          appointment.callType,
                                        ),
                                        label: const Text('Join'),
                                      )
                                    else if (appointment.status ==
                                        AppointmentStatus.pending)
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: Colors.orange,
                                          foregroundColor: Colors.white,
                                        ),
                                        onPressed: () {
                                          // Temporary: mark as scheduled for testing
                                          provider.acceptAppointment(appointment.id);
                                          ScaffoldMessenger.of(context).showSnackBar(
                                            const SnackBar(
                                              content: Text('Appointment marked as scheduled'),
                                            ),
                                          );
                                        },
                                        child: const Text('Mark Scheduled'),
                                      ),
                                  ],
                                ),
                                if (appointment.disease.isNotEmpty) ...[
                                  const Divider(height: 24),
                                  Text(
                                    'Disease: ${appointment.disease}',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.w500,
                                    ),
                                  ),
                                  if (appointment.details.isNotEmpty) ...[
                                    const SizedBox(height: 8),
                                    Text(appointment.details),
                                  ],
                                ],
                              ],
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            );
          },
        ),
      ),
    );
  }
}
