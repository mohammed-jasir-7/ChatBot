import 'dart:developer';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import 'package:rxdart/rxdart.dart';
import '../../Models/group_model.dart';
import '../../Models/message_model.dart';
import '../../Service/group chat/group_chat_service.dart';
part 'gchat_event.dart';
part 'gchat_state.dart';

@Injectable()
class GchatBloc extends Bloc<GchatEvent, GchatState> {
  final FirebaseFirestore firestore;
  GchatBloc({required this.firestore}) : super(GchatInitial()) {
    final groupChatService = GroupChatService();

    String? currentuserName;
    String? currentuserImage;

    //onsend msg ========================================================================================================
    on<SendMessageEvent>((event, emit) async {
      groupChatService.sendMessage(
          userName: currentuserName!,
          message: event.message,
          groupId: event.groupId,
          currentUser: FirebaseAuth.instance.currentUser!.uid,
          image: currentuserImage);
    });

    ///fetch message when open chat screeen
    on<FetchMessageEvent>((event, emit) async {
      emit(LoadingState());
      await FirebaseAuth.instance.currentUser!.reload();
      final userName = await FirebaseFirestore.instance
          .collection('users')
          .doc(FirebaseAuth.instance.currentUser!.uid)
          .get();
      currentuserName = userName.data()!["userName"];
      currentuserImage = userName.data()!["photo"];
      log("");
      final members = FirebaseFirestore.instance
          .collection("groupChat")
          .doc(event.groupId)
          .collection("members")
          .snapshots();

      final messages = FirebaseFirestore.instance
          .collection("groupChat")
          .doc(event.groupId)
          .collection("chat")
          .orderBy("time", descending: true)
          .snapshots();

      CombineLatestStream.list([members, messages]).listen((value) async {
        List<GroupMsgModel> allmessages = [];
        GroupMember? currentUserData;
//current user data
        //for showing gorup members list
        //==================================================
        for (var element in value[0].docs) {
          if (element.data()["botId"] ==
              FirebaseAuth.instance.currentUser!.uid) {
            final user = await FirebaseFirestore.instance
                .collection("users")
                .doc(element.data()["botId"])
                .get();
            if (user.data() != null) {
              currentUserData = GroupMember(
                  uid: user.data()?["userId"],
                  username: user.data()?["userName"],
                  email: user.data()?["email"],
                  isAdmin: element.data()["isAdmin"],
                  isOwner: element.data()["isOwner"]);
            }
          }
        }
        //===============================================
        for (var msg in value[1].docs) {
          final time = (msg.data()["time"] as Timestamp).toDate().toString();

          allmessages.add(GroupMsgModel(
              image: msg.data()["image"],
              username: msg.data()["userName"],
              message: msg.data()["message"],
              time: time,
              sendby: msg.data()["sendby"]));
        }
        log("mesage length ${allmessages.length} member${members.length}");

        add(ProvideDataToGroupEvent(
            allmessages: allmessages, currentUser: currentUserData));
      });
    });
    on<ProvideDataToGroupEvent>((event, emit) {
      emit(LoadingState());
      emit(AllMessageState(
        allmessages: event.allmessages,
        members: event.currentUser,
        currentUsername: currentuserName!,
      ));
    });
    on<GchatInitialEvent>((event, emit) => emit(GchatInitial()));
  }
}
