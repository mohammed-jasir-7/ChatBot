import 'dart:developer';

import 'package:chatbot/Service/profile%20service/profile_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

import 'package:firebase_auth/firebase_auth.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Models/user_model.dart';

part 'profile_bloc_event.dart';
part 'profile_bloc_state.dart';

class ProfileBlocBloc extends Bloc<ProfileBlocEvent, ProfileBlocState> {
  final ProfileService profileService;
  final uid = FirebaseAuth.instance.currentUser!.uid;
  Bot? user;
  ProfileBlocBloc({required this.profileService})
      : super(ProfileBlocInitial()) {
    on<LoadingProfileEvent>(
      (event, emit) async {
        emit(LoadingState());
        final currentUser = await FirebaseFirestore.instance
            .collection("users")
            .doc(FirebaseAuth.instance.currentUser!.uid)
            .get();

        user = Bot(
            uid: FirebaseAuth.instance.currentUser!.uid,
            email: currentUser.get("email"),
            photo: currentUser.get("photo"),
            username: currentUser.get("userName"));
        log("loading profile event ${user!.email}");
        emit(LoadCurrentUserState(currentUser: user!));
      },
    );

    /// updated event
    on<UpdateFileEvent>((event, emit) async {
      ///select image file and
      ///upload image its return boo;
      emit(LoadingState());
      final result = await profileService.selectImage();
      final isUploaded = await profileService.uploadFile(result);
      if (isUploaded == null) {
        emit(UpdateSuccessState());
      } else {
        emit(UpdateErorrState(messages: isUploaded));
      }
      FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .snapshots()
          .listen((event) {
        log(event.get("photo"));
        user = Bot(
            uid: uid,
            email: event.get("email"),
            photo: event.get("photo"),
            username: event.get("userName"));

        add(UpdatedEvent());
      });
    });
    on<UpdatedEvent>((event, emit) {
      if (user != null) {
        log("updated event ${user!.email}");
        emit(LoadCurrentUserState(currentUser: user!));
      }
    });
  }
}
