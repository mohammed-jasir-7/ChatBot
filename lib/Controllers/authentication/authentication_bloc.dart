import 'dart:developer';

import 'package:chatbot/Service/authentication/authentication.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
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
      log("sign in check");
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
    //check verified or not
    //after trigger this event
    on<VerifiedUserEvent>((event, emit) {
      // add to database(realtime database)

      final database = FirebaseDatabase.instance.ref("users");
      if (user!.additionalUserInfo!.isNewUser == true) {
        database.child(user!.user!.uid).set({
          "username": user!.user!.email,
          "photo": user!.additionalUserInfo!.profile!['picture'],
          "email": user!.user!.email
        });
      }
      //=================================
      log("verified event");

      emit(SignedState(isSigned: user!));
    });

    //login
    on<LoginEvent>((event, emit) async {
      dynamic isLogged = await AuthService.logIn(
        email: event.email,
        password: event.password,
      );

      log("log1");
      if (isLogged is bool) {
        log("log2");
        emit(LoggedState(isLogged: isLogged));
      } else {
        add(LoadLoginScreenEvent());
        emit(ValidationErrorState(exceptionOnLogin: isLogged));
      }
    });
    on<GoogleSignInEvent>((event, emit) async {
      emit(LoadingState(isLoading: true));
      final result = await AuthService.googleSignIn();
      if (result is UserCredential) {
        emit(LoadingState(isLoading: false));
        // add(LoadSignUpScreenEvent());
        emit(SignedState(isSigned: result));
        log("google event");
      } else {
        emit(ValidationErrorState(exceptionOnLogin: result));
      }
    });
  }
}
