import 'package:flutter/material.dart';
import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:looper/utils/constants.dart';
import 'package:permission_handler/permission_handler.dart';

// ignore: must_be_immutable
class CallScreen extends StatefulWidget {
  const CallScreen({super.key, required this.role, required this.channelName});
  final int role;
  final String? channelName;

  @override
  State<CallScreen> createState() => _CallScreenState();
}

class _CallScreenState extends State<CallScreen> {
  final _users = <int>[];
  final _infoStrings = <String>[];
  bool muted = false;

  int? _remoteUid;

  int localUid(int role) {
    if (role == 1) {
      return 0;
    } else {
      return 1;
    }
  }

  late RtcEngine _engine;

  clientRole(int role) {
    ClientRoleType clientRoleType = role == 1
        ? ClientRoleType.clientRoleBroadcaster
        : ClientRoleType.clientRoleAudience;
    return clientRoleType;
  }

  @override
  void initState() {
    initialize();
    super.initState();
  }

  @override
  void dispose() {
    _users.clear();
    _engine.leaveChannel();

    super.dispose();
  }

  Future<void> initialize() async {
    await [Permission.microphone, Permission.camera].request();

    _engine = createAgoraRtcEngine();
    await _engine.initialize(const RtcEngineContext(
      appId: appId,
      channelProfile: ChannelProfileType.channelProfileLiveBroadcasting,
    ));

    await _engine.setClientRole(role: clientRole(widget.role));
    await _engine.enableVideo();
    await _engine.startPreview();
    _addAgoraEventHandlers();
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
            _users.clear();
          });
        },
        onUserJoined: (connection, remoteUid, elapsed) {
          setState(() {
            final info = 'User Joined: $remoteUid';
            _infoStrings.add(info);
            _users.add(remoteUid);
            _remoteUid = remoteUid;
          });
        },
        onUserOffline: (connection, remoteUid, reason) {
          setState(() {
            final info = 'User offline: $remoteUid';
            _infoStrings.add(info);
            _users.remove(remoteUid);
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

  Widget _viewRows() {
    final List<StatefulWidget> list = [];

    list.add(
      AgoraVideoView(
        controller: VideoViewController(
            rtcEngine: _engine,
            canvas: const VideoCanvas(uid: 0),
            useAndroidSurfaceView: true),
      ),
    );
    if (_remoteUid != 0) {
      list.add(
        AgoraVideoView(
          controller: VideoViewController.remote(
            rtcEngine: _engine,
            canvas: VideoCanvas(uid: _remoteUid),
            connection: const RtcConnection(channelId: channelName),
          ),
        ),
      );
    }

    final views = list;

    return Column(
      children: List.generate(
        views.length,
        (index) => Expanded(child: views[index]),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text('Agora'),
          centerTitle: true,
        ),
        backgroundColor: Colors.black,
        body: Center(
          child: Stack(
            children: [
              _viewRows(),
            ],
          ),
        ));
  }
}
