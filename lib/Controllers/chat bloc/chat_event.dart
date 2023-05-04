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
  List<Object?> get props => [];
}

class FetchmessagesEvent extends ChatEvent {
  @override
  List<Object?> get props => [];
}

class OnlineEvent extends ChatEvent {
  @override
  List<Object?> get props => [];
}

class OfflineEvent extends ChatEvent {
  @override
  List<Object?> get props => [];
}

//intitial event
class ChatInitialEvent extends ChatEvent {
  @override
  List<Object?> get props => [];
}

//chat supply to ui
class ProvideChatEvent extends ChatEvent {
  final List<PersonalMsgModel> allMessages;

  const ProvideChatEvent({required this.allMessages});
  @override
  List<Object?> get props => [allMessages];
}

class ChatLoadingEvent extends ChatEvent {
  final String roomId;

  ChatLoadingEvent(this.roomId);

  @override
  // TODO: implement props
  List<Object?> get props => [roomId];
}
