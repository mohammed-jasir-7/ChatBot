part of 'groupchat_bloc.dart';

abstract class GroupchatEvent extends Equatable {
  const GroupchatEvent();

  @override
  List<Object> get props => [];
}

class CreateGroup extends GroupchatBloc {
  final List<String> botsId;

  CreateGroup({required this.botsId});
}
