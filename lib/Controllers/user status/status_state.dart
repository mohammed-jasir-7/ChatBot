part of 'status_cubit.dart';

abstract class StatusState extends Equatable {
  const StatusState();

  @override
  List<Object> get props => [];
}

class StatusInitial extends StatusState {}

class OnlineState extends StatusState {
  @override
  List<Object> get props => [];
}

class OfflineState extends StatusState {
  @override
  List<Object> get props => [];
}
