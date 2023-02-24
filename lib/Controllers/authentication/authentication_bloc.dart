import 'dart:async';
import 'dart:developer';

import 'package:chatbot/Service/authentication/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
part 'authentication_event.dart';
part 'authentication_state.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  UserCredential? user;
  AuthenticationBloc() : super(AuthenticationInitial()) {
    on<LoadLoginScreenEvent>((event, emit) {
      emit(LoginState());
    });
    on<LoadSignUpScreenEvent>((event, emit) {
      emit(SignUpState());
    });
    on<SignUpEvent>((event, emit) async {
      dynamic isSigned = await AuthService.signin(
          email: event.email, password: event.password);
      String? sendVerificationEmailError =
          await AuthService.sendVerificationEmail();
      if (isSigned is UserCredential) {
        user = isSigned;
        //emit(SignedState(isSigned: isSigned));
      } else {
        add(LoadSignUpScreenEvent());
        emit(ValidationErrorState(exceptionOnLogin: isSigned));
      }
      if (sendVerificationEmailError != null) {
        add(LoadSignUpScreenEvent());
        emit(
            ValidationErrorState(exceptionOnLogin: sendVerificationEmailError));
      }
    });
    on<VerifiedUserEvent>((event, emit) => emit(SignedState(isSigned: user!)));

    //login
    on<LoginEvent>((event, emit) async {
      dynamic isLogged = await AuthService.logIn(
        email: event.email,
        password: event.password,
      );

      if (isLogged is bool) {
        emit(LoggedState(isLogged: isLogged));
      } else {
        add(LoadLoginScreenEvent());
        emit(ValidationErrorState(exceptionOnLogin: isLogged));
      }
    });
  }

  // Future<Timer> verification(
  //     User? user, Emitter<AuthenticationState> emit) async {
  //   return Timer.periodic(Duration(seconds: 15), (timer) async {
  //     log("hello");

  //     await user!.reload().then((value) {
  //       user = FirebaseAuth.instance.currentUser;
  //       log("reload");
  //       // if (timer.tick <= 500) {
  //       //   timer.cancel();
  //       // }
  //     });
  //   });
  // }
}
