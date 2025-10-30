import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:permission_handler/permission_handler.dart';

class CallService {
  static const String appId = 'e619289ca0694fc6a1e9a0e8317b43a5';

  RtcEngine? _engine;
  bool _isInitialized = false;

  Future<void> initialize() async {
    if (_isInitialized) return;

    await [Permission.camera, Permission.microphone].request();

    _engine = createAgoraRtcEngine();
    await _engine!.initialize(const RtcEngineContext(appId: appId));

    _isInitialized = true;
  }

  Future<void> joinCall({
    required String channelName,
    required int uid,
    required bool isVideo,
  }) async {
    if (!_isInitialized) {
      await initialize();
    }

    await _engine!.enableVideo();
    await _engine!.setChannelProfile(
      ChannelProfileType.channelProfileCommunication,
    );

    await _engine!.startPreview();

    await _engine!.joinChannel(
      token: '', // Use token based authentication in production
      channelId: channelName,
      uid: uid,
      options: const ChannelMediaOptions(),
    );
  }

  Future<void> leaveCall() async {
    await _engine?.leaveChannel();
    await _engine?.stopPreview();
  }

  Future<void> toggleMute() async {
    await _engine?.muteLocalAudioStream(true);
  }

  Future<void> toggleVideo() async {
    await _engine?.muteLocalVideoStream(true);
  }

  Future<void> toggleSpeaker() async {
    await _engine?.setEnableSpeakerphone(true);
  }

  Future<void> switchCamera() async {
    await _engine?.switchCamera();
  }

  void dispose() {
    _engine?.release();
    _engine = null;
    _isInitialized = false;
  }

  // Get local video view
  Widget getLocalView() {
    return AgoraVideoView(
      controller: VideoViewController(
        rtcEngine: _engine!,
        canvas: const VideoCanvas(uid: 0),
      ),
    );
  }

  // Get remote video view
  Widget getRemoteView(int uid) {
    return AgoraVideoView(
      controller: VideoViewController.remote(
        rtcEngine: _engine!,
        canvas: VideoCanvas(uid: uid),
        connection: const RtcConnection(),
      ),
    );
  }
}
