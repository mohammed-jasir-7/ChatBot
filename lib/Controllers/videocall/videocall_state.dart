part of 'videocall_bloc.dart';

abstract class VideocallState extends Equatable {
  const VideocallState();

  @override
  List<Object?> get props => [];
}

class VideocallInitial extends VideocallState {}

class VideocallingState extends VideocallState {
  final RtcEngine agoraEngine;
  bool isJoined;
  bool isLocalJoined;
  int? remoteUid;
  int? localUid;
  final String channelName;

  VideocallingState(
      {required this.agoraEngine,
      required this.channelName,
      this.isJoined = false,
      this.remoteUid,
      this.localUid,
      this.isLocalJoined = false});

  @override
  List<Object?> get props =>
      [agoraEngine, isJoined, remoteUid, channelName, localUid, isLocalJoined];
}

class ConnectingState extends VideocallState {}

class LeavecallState extends VideocallState {}
