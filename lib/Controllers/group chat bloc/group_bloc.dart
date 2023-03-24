import 'dart:async';
import 'dart:developer';
import 'package:chatbot/Models/group_model.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:file_picker/file_picker.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rxdart/rxdart.dart';
import '../../Models/select_model.dart';
import '../../Service/group chat/group_chat_service.dart';
part 'group_event.dart';
part 'group_state.dart';

class GroupBloc extends Bloc<GroupEvent, GroupState> {
  StreamSubscription? combinedStram;
  GroupBloc() : super(GroupchatInitial()) {
    final groupChatService = GroupChatService();
    final currentuser = FirebaseAuth.instance.currentUser!.uid;
    List<GroupModel> groups = [];

    on<CreateGroupEvent>((event, emit) async {
      emit(LoadingState());
      List<String> botlist = event.botsId.map((e) => e.bot.uid).toList();
      await groupChatService.createGroup(
          users: botlist, name: event.name, image: event.image);
      emit(SuccessState());
    });
    // fetch group event
    //===================================================================================================================
    on<FetchGroupsEvent>((event, emit) async {
      log("FetchGroupsEvent");
      // emit loading state
      emit(LoadingState());

      ///listen current users groups
      ///if added in any group it update ui part
      final groupChat =
          FirebaseFirestore.instance.collection("groupChat").snapshots();

      final usersSide = FirebaseFirestore.instance
          .collection("users")
          .doc(currentuser)
          .collection("groups")
          .snapshots();
      combinedStram = CombineLatestStream.list([groupChat, usersSide])
          .listen((value) async {
        List<GroupModel> tempgroups = [];

        for (var grpId in value[1].docs) {
          QueryDocumentSnapshot<Map<String, dynamic>>? result;
          for (var grpData in value[0].docs) {
            if (grpId.data()["groupId"] == grpData.data()["groupId"]) {
              result = grpData;
              break;
            }
          }
          if (result != null) {
            tempgroups.add(GroupModel(
                groupId: result.data()["groupId"],
                name: result.data()["name"],
                adminOnlyMessage: result.data()["adminOnlyMessage"],
                lastMsg: result.data()["lastMsg"],
                sendby: result.data()["sendby"],
                photo: result.data()["image"]));
          }

          groups = tempgroups;
        }
        //emit groups
        add(ProvideGroupsEvent());
        log("provedentEvent");
      });
    });
    //==========================================================================================================================
    on<ProvideGroupsEvent>(
        (event, emit) => emit(GroupListState(groups: groups)));
  }
  @override
  Future<void> close() {
    if (combinedStram != null) {
      combinedStram!.cancel();
    }

    return super.close();
  }
}
