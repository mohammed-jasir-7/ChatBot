import 'dart:developer';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:chatbot/Models/user_model.dart';
import 'package:chatbot/Service/chat/chat_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';

part 'chat_event.dart';
part 'chat_state.dart';

class ChatBloc extends Bloc<ChatEvent, ChatState> {
  ChatBloc() : super(ChatInitial()) {
    final chatService = ChatService();
    on<EnterToChatEvent>((event, emit) async {
      log("enter chat event ${event.bot.uid}");
      log("after chat first screennn");
      String roomID = await chatService.onCreateRoomId(event.bot.uid);
      await chatService.connnections(event.bot.uid);

      emit(LoadingState());

      emit(ChatFirstState(bot: event.bot, roomID: roomID));

      FirebaseFirestore.instance
          .collection("users")
          .doc(event.bot.uid)
          .snapshots()
          .listen((event) {
        if (event.get("isOnline")) {
          log("online");
          add(OnlineEvent());
        } else {
          log("offline");
          add(OfflineEvent());
        }
      });
    });

    on<OnlineEvent>((event, emit) => emit(OnlineState()));
    on<OfflineEvent>((event, emit) => emit(OfflineState()));
    on<SendMessageEvent>((event, emit) async {
      chatService.onMessaging(message: event.messages, roomID: event.roomID);
    });
    // on<FetchmessagesEvent>((event, emit) async {
    //   await emit.forEach(
    //     FirebaseFirestore.instance
    //         .collection("chatroom")
    //         .doc(roomID)
    //         .collection("chats")
    //         .snapshots(),
    //     onData: (data) {
    //       log("enter");
    //     },
    //   );
    //   await FirebaseFirestore.instance
    //       .collection("chatroom")
    //       .doc(roomID)
    //       .collection("chats")
    //       .snapshots()
    //       .listen((event) {
    //     emit(ChatData(chats: event.docs));
    //     log("listniing");
    //   });
    //   dynamic result = await chatService.fetchmessages(roomID: roomID!);
    //   if (result is List<QueryDocumentSnapshot<Map<String, dynamic>>>) {
    //     print(result.last.data().keys);
    //     emit(ChatData(chats: result));
    //   }
    // });
  }
}
