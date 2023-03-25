import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:injectable/injectable.dart';
import 'group_service.dart';

@LazySingleton(as: GroupServices)
class GroupRepository implements GroupServices {
  @override
  Future<dynamic> addMember(
      {required List<String> members,
      required String groupId,
      required String gName}) async {
    final db = FirebaseFirestore.instance.batch();
    //added in users collection's collection
    for (var member in members) {
      db.set(
        FirebaseFirestore.instance
            .collection("users")
            .doc(member)
            .collection("groups")
            .doc(groupId),
        {
          "groupId": groupId,
          "name": gName,
        },
      );
      // add to group members to collecton
      db.set(
          FirebaseFirestore.instance
              .collection("groupChat")
              .doc(groupId)
              .collection("members")
              .doc(member),
          {
            "botId": member,
            "isAdmin": false,
            "isOwner": false,
          });
    }
    dynamic result = false;
    try {
      db.commit();
      result = true;
    } on FirebaseException catch (e) {
      result = e.code;
    }

    return result;
  }

  @override
  Future removeAdmin(
      {required String groupId, required String selectedId}) async {
    log("removed admin");
    await FirebaseFirestore.instance
        .collection("groupChat")
        .doc(groupId)
        .collection("members")
        .doc(selectedId)
        .update({"isAdmin": false});
    log("removed admin");
  }

  @override
  Future removeMember(
      {required String groupId, required String selectedId}) async {
    final db = FirebaseFirestore.instance.batch();

    //delete in group
    db.delete(FirebaseFirestore.instance
        .collection("groupChat")
        .doc(groupId)
        .collection("members")
        .doc(selectedId));
    //delete in user sisde
    db.delete(FirebaseFirestore.instance
        .collection("users")
        .doc(selectedId)
        .collection("groups")
        .doc(groupId));
    db.commit();
  }

// make admin
  @override
  Future makeAdmin(
      {required String groupId, required String selectedId}) async {
    await FirebaseFirestore.instance
        .collection("groupChat")
        .doc(groupId)
        .collection("members")
        .doc(selectedId)
        .update({"isAdmin": true});
  }

  @override
  Future adminOnlyMssage(
      {required String groupId, required bool currentState}) async {
    await FirebaseFirestore.instance
        .collection("groupChat")
        .doc(groupId)
        .update({"adminOnlyMessage": !currentState});
    log("updated adminnnnn   dd ${!currentState}");
  }

  @override
  Future exitGroup(
      {required String groupId, required String currentUserId}) async {
    try {
      final db = FirebaseFirestore.instance.batch();
      db.delete(FirebaseFirestore.instance
          .collection("groupChat")
          .doc(groupId)
          .collection("members")
          .doc(currentUserId));
      db.delete(FirebaseFirestore.instance
          .collection("users")
          .doc(currentUserId)
          .collection("groups")
          .doc(groupId));
      await db.commit();
    } on FirebaseException catch (e) {
      return e.code;
    }
    return true;
  }

  @override
  Future dismissGroup({required String groupId}) async {
    final db = FirebaseFirestore.instance.batch();
    final members = await FirebaseFirestore.instance
        .collection("groupChat")
        .doc(groupId)
        .collection("members")
        .get();
    for (var member in members.docs) {
      db.delete(FirebaseFirestore.instance
          .collection("users")
          .doc(member.data()["botId"])
          .collection("groups")
          .doc(groupId));
    }
    db.delete(FirebaseFirestore.instance.collection("groupChat").doc(groupId));

    await db.commit();
  }
}
