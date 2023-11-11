import 'dart:developer';
import 'package:chatbot/Models/message_model.dart';
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

      // emit(LoadingState());

      emit(ChatFirstState(bot: event.bot, roomID: roomID));
    });

//loadmsg event
    on<ChatLoadingEvent>((event, emit) {
      final message = FirebaseFirestore.instance
          .collection("chatroom")
          .doc(event.roomId)
          .collection("chats")
          .orderBy("time", descending: true)
          .snapshots()
          .listen((value) async {
        List<PersonalMsgModel> allmessages = [];

        for (var msg in value.docs) {
          String time = msg.data()["time"] != null
              ? (msg.data()["time"] as Timestamp).toDate().toString()
              : DateTime.now().toString();

          allmessages.add(PersonalMsgModel(
              image: msg.data()["image"],
              message: msg.data()["message"],
              time: time,
              sendby: msg.data()["sendby"],
              messageType: msg.data()["messageType"],
              isRead: msg.data()["isread"]));
          log("ggggggggggggggggggg");
        }
        add(ProvideChatEvent(allMessages: allmessages));
      });
    });
    //online anf offline event

    //===================================================================
    on<SendMessageEvent>((event, emit) async {
      chatService.onMessaging(message: event.messages, roomID: event.roomID);
    });
    //initial event
    // on<ChatInitialEvent>((event, emit) => emit(ChatInitial()));
    //provide all messages
    on<ProvideChatEvent>((event, emit) =>
        emit(PovideAllMessageState(allMessages: event.allMessages)));
  }
}
