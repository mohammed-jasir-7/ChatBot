part of 'profile_bloc_bloc.dart';

abstract class ProfileBlocState extends Equatable {
  const ProfileBlocState();
}

class ProfileBlocInitial extends ProfileBlocState {
  @override
  List<Object?> get props => [];
}

class LoadingState extends ProfileBlocState {
  @override
  List<Object?> get props => [];
}

class LoadCurrentUserState extends ProfileBlocState {
  final Bot currentUser;

  const LoadCurrentUserState({required this.currentUser});

  @override
  // TODO: implement props
  List<Object?> get props => [currentUser];
}

class UpdatedState extends ProfileBlocState {
  final Bot currentUser;

  const UpdatedState({required this.currentUser});

  @override
  // TODO: implement props
  List<Object?> get props => [currentUser];
}

class UpdateSuccessState extends ProfileBlocState {
  @override
  // TODO: implement props
  List<Object?> get props => throw UnimplementedError();
}

class UpdateErorrState extends ProfileBlocState {
  final String messages;

  const UpdateErorrState({required this.messages});
  @override

  // TODO: implement props
  List<Object?> get props => [];
}
