import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:flutter/material.dart';

Widget viewRows(RtcEngine engine, int? remoteUid, String channelName,
    bool showVideo, bool vidcamOff) {
  final List<StatefulWidget> list = [];
  
    list.add(
      
      
      AgoraVideoView(
        controller: VideoViewController(
            rtcEngine: engine,
            canvas: const VideoCanvas(uid: 0),
            useAndroidSurfaceView: true),
      ),
    );
  
  if (remoteUid != null && remoteUid != 0 && showVideo == true) {
    list.add(
      AgoraVideoView(
        controller: VideoViewController.remote(
          rtcEngine: engine,
          canvas: VideoCanvas(uid: remoteUid),
          connection: RtcConnection(channelId: channelName),
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
