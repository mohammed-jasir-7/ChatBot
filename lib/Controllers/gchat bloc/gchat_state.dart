part of 'gchat_bloc.dart';

abstract class GchatState extends Equatable {
  const GchatState();

  @override
  List<Object> get props => [];
}

class LoadingState extends GchatState {}

class GchatInitial extends GchatState {}

class AllMessageState extends GchatState {
  final List<GroupMsgModel> allmessages;
  final GroupMember? members;
  final String currentUsername;

  const AllMessageState({
    required this.allmessages,
    required this.members,
    required this.currentUsername,
  });
}
