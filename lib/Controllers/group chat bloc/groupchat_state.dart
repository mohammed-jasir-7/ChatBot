part of 'groupchat_bloc.dart';

abstract class GroupchatState extends Equatable {
  const GroupchatState();

  @override
  List<Object> get props => [];
}

class GroupchatInitial extends GroupchatState {}
