part of 'users_bloc.dart';

abstract class UsersState extends Equatable {
  const UsersState();
}

class UsersInitial extends UsersState {
  @override
  List<Object?> get props => [];
}

class RequestState extends UsersState {
  @override
  List<Object?> get props => [];
}

class PendingState extends UsersState {
  @override
  List<Object?> get props => [];
}

class AcceptedState extends UsersState {
  @override
  List<Object?> get props => [];
}

class ConnectedUsers extends UsersState {
  final List<Bot> bots;

  const ConnectedUsers(this.bots);
  @override
  List<Object?> get props => [];
}

class RequestUsers extends UsersState {
  final List<Bot> bots;

  const RequestUsers(this.bots);
  @override
  List<Object?> get props => [];
}

class OtherUsers extends UsersState {
  final List<Bot> bots;

  const OtherUsers({required this.bots});
  @override
  List<Object?> get props => [];
}

class LoadingState extends UsersState {
  @override
  List<Object?> get props => [];
}
