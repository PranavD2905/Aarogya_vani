import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../models/doctor.dart';
import '../../constants/colors.dart';

class AudioCallScreen extends StatefulWidget {
  final Doctor doctor;
  final String channelName;
  final String token;

  const AudioCallScreen({
    Key? key,
    required this.doctor,
    required this.channelName,
    required this.token,
  }) : super(key: key);

  @override
  State<AudioCallScreen> createState() => _AudioCallScreenState();
}

class _AudioCallScreenState extends State<AudioCallScreen> {
  bool _localUserJoined = false;
  late RtcEngine _engine;
  bool _isMuted = false;
  bool _isSpeakerOn = false;

  @override
  void initState() {
    super.initState();
    initializeAgora();
  }

  Future<void> initializeAgora() async {
    // Request permissions
    await Permission.microphone.request();

    // Create RTC engine instance
    _engine = createAgoraRtcEngine();
    await _engine.initialize(
      const RtcEngineContext(
        appId: "YOUR_AGORA_APP_ID", // Replace with your Agora App ID
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      ),
    );

    // Disable video
    await _engine.disableVideo();

    // Set up event handlers
    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (connection, elapsed) {
          setState(() {
            _localUserJoined = true;
          });
        },
        onUserJoined: (connection, remoteUid, elapsed) {
          // Remote user joined
        },
        onUserOffline: (connection, remoteUid, reason) {
          // Remote user left
        },
      ),
    );

    // Join the channel
    await _engine.joinChannel(
      token: widget.token,
      channelId: widget.channelName,
      uid: 0,
      options: const ChannelMediaOptions(),
    );
  }

  @override
  void dispose() {
    _engine.leaveChannel();
    _engine.release();
    super.dispose();
  }

  Widget _buildControlButton(
    IconData icon,
    String label,
    bool isActive,
    VoidCallback onPressed,
  ) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: isActive ? Colors.white : Colors.white.withOpacity(0.2),
            shape: BoxShape.circle,
          ),
          child: Icon(
            icon,
            color: isActive ? Colors.black : Colors.white,
            size: 24,
          ),
        ),
        const SizedBox(height: 4),
        Text(label, style: const TextStyle(color: Colors.white, fontSize: 12)),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: Stack(
          children: [
            // Center content
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Doctor Avatar
                  CircleAvatar(
                    radius: 60,
                    backgroundImage: AssetImage(widget.doctor.imageUrl),
                    onBackgroundImageError: (_, __) {},
                    child: Icon(
                      Icons.person,
                      size: 60,
                      color: Colors.grey[400],
                    ),
                  ),
                  const SizedBox(height: 24),
                  // Doctor Name
                  Text(
                    widget.doctor.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  // Call Status
                  Text(
                    _localUserJoined ? 'Connected' : 'Connecting...',
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.7),
                      fontSize: 16,
                    ),
                  ),
                ],
              ),
            ),

            // Bottom Controls
            Positioned(
              bottom: 32,
              left: 0,
              right: 0,
              child: Container(
                padding: const EdgeInsets.symmetric(vertical: 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    InkWell(
                      onTap: () {
                        setState(() {
                          _isMuted = !_isMuted;
                          _engine.muteLocalAudioStream(_isMuted);
                        });
                      },
                      child: _buildControlButton(
                        _isMuted ? Icons.mic_off : Icons.mic,
                        _isMuted ? 'Unmute' : 'Mute',
                        !_isMuted,
                        () {},
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        Navigator.pop(context);
                        _engine.leaveChannel();
                      },
                      child: _buildControlButton(
                        Icons.call_end,
                        'End',
                        false,
                        () {},
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        setState(() {
                          _isSpeakerOn = !_isSpeakerOn;
                          _engine.setEnableSpeakerphone(_isSpeakerOn);
                        });
                      },
                      child: _buildControlButton(
                        _isSpeakerOn ? Icons.volume_up : Icons.volume_down,
                        _isSpeakerOn ? 'Speaker' : 'Earpiece',
                        _isSpeakerOn,
                        () {},
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
