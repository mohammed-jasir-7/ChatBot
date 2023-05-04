part of 'chat_bloc.dart';

abstract class ChatState extends Equatable {
  const ChatState();
}

class ChatInitial extends ChatState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class ChatFirstState extends ChatState {
  final Bot bot;
  final String roomID;

  ChatFirstState({required this.bot, required this.roomID});

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class LoadingState extends ChatState {
  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ChatData extends ChatState {
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> chats;

  const ChatData({required this.chats});

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

//supply all messages to ui
class PovideAllMessageState extends ChatState {
  final List<PersonalMsgModel> allMessages;

  const PovideAllMessageState({required this.allMessages});

  @override
  // TODO: implement props
  List<Object?> get props => [allMessages];
}
