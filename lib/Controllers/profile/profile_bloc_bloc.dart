import 'dart:developer';

import 'package:chatbot/Service/profile%20service/profile_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Models/user_model.dart';

part 'profile_bloc_event.dart';
part 'profile_bloc_state.dart';

class ProfileBlocBloc extends Bloc<ProfileBlocEvent, ProfileBlocState> {
  final profileService = ProfileService();
  final uid = FirebaseAuth.instance.currentUser!.uid;
  ProfileBlocBloc() : super(ProfileBlocInitial()) {
    Bot? user;
    on<LoadingProfileEvent>(
      (event, emit) async {
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
      final result = await profileService.selectImage();
      final IsUploaded = await profileService.uploadFile(result);
      if (IsUploaded) {
        emit(UpdateSuccessState());
      } else {
        emit(UpdateErorrState());
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
