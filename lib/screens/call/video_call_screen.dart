import 'package:flutter/material.dart';
import '../../models/doctor.dart';
import '../../services/call_service.dart';

class VideoCallScreen extends StatefulWidget {
  final Doctor doctor;
  final String channelName;

  const VideoCallScreen({
    Key? key,
    required this.doctor,
    required this.channelName,
  }) : super(key: key);

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  final CallService _callService = CallService();
  bool _isMuted = false;
  bool _isVideoEnabled = true;
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
      isVideo: true,
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
            // Remote video (doctor's video)
            Center(
              child: _callService.getRemoteView(1), // Use UID 1 for doctor's video
            ),
            // Local video (patient's video)
            Positioned(
              top: 16,
              right: 16,
              child: SizedBox(
                width: 120,
                height: 160,
                child: _callService.getLocalView(),
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
                    icon: _isVideoEnabled ? Icons.videocam : Icons.videocam_off,
                    onPressed: () {
                      setState(() => _isVideoEnabled = !_isVideoEnabled);
                      _callService.toggleVideo();
                    },
                  ),
                ],
              ),
            ),
            // Doctor info
            Positioned(
              top: 24,
              left: 24,
              child: Row(
                children: [
                  const Icon(Icons.person, color: Colors.white, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    widget.doctor.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
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
