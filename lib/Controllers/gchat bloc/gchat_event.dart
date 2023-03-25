part of 'gchat_bloc.dart';

abstract class GchatEvent extends Equatable {
  const GchatEvent();

  @override
  List<Object> get props => [];
}

// send message event
class SendMessageEvent extends GchatEvent {
  final String message;
  final String groupId;

  const SendMessageEvent({required this.message, required this.groupId});
}

class FetchMessageEvent extends GchatEvent {
  final String groupId;

  const FetchMessageEvent({required this.groupId});
}

class ProvideDataToGroupEvent extends GchatEvent {
  final List<GroupMsgModel> allmessages;
  final GroupMember? currentUser;

  const ProvideDataToGroupEvent({required this.allmessages, this.currentUser});
}

//initial
class GchatInitialEvent extends GchatEvent {}
