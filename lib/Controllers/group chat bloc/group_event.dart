part of 'group_bloc.dart';

abstract class GroupEvent extends Equatable {
  const GroupEvent();

  @override
  List<Object> get props => [];
}

class CreateGroupEvent extends GroupEvent {
  final List<SelectModel> botsId;
  FilePickerResult? image;
  final String name;

  CreateGroupEvent({required this.botsId, required this.name, this.image});
}

class FetchGroupsEvent extends GroupEvent {}

class ProvideGroupsEvent extends GroupEvent {}

//initial event
class GroupInitialEvent extends GroupEvent {}
