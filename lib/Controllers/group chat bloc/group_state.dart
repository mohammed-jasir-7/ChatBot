part of 'group_bloc.dart';

abstract class GroupState extends Equatable {
  const GroupState();

  @override
  List<Object> get props => [];
}

class GroupchatInitial extends GroupState {}

class LoadingState extends GroupState {}

//provide group data
class GroupListState extends GroupState {
  final List<GroupModel> groups;

  const GroupListState({required this.groups});
}

class SuccessState extends GroupState {}
