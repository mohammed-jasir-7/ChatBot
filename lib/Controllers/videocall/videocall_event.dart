part of 'videocall_bloc.dart';

abstract class VideocallEvent extends Equatable {
  const VideocallEvent();

  @override
  List<Object> get props => [];
}

// initial event
//calling event
class VideocallingEvent extends VideocallEvent {
  final String botId;

  const VideocallingEvent({required this.botId});
}

class ClientJoinedEvent extends VideocallEvent {
  final RtcEngine agoraEngine;
  bool isJoined;
  bool isLocalJoined;
  int? remoteUid;
  String? rrr;
  int? localUid;
  final String channelName;
  String? localusername;

  ClientJoinedEvent(
      {required this.agoraEngine,
      required this.channelName,
      this.isJoined = false,
      this.remoteUid,
      this.localUid,
      this.isLocalJoined = false,
      this.localusername});
}

class LeavecallEvent extends VideocallEvent {}

class CallAcceptEvent extends VideocallEvent {
  final String channelname;

  const CallAcceptEvent({required this.channelname});
}
