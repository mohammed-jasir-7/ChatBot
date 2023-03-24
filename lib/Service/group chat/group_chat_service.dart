import 'dart:developer';

import 'package:chatbot/Service/profile%20service/profile_service.dart';
import 'package:chatbot/injectable.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';

@LazySingleton()
class GroupChatService {
  Future createGroup(
      {required List<String> users,
      required String name,
      FilePickerResult? image}) async {
    await FirebaseAuth.instance.currentUser!.reload();
    final currentUser = FirebaseAuth.instance.currentUser!.uid;
    final groupId = const Uuid().v1();
    final batch = FirebaseFirestore.instance.batch();

    //setcurrent user side
    batch.set(
        FirebaseFirestore.instance
            .collection("users")
            .doc(currentUser)
            .collection("groups")
            .doc(groupId),
        {
          "groupId": groupId,
          "name": name,
        });
    for (var user in users) {
      batch.set(
        FirebaseFirestore.instance
            .collection("users")
            .doc(user)
            .collection("groups")
            .doc(groupId),
        {
          "groupId": groupId,
          "name": name,
        },
      );
    }
    //group collection creataing
    batch.set(FirebaseFirestore.instance.collection("groupChat").doc(groupId), {
      "groupId": groupId,
      "createdby": currentUser,
      "time": FieldValue.serverTimestamp(),
      "adminOnlyMessage": false,
      "image": null,
      "name": name,
      "lastMsg": "group created",
      "sendby": ""
    });
    //add members
    batch.set(
        FirebaseFirestore.instance
            .collection("groupChat")
            .doc(groupId)
            .collection("members")
            .doc(currentUser),
        {
          "botId": currentUser,
          "isAdmin": true,
          "isOwner": true,
        });
    for (var user in users) {
      batch.set(
          FirebaseFirestore.instance
              .collection("groupChat")
              .doc(groupId)
              .collection("members")
              .doc(user),
          {
            "botId": user,
            "isAdmin": false,
            "isOwner": false,
          });
    }
    await batch.commit();
    //image upload
    if (image != null) {
      await getIt<ProfileService>()
          .uploadFile(image, groupId, "groupChat", groupId);
    }
    log(" create group commit done");
  }

  //send messages=======================================================================
  Future sendMessage(
      {required String message,
      required String groupId,
      required String currentUser,
      required String userName,
      String? image}) async {
    //ref
    final ref = FirebaseFirestore.instance.collection("groupChat").doc(groupId);
    //add to db
    await ref.collection("chat").add({
      "message": message,
      "isRead": false,
      "sendby": currentUser,
      "time": FieldValue.serverTimestamp(),
      "userName": userName,
      "image": image
    });
    await ref.update({"lastMsg": message, "sendby": userName});
    log(currentUser);
  }
}
