part of 'msgpermission_cubit.dart';

enum MsgPermisson { allow, denied }

class MsgpermissionState extends Equatable {
  const MsgpermissionState();

  @override
  List<Object> get props => [];
}

class MsgpermissionInitial extends MsgpermissionState {}

class PermissionState extends MsgpermissionState {
  final MsgPermisson permission;
  final bool adminOnly;

  const PermissionState({required this.permission, required this.adminOnly});
  @override
  List<Object> get props => [permission, adminOnly];
}
