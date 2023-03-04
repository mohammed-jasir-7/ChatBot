part of 'chat_bloc.dart';

abstract class ChatEvent extends Equatable {
  const ChatEvent();
}

class EnterToChatEvent extends ChatEvent {
  final Bot bot;

  EnterToChatEvent({required this.bot});

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class SendMessageEvent extends ChatEvent {
  final String messages;
  String roomID;

  SendMessageEvent({required this.messages, required this.roomID});

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class FetchmessagesEvent extends ChatEvent {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}
