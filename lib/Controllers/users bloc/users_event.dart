part of 'users_bloc.dart';

abstract class UsersEvent extends Equatable {
  const UsersEvent();
}

/// send req event
class SendRequestEvent extends UsersEvent {
  final String botId;

  const SendRequestEvent({required this.botId});
  @override
  List<Object?> get props => [];
}

class AcceptRequestEvent extends UsersEvent {
  final String botId;

  const AcceptRequestEvent({required this.botId});
  @override
  List<Object?> get props => [];
}

class DeclineRequestevent extends UsersEvent {
  final String botId;

  const DeclineRequestevent({required this.botId});
  @override
  List<Object?> get props => [];
}

class RemoveRequestEvent extends UsersEvent {
  final String botId;

  const RemoveRequestEvent({required this.botId});
  @override
  List<Object?> get props => [];
}

class UsersListEvent extends UsersEvent {
  const UsersListEvent();
  @override
  List<Object?> get props => [];
}

class ProvidUserListEvent extends UsersEvent {
  final List<Bot> alluser;

  const ProvidUserListEvent({required this.alluser});
  @override
  List<Object?> get props => [alluser];
}
