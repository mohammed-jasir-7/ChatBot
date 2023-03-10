import 'dart:developer';
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

    /// enter event that time create room id
    /// and check user is online or not and live ithe chat
    on<EnterToChatEvent>((event, emit) async {
      String roomID = await chatService.onCreateRoomId(event.bot.uid);
      await chatService.connnections(event.bot.uid);

      emit(LoadingState());

      emit(ChatFirstState(bot: event.bot, roomID: roomID));

      FirebaseFirestore.instance
          .collection("users")
          .doc(event.bot.uid)
          .snapshots()
          .listen((data) {
        if (data.get("isOnline")) {
          log("kkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkkk ${data.get("isOnline")} ${event.bot.email}");
          log("online bloc");
          add(OnlineEvent());
        } else {
          log("gggggggggggggggggggggggggggggg ${data.get("isOnline")}");
          log("offline bloc");
          add(OfflineEvent());
        }
      });
    });
    //online anf offline event

    on<OnlineEvent>((event, emit) => emit(OnlineState()));
    on<OfflineEvent>((event, emit) => emit(OfflineState()));
    //===================================================================
    on<SendMessageEvent>((event, emit) async {
      chatService.onMessaging(message: event.messages, roomID: event.roomID);
    });
    //request event
    on<SendRequestEvent>((event, emit) async {
      await chatService
          .sendRequest(event.botId)
          .then((value) => emit(PendingState()));
    });
  }
}
