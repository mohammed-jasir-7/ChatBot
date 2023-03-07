part of 'profile_bloc_bloc.dart';

abstract class ProfileBlocEvent extends Equatable {
  const ProfileBlocEvent();

  @override
  List<Object> get props => [];
}

class UpdatedEvent extends ProfileBlocEvent {}

class UpdateFileEvent extends ProfileBlocEvent {}

class LoadingProfileEvent extends ProfileBlocEvent {}
