import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:looper/utils/constants.dart';
import 'package:looper/widgets/video_rows.dart';
import 'package:permission_handler/permission_handler.dart';

import '../widgets/info_panel.dart';

// ignore: must_be_immutable
class CallScreen extends StatefulWidget {
  const CallScreen({super.key, required this.channelName});

  final String? channelName;

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  final _infoStrings = <String>[];
  bool muted = false;
  bool vidcamOff = false;
  bool viewPanel = false;
  int? _remoteUid;
  bool showVideo = true;

  late RtcEngine _engine;

  @override
  void initState() {
    initialize();
    super.initState();
  }

  @override
  void dispose() {
    _engine.leaveChannel();
    _engine.stopPreview();
    super.dispose();
  }

  Future<void> initialize() async {
    await [Permission.microphone, Permission.camera].request();

    _engine = createAgoraRtcEngine();
    await _engine.initialize(const RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));

    _addAgoraEventHandlers();
    await _engine.setClientRole(role: ClientRoleType.clientRoleBroadcaster);
    await _engine.enableVideo();
    await _engine.startPreview();
    await _engine.joinChannel(
        token: token,
        channelId: widget.channelName!,
        uid: 0,
        options: const ChannelMediaOptions());
  }

  _addAgoraEventHandlers() {
    _engine.registerEventHandler(
      RtcEngineEventHandler(
        onError: (err, msg) {
          setState(() {
            final info = 'Error: $msg';
            _infoStrings.add(info);
          });
        },
        onJoinChannelSuccess: (connection, elapsed) {
          setState(() {
            const info = 'Join Channel: $channelName, uid: 0';
            _infoStrings.add(info);
          });
        },
        onLeaveChannel: (connection, stats) {
          setState(() {
            _infoStrings.add('Leave Channel');
          });
        },
        onUserJoined: (connection, remoteUid, elapsed) {
          setState(() {
            final info = 'User Joined: $remoteUid\nElapsed Time: $elapsed ms';
            _infoStrings.add(info);

            _remoteUid = remoteUid;
            showVideo = true;
          });
        },
        onUserOffline: (connection, remoteUid, reason) {
          setState(() {
            final info = 'User offline: $remoteUid';
            _infoStrings.add(info);
            showVideo = !showVideo;
          });
        },
        onFirstRemoteVideoFrame:
            (connection, remoteUid, width, height, elapsed) {
          setState(() {
            final info = 'First Remote Video: $remoteUid ${width}x$height';
            _infoStrings.add(info);
          });
        },
        onTokenPrivilegeWillExpire: (RtcConnection connection, String token) {
          debugPrint(
              '[onTokenPrivilegeWillExpire] connection: ${connection.toJson()}, token: $token');
        },
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          foregroundColor: Colors.black,
          elevation: 0,
          backgroundColor: Colors.transparent,
          actions: [
            IconButton(
              onPressed: () {
                setState(() {
                  viewPanel = !viewPanel;
                });
              },
              icon: const Icon(
                Icons.info_outlined,
                size: 30,
                weight: 20,
              ),
            )
          ],
        ),
        backgroundColor: Colors.black,
        extendBodyBehindAppBar: true,
        body: Center(
          child: Stack(
            children: [
              viewRows(_engine, _remoteUid, channelName, showVideo,vidcamOff),
              panel(viewPanel, _infoStrings),
              toolbar(),
            ],
          ),
        ));
  }

  Widget toolbar() {
    return Container(
      alignment: Alignment.bottomCenter,
      padding: const EdgeInsets.symmetric(vertical: 40),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          RawMaterialButton(
            onPressed: () {
              setState(() {
                muted = !muted;
              });
              _engine.muteAllRemoteAudioStreams(muted);
            },
            shape: const CircleBorder(),
            elevation: 2,
            fillColor: muted ? Colors.blueAccent : Colors.white,
            padding: const EdgeInsets.all(12),
            child: Icon(
              muted ? Icons.mic_off : Icons.mic,
              color: muted ? Colors.white : Colors.blueAccent,
              size: 20,
            ),
          ),
          RawMaterialButton(
            onPressed: () => Navigator.pop(context),
            shape: const CircleBorder(),
            elevation: 2,
            fillColor: Colors.redAccent,
            padding: const EdgeInsets.all(15),
            child: const Icon(
              Icons.call_end,
              color: Colors.white,
              size: 35,
            ),
          ),
          RawMaterialButton(
            onPressed: () {
              _engine.switchCamera();
            },
            shape: const CircleBorder(),
            elevation: 2,
            fillColor: Colors.white,
            padding: const EdgeInsets.all(12),
            child: const Icon(
              Icons.switch_camera,
              color: Colors.blueAccent,
              size: 20,
            ),
          ),
          RawMaterialButton(
            onPressed: () {
              setState(() {
                vidcamOff = !vidcamOff;
              });

              _engine.enableLocalVideo(vidcamOff);
            },
            shape: const CircleBorder(),
            elevation: 2,
            fillColor: vidcamOff ? Colors.blueAccent : Colors.white,
            padding: const EdgeInsets.all(12),
            child: Icon(
              vidcamOff ? Icons.videocam_off_rounded : Icons.videocam,
              color: vidcamOff ? Colors.white : Colors.blueAccent,
              size: 20,
            ),
          ),
        ],
      ),
    );
  }
}
