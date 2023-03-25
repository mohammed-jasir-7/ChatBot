import 'dart:developer';

import 'package:chatbot/Models/user_model.dart';
import 'package:chatbot/Service/group%20service/group_service.dart';
import 'package:chatbot/util.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:injectable/injectable.dart';
import '../../Models/group_model.dart';
import '../../Models/select_model.dart';
part 'group_functionality_event.dart';
part 'group_functionality_state.dart';

@Injectable()
class GroupFunctionalityBloc
    extends Bloc<GroupFunctionalityEvent, GroupFunctionalityState> {
  final GroupServices groupServices;
  final FirebaseFirestore firestore;
  final FirebaseAuth firebaseAuth;

  GroupFunctionalityBloc(
      {required this.groupServices,
      required this.firestore,
      required this.firebaseAuth})
      : super(MembersLoadedState.initial(isloading: true, members: [])) {
    on<FetchMembersEvent>((event, emit) async {
      final streamOfMembers = firestore
          .collection("groupChat")
          .doc(event.groupId)
          .collection("members")
          .snapshots();
      final refOfUsers = firestore.collection("users");
// get all users
      final users = await refOfUsers.get();
      streamOfMembers.listen((event) {
        final List<GroupMember> members = [];
        GroupMember? currentUser;
        for (var member in event.docs) {
          for (var user in users.docs) {
            if (user.data()["userId"] == member.data()["botId"]) {
              if (user.data()["userId"] == firebaseAuth.currentUser!.uid) {
                currentUser = GroupMember(
                    uid: user.data()["userId"],
                    username: user.data()["userName"],
                    photo: user.data()["photo"],
                    email: user.data()["email"],
                    isAdmin: member.data()["isAdmin"],
                    isOwner: member.data()["isOwner"]);
                break;
              } else {
                members.add(GroupMember(
                    uid: user.data()["userId"],
                    username: user.data()["userName"],
                    photo: user.data()["photo"],
                    email: user.data()["email"],
                    isAdmin: member.data()["isAdmin"],
                    isOwner: member.data()["isOwner"]));
                break;
              }
            }
          }
        }

        add(ProvideMembrsEvent(members: members, currentUser: currentUser));
      });
    });
    on<ProvideMembrsEvent>((event, emit) => emit(MembersLoadedState(
        isloading: false,
        members: event.members,
        currentUser: event.currentUser)));

// add members      ===============================================================================================
    on<AddMembersEvent>((event, emit) async {
      emit(ProvideUserListState(isLoading: true));
      List<SelectModel> listOfusers = [];
      // geting all group members
      final groupMembers = await firestore
          .collection("groupChat")
          .doc(event.groupId)
          .collection("members")
          .get();

//getting all connection
      final connections = await firestore
          .collection("users")
          .doc(firebaseAuth.currentUser!.uid)
          .collection("connections")
          .get();

      /// checking connected members allready in groups
      /// if user not in a list provide to add screen
      for (var connection in connections.docs) {
        int flag = 0;
        for (var members in groupMembers.docs) {
          if (connection.data()["botid"] == members.data()["botId"]) {
            flag = 1;
          }
        }
        if (flag == 0) {
          final user = await firestore
              .collection("users")
              .doc(connection.data()["botid"])
              .get();
          listOfusers.add(SelectModel(
              bot: Bot(
                  uid: user.data()?["userId"],
                  email: user.data()?["email"],
                  state: BotsState.connected,
                  photo: user.data()?["photo"],
                  username: user.data()?["userName"]),
              isselected: false));
        }
      }

      emit(ProvideUserListState(isLoading: false, user: listOfusers));
    });
    on<AddMembersToDbEvent>((event, emit) async {
      log("add membrs event");
      List<String> users = event.selectedBots.map((e) => e.bot.uid).toList();
      await groupServices.addMember(
          members: users, groupId: event.groupId, gName: event.gName);
      add(FetchMembersEvent(groupId: event.groupId));
    });

    //make admin
    on<MakeAdminEvent>((event, emit) async {
      await groupServices.makeAdmin(
          groupId: event.groupId, selectedId: event.selectedId);
    });
    //remove admin
    on<RemoveAsAdmin>((event, emit) async {
      await groupServices.removeAdmin(
          groupId: event.groupId, selectedId: event.selectedId);
    });
    //remove user
    on<RemoveUserEvent>((event, emit) async {
      await groupServices.removeMember(
          groupId: event.groupId, selectedId: event.selectedId);
    });

    ///fetch curretUser details and chek he is an admin or not
    on<FetchCurrentUserEvent>((event, emit) {});
    //AdminOnly message
    on<AdminOnlyMessageEvent>((event, emit) async {
      log("admin only massgfeeeee");
      await groupServices.adminOnlyMssage(
          groupId: event.groupId, currentState: event.currentState);
    });
    //exit group
    on<ExitGroup>((event, emit) async {
      final result = await groupServices.exitGroup(
          groupId: event.groupId, currentUserId: firebaseAuth.currentUser!.uid);
      if (result is bool && result == true) {
        emit(ExitedGroup());
      }
    });
    //dismiss group
    on<DismissGroup>((event, emit) async {
      groupServices.dismissGroup(groupId: event.groupId);
      emit(DismissState());
    });
    // initial event
    on<GroupFunctionalityInitialEvent>((event, emit) =>
        emit(MembersLoadedState.initial(isloading: true, members: [])));
  }
}
