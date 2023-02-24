part of 'authentication_bloc.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();
}

class SignUpEvent extends AuthenticationEvent {
  final String email;
  final String password;
  const SignUpEvent({required this.email, required this.password});
  @override
  List<Object?> get props => throw UnimplementedError();
}

//after verified trigger this event
class VerifiedUserEvent extends AuthenticationEvent {
  @override
  List<Object?> get props => [];
}

class LoginEvent extends AuthenticationEvent {
  final String email;
  final String password;
  const LoginEvent({required this.email, required this.password});
  @override
  List<Object?> get props => [];
}

class LoadLoginScreenEvent extends AuthenticationEvent {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class LoadSignUpScreenEvent extends AuthenticationEvent {
  @override
  List<Object?> get props => throw UnimplementedError();
}
