import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';
import '../../models/doctor.dart';
import '../../constants/colors.dart';

class VideoCallScreen extends StatefulWidget {
  final Doctor doctor;
  final String channelName;
  final String token;

  const VideoCallScreen({
    Key? key,
    required this.doctor,
    required this.channelName,
    required this.token,
  }) : super(key: key);

  @override
  State<VideoCallScreen> createState() => _VideoCallScreenState();
}

class _VideoCallScreenState extends State<VideoCallScreen> {
  int? _remoteUid;
  bool _localUserJoined = false;
  late RtcEngine _engine;
  bool _isMuted = false;
  bool _isCameraOff = false;

  @override
  void initState() {
    super.initState();
    initializeAgora();
  }

  Future<void> initializeAgora() async {
    // Request permissions
    await Permission.microphone.request();
    await Permission.camera.request();

    // Create RTC engine instance
    _engine = createAgoraRtcEngine();
    await _engine.initialize(
      const RtcEngineContext(
        appId:
            "c11684251e9f4cb282551b6348d3bb4a", // Replace with your Agora App ID
        channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
      ),
    );

    // Enable audio + video for a 1:1 call
    await _engine.enableAudio();
    await _engine.enableVideo();
    await _engine.startPreview();

    // Set up event handlers
    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onJoinChannelSuccess: (connection, elapsed) {
          setState(() {
            _localUserJoined = true;
          });
        },
        onUserJoined: (connection, remoteUid, elapsed) {
          setState(() {
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (connection, remoteUid, reason) {
          setState(() {
            _remoteUid = null;
          });
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

  Widget _renderRemoteVideo() {
    if (_remoteUid != null) {
      return AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: _engine,
          canvas: VideoCanvas(uid: _remoteUid),
          connection: RtcConnection(channelId: widget.channelName),
          useFlutterTexture: true,
          useAndroidSurfaceView: true,
        ),
      );
    } else {
      return const Center(
        child: Text(
          'Waiting for doctor to join...',
          style: TextStyle(color: Colors.white),
        ),
      );
    }
  }

  Widget _renderLocalPreview() {
    if (_localUserJoined) {
      return AgoraVideoView(
        controller: VideoViewController(
          rtcEngine: _engine,
          canvas: const VideoCanvas(uid: 0),
          useFlutterTexture: true,
          useAndroidSurfaceView: true,
        ),
      );
    } else {
      return const Center(child: CircularProgressIndicator());
    }
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
            // Remote Video (Full Screen)
            _renderRemoteVideo(),

            // Local Video (Small overlay)
            Positioned(
              top: 16,
              right: 16,
              child: Container(
                width: 120,
                height: 160,
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(6),
                  child: _renderLocalPreview(),
                ),
              ),
            ),

            // Top Bar with Doctor Info
            Positioned(
              top: 16,
              left: 16,
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 20,
                    backgroundImage: AssetImage(widget.doctor.imageUrl),
                    onBackgroundImageError: (_, __) {},
                    child: Icon(Icons.person, color: Colors.grey[400]),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    widget.doctor.name,
                    style: const TextStyle(color: Colors.white),
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
                          _isCameraOff = !_isCameraOff;
                          _engine.muteLocalVideoStream(_isCameraOff);
                        });
                      },
                      child: _buildControlButton(
                        _isCameraOff ? Icons.videocam_off : Icons.videocam,
                        _isCameraOff ? 'Start Video' : 'Stop Video',
                        !_isCameraOff,
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
