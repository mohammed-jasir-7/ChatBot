part of 'group_functionality_bloc.dart';

abstract class GroupFunctionalityEvent extends Equatable {
  const GroupFunctionalityEvent();

  @override
  List<Object> get props => [];
}

// fetch All members
class FetchMembersEvent extends GroupFunctionalityEvent {
  final String groupId;

  const FetchMembersEvent({required this.groupId});
}

class ProvideMembrsEvent extends GroupFunctionalityEvent {
  final List<GroupMember> members;
  final GroupMember? currentUser;

  const ProvideMembrsEvent({required this.members, required this.currentUser});
}

class AddMembersEvent extends GroupFunctionalityEvent {
  //final List<SelectModel> selectedMembers;
  final String groupId;

  const AddMembersEvent({required this.groupId});
}

//add members to firebase
class AddMembersToDbEvent extends GroupFunctionalityEvent {
  final List<SelectModel> selectedBots;
  final String groupId;
  final String gName;

  const AddMembersToDbEvent(
      {required this.selectedBots, required this.groupId, required this.gName});
}

//make admin
class MakeAdminEvent extends GroupFunctionalityEvent {
  final String selectedId;
  final String groupId;

  const MakeAdminEvent({required this.selectedId, required this.groupId});
}

//remove as admin
class RemoveAsAdmin extends GroupFunctionalityEvent {
  final String selectedId;
  final String groupId;

  const RemoveAsAdmin({required this.selectedId, required this.groupId});
}

class RemoveUserEvent extends GroupFunctionalityEvent {
  final String selectedId;
  final String groupId;

  const RemoveUserEvent({required this.selectedId, required this.groupId});
}

class FetchCurrentUserEvent extends GroupFunctionalityEvent {
  final String groupId;

  const FetchCurrentUserEvent({required this.groupId});
}

//admin only messagge
class AdminOnlyMessageEvent extends GroupFunctionalityEvent {
  final String groupId;
  final bool currentState;

  const AdminOnlyMessageEvent(
      {required this.groupId, required this.currentState});
}
