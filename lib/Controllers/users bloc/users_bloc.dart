import 'dart:developer';

import 'package:chatbot/Models/user_model.dart';
import 'package:chatbot/util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../Service/chat/chat_service.dart';

part 'users_event.dart';
part 'users_state.dart';

class UsersBloc extends Bloc<UsersEvent, UsersState> {
  UsersBloc() : super(UsersInitial()) {
    List<Bot> allUser = [];
    final chatService = ChatService();
    on<UsersListEvent>((event, emit) async {
      log("userlist event");
      emit(LoadingState());

      final request = await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("request")
          .get();
      final sendRequest = await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("sendRequest")
          .get();
      final connections = await FirebaseFirestore.instance
          .collection("users")
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .collection("connections")
          .get();
      log("   ${request.docs}");
      FirebaseFirestore.instance
          .collection("users")
          .snapshots()
          .listen((event) {
        List<Bot> temp = [];
        for (var element in event.docs) {
          int flag = 0;
          if (FirebaseAuth.instance.currentUser?.uid !=
              element.data()["userId"]) {
            if (request.docs.isNotEmpty) {
              //checking  user in request list
              for (var req in request.docs) {
                log("entered all user itration ${req.data()["userId"]}");
                if (element.data()["userId"] == req.data()["userId"]) {
                  log("enterddd at req ${element.data()["userId"]}");
                  temp.add(Bot(
                      uid: element.data()["userId"],
                      email: element.data()["email"],
                      state: BotsState.request,
                      photo: element.data()["photo"] ??
                          "assets/images/nullPhoto.jpeg",
                      username: element.data()["userName"] ?? ""));
                  flag = 1;
                  log(" enterd req");
                  break;
                }
              }
            }
            if (flag == 1) {
              continue;
            }
            //checking user in send request or not
            if (sendRequest.docs.isNotEmpty) {
              for (var sended in sendRequest.docs) {
                if (element.data()["userId"] == sended.data()["userId"]) {
                  temp.add(Bot(
                      uid: element.data()["userId"],
                      email: element.data()["email"],
                      state: BotsState.pending,
                      photo: element.data()["photo"] ??
                          "assets/images/nullPhoto.jpeg",
                      username: element.data()["userName"] ?? ""));
                  log(" enterd pending ${element.data()["userId"]}");
                  flag = 1;
                  break;
                }
              }
            }
            if (flag == 1) {
              continue;
            }
            if (connections.docs.isNotEmpty) {
              for (var connection in connections.docs) {
                if (element.data()["userId"] == connection.data()["botid"]) {
                  temp.add(Bot(
                      uid: element.data()["userId"],
                      email: element.data()["email"],
                      state: BotsState.connected,
                      photo: element.data()["photo"] ??
                          "assets/images/nullPhoto.jpeg",
                      username: element.data()["userName"] ?? ""));
                  log(" enterd connected");
                  flag = 1;
                  break;
                }
              }
            }
            if (flag == 1) {
              continue;
            } else {
              temp.add(Bot(
                  uid: element.data()["userId"],
                  email: element.data()["email"],
                  state: BotsState.connect,
                  photo:
                      element.data()["photo"] ?? "assets/images/nullPhoto.jpeg",
                  username: element.data()["userName"] ?? ""));
            }
          }
        }
        allUser = temp;
        log(" list count${allUser.length}");
        add(ProvidUserListEvent(alluser: allUser));
      });
    });
    on<ProvidUserListEvent>((event, emit) {
      log("enter ther provereven ${event.alluser.length}");
      emit(OtherUsers(bots: event.alluser));
    });
    //send request
    on<SendRequestEvent>((event, emit) async {
      log("send request");
      await chatService
          .sendRequest(event.botId)
          .then((value) => emit(OtherUsers(bots: allUser)));
    });
    //accept request
    on<AcceptRequestEvent>((event, emit) async {
      await chatService.connnections(event.botId);
    });
    //remove request
    on<RemoveRequestEvent>((event, emit) async {
      await chatService.removeRequest(event.botId);
    });
    //dicline request
    on<DeclineRequestevent>((event, emit) async {
      chatService.diclineRequest(event.botId);
    });
  }
}
