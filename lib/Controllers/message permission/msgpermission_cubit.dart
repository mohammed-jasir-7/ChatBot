import 'dart:async';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';

part 'msgpermission_state.dart';

class MsgpermissionCubit extends Cubit<MsgpermissionState> {
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;
  final String groupId;
  late final StreamSubscription combinedStream;
  MsgpermissionCubit({
    required this.firebaseAuth,
    required this.groupId,
    required this.firestore,
  }) : super(MsgpermissionInitial()) {
    final groupData =
        firestore.collection("groupChat").doc(groupId).snapshots();
    final currentMember = firestore
        .collection("groupChat")
        .doc(groupId)
        .collection("members")
        .doc(firebaseAuth.currentUser!.uid)
        .snapshots();
    combinedStream =
        CombineLatestStream.list([currentMember, groupData]).listen((value) {
      if (value[1].data() != null) {
        if (value[1].data()!["adminOnlyMessage"]) {
          if (value[0].data()!["isAdmin"]) {
            emit(PermissionState(
                permission: MsgPermisson.allow,
                adminOnly: value[1].data()!["adminOnlyMessage"]));
          } else {
            emit(PermissionState(
                permission: MsgPermisson.denied,
                adminOnly: value[1].data()!["adminOnlyMessage"]));
          }
        } else {
          emit(PermissionState(
              permission: MsgPermisson.allow,
              adminOnly: value[1].data()!["adminOnlyMessage"]));
        }
      }
    });
  }
  @override
  Future<void> close() async {
    combinedStream.cancel();
    return super.close();
  }
}
