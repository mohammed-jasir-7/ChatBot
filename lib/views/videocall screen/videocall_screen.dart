import 'dart:developer';

import 'package:agora_rtc_engine/agora_rtc_engine.dart';
import 'package:chatbot/Controllers/videocall/videocall_bloc.dart';
import 'package:chatbot/util.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_countdown_timer/flutter_countdown_timer.dart';
import 'package:lottie/lottie.dart';

import '../../Models/user_model.dart';

const String appId = "e52f2861ba4a4fd4bf374a7e6fa4e0b3";

class VideocallScreen extends StatefulWidget {
  const VideocallScreen({super.key, required this.bot});
  final Bot bot;

  @override
  State<VideocallScreen> createState() => _VideocallScreenState();
}

class _VideocallScreenState extends State<VideocallScreen> {
  int endTime = 0;
  @override
  void initState() {
    endTime = DateTime.now().millisecondsSinceEpoch + 11000 * 400;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      body: Container(
        width: size.width,
        height: size.height,
        color: backroundColor,
        child: Stack(
          children: [
            Padding(
              padding: EdgeInsets.only(
                bottom:
                    size.height > size.width ? size.height / 5 : size.width / 8,
              ),
              child: Align(
                alignment: Alignment.center,
                child: Stack(
                  children: [
                    Align(
                        alignment: Alignment.center,
                        child: Lottie.asset('assets/images/videocall.json')),
                    Align(
                      alignment: Alignment.center,
                      child: CircleAvatar(
                        backgroundImage: widget.bot.photo != null
                            ? NetworkImage(widget.bot.photo!)
                            : AssetImage(nullPhoto) as ImageProvider,
                        radius: size.height > size.width
                            ? size.height / 10
                            : size.width / 10,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            RemoteCameraView(size: size), //remote video
            //============================

            LocalCameraView(size: size), //local camera

            CountdownTimer(
              onEnd: () => Navigator.of(context).pop(),
              endTime: endTime,
              widgetBuilder: (context, time) {
                log('$time');
                HapticFeedback.heavyImpact();
                if (time == null) {
                  WidgetsBinding.instance.addPostFrameCallback((_) {});
                  return Container();
                } else {
                  return Text(
                      '${(time.hours == null) ? "00" : time.hours}:${(time.min == null) ? "00" : time.min}:${(time.sec == null) ? "00" : time.sec}');
                }
              },
            ),
            VideoCallButtons(size: size),
          ],
        ),
      ),
    );
  }
}

class VideoCallButtons extends StatelessWidget {
  const VideoCallButtons({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(bottom: size.height / 17),
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Container(
          width:
              size.height > size.width ? size.height / 2.5 : size.width / 2.5,
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(10),
                    backgroundColor: Colors.white, // <-- Button color
                    foregroundColor: Colors.black, // <-- Splash color
                  ),
                  onPressed: () {
                    HapticFeedback.heavyImpact().timeout(Duration(minutes: 3));
                  },
                  child: Icon(Icons.mic)),
              BlocBuilder<VideocallBloc, VideocallState>(
                builder: (context, state) {
                  if (state is VideocallingState) {
                    return ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          shape: CircleBorder(),
                          padding: EdgeInsets.all(20),
                          backgroundColor: Colors.red, // <-- Button color
                          foregroundColor: Colors.black, // <-- Splash color
                        ),
                        onPressed: () {
                          leave(agoraEngine: state.agoraEngine);
                        },
                        child: Icon(Icons.video_call));
                  } else {
                    return Text("data");
                  }
                },
              ),
              ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    shape: CircleBorder(),
                    padding: EdgeInsets.all(10),
                    backgroundColor: Colors.white, // <-- Button color
                    foregroundColor: Colors.black, // <-- Splash color
                  ),
                  onPressed: () {},
                  child: Icon(Icons.camera_alt_outlined))
            ],
          ),
        ),
      ),
    );
  }
}

class RemoteCameraView extends StatelessWidget {
  const RemoteCameraView({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      child: Container(
        decoration: BoxDecoration(borderRadius: BorderRadius.circular(15)),
        width: size.width,
        height: size.height,
        child: BlocBuilder<VideocallBloc, VideocallState>(
          builder: (context, state) {
            if (state is VideocallingState) {
              return _remoteVideo(
                  remoteUid: state.remoteUid,
                  agoraEngine: state.agoraEngine,
                  channelName: state.channelName,
                  isJoined: state.isJoined);
            } else {
              return SizedBox();
            }
          },
        ),
      ),
    );
  }
}

class LocalCameraView extends StatelessWidget {
  const LocalCameraView({
    super.key,
    required this.size,
  });

  final Size size;

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.bottomLeft,
      child: Padding(
        padding: const EdgeInsets.only(bottom: 80, left: 10),
        child: InkWell(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(15),
            ),
            width:
                size.height > size.width ? size.width / 3.8 : size.width / 4.7,
            height:
                size.height > size.width ? size.height / 5 : size.height / 3.8,
            child: BlocBuilder<VideocallBloc, VideocallState>(
              builder: (context, state) {
                if (state is VideocallingState) {
                  return _localPreview(
                      isLocalJoined: state.isLocalJoined,
                      agoraEngine: state.agoraEngine,
                      localUid: state.localUid);
                } else {
                  return SizedBox();
                }
              },
            ),
          ),
        ),
      ),
    );
  }
}

void leave({required RtcEngine agoraEngine}) {
  agoraEngine.leaveChannel();
  agoraEngine.release();
}

Widget _remoteVideo(
    {int? remoteUid,
    required RtcEngine agoraEngine,
    required String channelName,
    required bool isJoined}) {
  if (remoteUid != null) {
    return AgoraVideoView(
      controller: VideoViewController.remote(
        rtcEngine: agoraEngine,
        canvas: VideoCanvas(
            uid: remoteUid, renderMode: RenderModeType.renderModeFit),
        connection: RtcConnection(channelId: channelName),
      ),
    );
  } else {
    String msg = '';
    if (isJoined) msg = 'Waiting for a remote user to join';
    return Text(
      msg,
      textAlign: TextAlign.center,
    );
  }
}

// Display local video preview
Widget _localPreview(
    {required bool isLocalJoined,
    required RtcEngine agoraEngine,
    required int? localUid}) {
  if (isLocalJoined) {
    return AgoraVideoView(
      controller: VideoViewController(
        rtcEngine: agoraEngine,
        canvas: VideoCanvas(uid: 0, renderMode: RenderModeType.renderModeFit),
      ),
    );
  } else {
    return const Text(
      'Join a channel',
      textAlign: TextAlign.center,
    );
  }
}
