import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import '../services/call_service.dart';

class CallScreen extends StatefulWidget {
  final String channelName;
  final String patientName;
  final bool isVideo;

  const CallScreen({
    Key? key,
    required this.channelName,
    required this.patientName,
    this.isVideo = true,
  }) : super(key: key);

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  final CallService _callService = CallService();
  bool _isMuted = false;
  bool _isVideoEnabled = true;
  final int _uid = 1; // This should be unique for each user

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
      isVideo: widget.isVideo,
    );
  }

  @override
  void dispose() {
    _callService.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Remote video
            Center(
              child: widget.isVideo
                  ? AgoraVideoView(
                      controller: VideoViewController.remote(
                        rtcEngine: _callService._engine!,
                        canvas: const VideoCanvas(uid: 0),
                        connection: const RtcConnection(channelId: ""),
                      ),
                    )
                  : const Icon(Icons.person, size: 100, color: Colors.white),
            ),
            // Local video
            if (widget.isVideo)
              Positioned(
                top: 16,
                right: 16,
                child: SizedBox(
                  width: 120,
                  height: 160,
                  child: AgoraVideoView(
                    controller: VideoViewController(
                      rtcEngine: _callService._engine!,
                      canvas: const VideoCanvas(uid: 0),
                    ),
                  ),
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
                  if (widget.isVideo)
                    _buildControlButton(
                      icon: _isVideoEnabled
                          ? Icons.videocam
                          : Icons.videocam_off,
                      onPressed: () {
                        setState(() => _isVideoEnabled = !_isVideoEnabled);
                        _callService.toggleVideo();
                      },
                    ),
                  if (widget.isVideo)
                    _buildControlButton(
                      icon: Icons.switch_camera,
                      onPressed: _callService.switchCamera,
                    ),
                ],
              ),
            ),
            // Patient name and call duration
            Positioned(
              top: 16,
              left: 16,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    widget.patientName,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const CallTimer(),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlButton({
    required IconData icon,
    required VoidCallback onPressed,
    Color? backgroundColor,
  }) {
    return Container(
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: backgroundColor ?? Colors.white.withOpacity(0.2),
      ),
      child: IconButton(
        icon: Icon(icon),
        color: Colors.white,
        iconSize: 32,
        onPressed: onPressed,
      ),
    );
  }
}

class CallTimer extends StatefulWidget {
  const CallTimer({Key? key}) : super(key: key);

  @override
  State<CallTimer> createState() => _CallTimerState();
}

class _CallTimerState extends State<CallTimer> {
  final Stopwatch _stopwatch = Stopwatch();
  late final Stream<int> _timerStream;

  @override
  void initState() {
    super.initState();
    _stopwatch.start();
    _timerStream = Stream.periodic(const Duration(seconds: 1), (i) => i);
  }

  @override
  void dispose() {
    _stopwatch.stop();
    super.dispose();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final hours = twoDigits(duration.inHours);
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return hours == '00' ? '$minutes:$seconds' : '$hours:$minutes:$seconds';
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<int>(
      stream: _timerStream,
      builder: (context, snapshot) {
        return Text(
          _formatDuration(_stopwatch.elapsed),
          style: const TextStyle(color: Colors.white, fontSize: 16),
        );
      },
    );
  }
}
