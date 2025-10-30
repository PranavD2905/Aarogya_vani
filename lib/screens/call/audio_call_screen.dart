import 'package:flutter/material.dart';
import '../../models/doctor.dart';
import '../../services/call_service.dart';

class AudioCallScreen extends StatefulWidget {
  final Doctor doctor;
  final String channelName;

  const AudioCallScreen({
    Key? key,
    required this.doctor,
    required this.channelName,
  }) : super(key: key);

  @override
  State<AudioCallScreen> createState() => _AudioCallScreenState();
}

class _AudioCallScreenState extends State<AudioCallScreen> {
  final CallService _callService = CallService();
  bool _isMuted = false;
  bool _isSpeakerOn = false;
  final int _uid = 2; // Use 2 for patient side (doctor uses 1)

  @override
  void initState() {
    super.initState();
    _initializeCall();
  }

  Future<void> _initializeCall() async {
    await _callService.initialize();
    await _callService.joinCall(
      channelName: widget.channelName,
      uid: _uid,
      isVideo: false,
    );
  }

  @override
  void dispose() {
    _callService.dispose();
    super.dispose();
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
    Color backgroundColor = Colors.white24,
  }) {
    return RawMaterialButton(
      onPressed: onPressed,
      elevation: 2.0,
      fillColor: backgroundColor,
      padding: const EdgeInsets.all(12.0),
      shape: const CircleBorder(),
      child: Icon(icon, color: Colors.white, size: 24.0),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Doctor info
            Center(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.person, color: Colors.white, size: 100),
                  const SizedBox(height: 16),
                  Text(
                    widget.doctor.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    'Audio Call',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),
            // Call controls
            Positioned(
              bottom: 32,
              left: 0,
              right: 0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildControlButton(
                    icon: _isMuted ? Icons.mic_off : Icons.mic,
                    onPressed: () {
                      setState(() => _isMuted = !_isMuted);
                      _callService.toggleMute();
                    },
                  ),
                  _buildControlButton(
                    icon: Icons.call_end,
                    backgroundColor: Colors.red,
                    onPressed: () {
                      _callService.leaveCall();
                      Navigator.pop(context);
                    },
                  ),
                  _buildControlButton(
                    icon: _isSpeakerOn ? Icons.volume_up : Icons.volume_down,
                    onPressed: () {
                      setState(() => _isSpeakerOn = !_isSpeakerOn);
                      _callService.toggleSpeaker();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
