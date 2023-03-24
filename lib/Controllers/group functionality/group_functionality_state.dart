part of 'group_functionality_bloc.dart';

abstract class GroupFunctionalityState extends Equatable {
  const GroupFunctionalityState();
  @override
  List<Object?> get props => [];
}

class MembersLoadedState extends GroupFunctionalityState {
  bool isloading;
  List<GroupMember>? members;
  GroupMember? currentUser;
  @override
  // TODO: implement props
  List<Object?> get props => [isloading, members, currentUser];
  MembersLoadedState(
      {required this.isloading,
      required this.members,
      required this.currentUser});

  MembersLoadedState.initial({required this.isloading, this.members});
}

class ProvideUserListState extends GroupFunctionalityState {
  bool isLoading;
  List<SelectModel>? user;

  ProvideUserListState({this.user, required this.isLoading});
  @override
  List<Object?> get props => [isLoading, user];
}
