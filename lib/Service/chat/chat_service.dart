import 'dart:async';
import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

class ChatService {
  //send request
  Future sendRequest(String botID) async {
    final String currentUser = FirebaseAuth.instance.currentUser!.uid;
    //add users database
    bool isExistInRequest = false;
    final result = await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser)
        .collection("request")
        .get();
    for (var doc in result.docs) {
      if (doc.data()["userId"] == botID) {
        isExistInRequest = true;
      }
    }
    if (!isExistInRequest) {
      await FirebaseFirestore.instance
          .collection("users")
          .doc(botID)
          .collection("request")
          .doc(currentUser)
          .set({"userId": currentUser, "time": FieldValue.serverTimestamp()});
      await FirebaseFirestore.instance
          .collection("users")
          .doc(currentUser)
          .collection("sendRequest")
          .doc(botID)
          .set({"userId": botID, "time": FieldValue.serverTimestamp()});
      log("send req done");
    }
  }

  Future<String> onCreateRoomId(String botUid) async {
    final String currentUser = FirebaseAuth.instance.currentUser!.uid;
    if (botUid.codeUnits[0] > currentUser.codeUnits[0]) {
      String roomId = "$botUid$currentUser";
      log(" trur  $botUid and $currentUser");
      return roomId;
    } else {
      String roomId = "$currentUser$botUid";
      log(" flas  $currentUser and $botUid");
      return roomId;
    }
  }

  Future onMessaging({required String message, required String roomID}) async {
    final String currentUser = FirebaseAuth.instance.currentUser!.uid;
    log(" on message log $roomID");
    Map<String, dynamic> messages = {
      "message": message,
      "sendby": currentUser,
      "time": FieldValue.serverTimestamp(),
      "isread": false
    };
    await FirebaseFirestore.instance
        .collection("chatroom")
        .doc(roomID)
        .collection("chats")
        .add(messages);
    await FirebaseFirestore.instance
        .collection('chatroom')
        .doc(roomID)
        .set({currentUser: true});
  }

  Future<dynamic> fetchmessages({required String roomID}) async {
    List<QueryDocumentSnapshot<Map<String, dynamic>>>? messages;

    try {
      FirebaseFirestore.instance
          .collection("chatroom")
          .doc(roomID)
          .collection("chats")
          .snapshots()
          .listen((event) {
        messages = event.docs;
      });

      return messages;
    } on FirebaseException catch (e) {
      log(e.code);
      return e.code;
    }
  }

  ///accept request and add uid to connection
  ///remove uid from request ,sendRequest
  Future connnections(String botUid) async {
    final String currentUser = FirebaseAuth.instance.currentUser!.uid;
    //current user side
    FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser)
        .collection("connections")
        .doc(botUid)
        .set({"unread": "count", "botid": botUid});
    FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser)
        .collection("request")
        .doc(botUid)
        .delete();
//other side
    FirebaseFirestore.instance
        .collection("users")
        .doc(botUid)
        .collection("connections")
        .doc(currentUser)
        .set({"unread": "count", "botid": currentUser});
    FirebaseFirestore.instance
        .collection("users")
        .doc(botUid)
        .collection("sendRequest")
        .doc(currentUser)
        .delete();
    log("connection done");
  }

  //remove request
  Future removeRequest(String botUid) async {
    final String currentUser = FirebaseAuth.instance.currentUser!.uid;
    // currrent user side
    await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser)
        .collection("sendRequest")
        .doc(botUid)
        .delete();
    //other user side
    await FirebaseFirestore.instance
        .collection("users")
        .doc(botUid)
        .collection("request")
        .doc(currentUser)
        .delete();
    log("function remove request done");
  }

  //decline req
  Future diclineRequest(String botUid) async {
    final String currentUser = FirebaseAuth.instance.currentUser!.uid;
    // currrent user side
    await FirebaseFirestore.instance
        .collection("users")
        .doc(currentUser)
        .collection("request")
        .doc(botUid)
        .delete();
    //other user side
    await FirebaseFirestore.instance
        .collection("users")
        .doc(botUid)
        .collection("sendRequest")
        .doc(currentUser)
        .delete();
    log("function remove request done");
  }

  Future unReadCount() async {
    final String currentUser = FirebaseAuth.instance.currentUser!.uid;
    QuerySnapshot<Map<String, dynamic>> result = await FirebaseFirestore
        .instance
        .collection("users")
        .doc(currentUser)
        .collection("connections")
        .get();
    for (var connection in result.docs) {
      String roomId = await onCreateRoomId(connection.get('botid'));
      QuerySnapshot<Map<String, dynamic>> messages = await FirebaseFirestore
          .instance
          .collection("chatroom")
          .doc(roomId)
          .collection("chats")
          .get();
      for (var element in messages.docs) {}
    }
  }
}
